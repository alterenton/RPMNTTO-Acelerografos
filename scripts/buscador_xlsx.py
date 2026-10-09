from pathlib import Path
from datetime import timedelta
from concurrent.futures import ProcessPoolExecutor, as_completed

import openpyxl
import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

from obspy import read, Stream, UTCDateTime


# ============================================================
# CONFIGURACIÓN
# ============================================================

# ------------------------------------------------------------
# PROCESAMIENTO PARALELO
# ------------------------------------------------------------

# Se redujo a 4 para controlar temperatura de CPU.
N_PROCESOS = 6

# Cantidad de eventos procesados por lote.
# Con 50 se permite utilizar más RAM sin lanzar demasiados
# procesos simultáneamente.
BATCH_SIZE = 100


# ------------------------------------------------------------
# CONVERSIÓN DEL ACELERÓGRAFO
# ------------------------------------------------------------

CUENTAS_POR_MM_S2 = 215


# ------------------------------------------------------------
# ARCHIVO DE EVENTOS
# ------------------------------------------------------------

ARCHIVO_EVENTOS = Path(
    "sismos.xlsx"
)

HOJA_EVENTOS = "Muestra"


# ------------------------------------------------------------
# CARPETA DE MINISeed
# ------------------------------------------------------------

CARPETA_DATOS = Path(
    r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-054__SanFelipe890\DataAzotea\Data\DATALOG"
)


# ------------------------------------------------------------
# CARPETA DE SALIDA
# ------------------------------------------------------------

CARPETA_SALIDA = Path(__file__).resolve().parent.parent / "ondas" / "azotea"

CARPETA_SALIDA.mkdir(
    parents=True,
    exist_ok=True
)


# ============================================================
# VENTANAS DE ANÁLISIS
# ============================================================

HORAS_ANTES = 1
HORAS_DESPUES = 1

MINUTOS_PGA_ANTES = 5
MINUTOS_PGA_DESPUES = 5


# ============================================================
# ZONA HORARIA
# ============================================================

# Perú = UTC-5
# Para pasar de hora local a UTC se suman 5 horas.
HORAS_LOCAL_A_UTC = 5


# ============================================================
# CANALES
# ============================================================

CANALES = {
    "E": "HNE",
    "N": "HNN",
    "Z": "HNZ",
}


# ============================================================
# COLORES
# ============================================================

COLORES = {
    "Z": "red",
    "N": "blue",
    "E": "green",
}


# ============================================================
# GRÁFICAS
# ============================================================

mpl.rcParams["path.simplify"] = True
mpl.rcParams["path.simplify_threshold"] = 0.5
mpl.rcParams["pdf.compression"] = 9

MAX_PUNTOS_180MIN = 15000
MAX_PUNTOS_10MIN = 30000


# ============================================================
# FUNCIONES DE EXCEL
# ============================================================

def cargar_eventos_excel():

    print("\n")
    print("=" * 70)
    print("LECTURA DEL CATÁLOGO DE EVENTOS")
    print("=" * 70)

    print(
        f"\nArchivo:\n{ARCHIVO_EVENTOS.resolve()}"
    )

    if not ARCHIVO_EVENTOS.exists():

        raise FileNotFoundError(
            f"No existe el archivo:\n"
            f"{ARCHIVO_EVENTOS.resolve()}"
        )

    wb = openpyxl.load_workbook(
        ARCHIVO_EVENTOS,
        data_only=True,
        read_only=False
    )

    if HOJA_EVENTOS not in wb.sheetnames:

        raise ValueError(
            f"No existe la hoja "
            f"'{HOJA_EVENTOS}'.\n"
            f"Hojas disponibles: "
            f"{wb.sheetnames}"
        )

    hoja = wb[HOJA_EVENTOS]

    datos_visibles = []

    for fila in hoja.iter_rows(
        values_only=False
    ):

        numero_fila = fila[0].row

        if hoja.row_dimensions[
            numero_fila
        ].hidden:

            continue

        valores = [
            celda.value
            for celda in fila
        ]

        datos_visibles.append(
            valores
        )

    wb.close()

    if len(datos_visibles) < 2:

        raise ValueError(
            "No se encontraron datos "
            "visibles en el Excel."
        )

    encabezados = [
        str(x).strip()
        if x is not None
        else ""
        for x in datos_visibles[0]
    ]

    df = pd.DataFrame(
        datos_visibles[1:],
        columns=encabezados
    )

    columnas_requeridas = [
        "REFERENCIA",
        "MAGNITUD",
        "FECHA",
    ]

    faltantes = [
        columna
        for columna in columnas_requeridas
        if columna not in df.columns
    ]

    if faltantes:

        raise ValueError(
            "Faltan columnas en el Excel: "
            + ", ".join(faltantes)
        )

    # --------------------------------------------------------
    # FECHA + HORA
    # --------------------------------------------------------

    df = df.dropna(
        subset=["FECHA"]
    ).copy()

    df["FECHA"] = pd.to_datetime(
        df["FECHA"],
        dayfirst=True,
        errors="coerce"
    )

    df = df.dropna(
        subset=["FECHA"]
    ).copy()

    # --------------------------------------------------------
    # MAGNITUD
    # --------------------------------------------------------

    df["MAGNITUD"] = pd.to_numeric(
        df["MAGNITUD"],
        errors="coerce"
    )

    df = df.dropna(
        subset=["MAGNITUD"]
    ).copy()

    df = df.reset_index(
        drop=True
    )

    print(
        f"\nEventos encontrados: "
        f"{len(df)}"
    )

    print(
        "\nFechas/hora interpretadas:"
    )

    for indice, fila in df.iterrows():

        print(
            f"  {indice + 1}: "
            f"{fila['FECHA'].strftime('%d/%m/%Y %H:%M:%S')}"
        )

    return df


# ============================================================
# CONVERSIÓN DE TIEMPO
# ============================================================

def hora_excel_a_utc(fecha_local):

    fecha_utc = (
        fecha_local
        + timedelta(
            hours=HORAS_LOCAL_A_UTC
        )
    )

    return UTCDateTime(
        fecha_utc.to_pydatetime()
    )


# ============================================================
# DESCUBRIR MINISeed
# ============================================================

def descubrir_archivos():

    print("\n")
    print("=" * 70)
    print("BÚSQUEDA DE ARCHIVOS MINISeed")
    print("=" * 70)

    if not CARPETA_DATOS.exists():

        raise FileNotFoundError(
            f"No existe la carpeta:\n"
            f"{CARPETA_DATOS}"
        )

    # --------------------------------------------------------
    # IMPORTANTE
    # --------------------------------------------------------
    #
    # No buscamos solamente *.mseed.
    #
    # Como tus archivos no tienen extensión, recorremos TODOS
    # los archivos normales y probamos si ObsPy puede reconocerlos
    # como MiniSEED.
    # --------------------------------------------------------

    archivos_fisicos = [
        ruta
        for ruta in CARPETA_DATOS.rglob("*")
        if ruta.is_file()
    ]

    archivos_fisicos.sort()

    print(
        f"\nCarpeta:\n"
        f"{CARPETA_DATOS}"
    )

    print(
        f"\nArchivos encontrados físicamente: "
        f"{len(archivos_fisicos)}"
    )

    archivos_mseed = []

    total = len(
        archivos_fisicos
    )

    for numero, ruta in enumerate(
        archivos_fisicos,
        start=1
    ):

        try:

            # headonly permite reconocer el archivo sin cargar
            # toda la señal a memoria.
            st = read(
                str(ruta),
                headonly=True
            )

            if len(st) > 0:

                archivos_mseed.append(
                    ruta
                )

        except Exception:

            # Si no es MiniSEED, simplemente se ignora.
            pass

        if (
            numero % 100 == 0
            or numero == total
        ):

            print(
                f"\rComprobados: "
                f"{numero}/{total} | "
                f"MiniSEED: "
                f"{len(archivos_mseed)}",
                end=""
            )

    print("\n")

    print(
        f"Archivos reconocidos como MiniSEED: "
        f"{len(archivos_mseed)}"
    )

    return archivos_mseed


# ============================================================
# INVENTARIO
# ============================================================

def crear_inventario(archivos):

    print("\n")
    print("=" * 70)
    print("CREANDO INVENTARIO TEMPORAL")
    print("=" * 70)

    inventario = []

    total = len(archivos)

    for numero, ruta in enumerate(
        archivos,
        start=1
    ):

        try:

            st = read(
                str(ruta),
                headonly=True
            )

            for tr in st:

                canal = tr.stats.channel

                if canal not in (
                    "HNE",
                    "HNN",
                    "HNZ"
                ):
                    continue

                inventario.append({

                    "ruta": str(ruta),

                    "station":
                        tr.stats.station,

                    "network":
                        tr.stats.network,

                    "location":
                        tr.stats.location,

                    "channel":
                        canal,

                    "inicio":
                        tr.stats.starttime,

                    "fin":
                        tr.stats.endtime,

                    "sampling_rate":
                        tr.stats.sampling_rate
                })

        except Exception as e:

            print(
                f"\n⚠️ Error leyendo:"
                f"\n{ruta}"
                f"\n{e}"
            )

        if (
            numero % 100 == 0
            or numero == total
        ):

            print(
                f"\rProcesados: "
                f"{numero}/{total}",
                end=""
            )

    print("\n")

    print(
        f"Registros HNE/HNN/HNZ: "
        f"{len(inventario)}"
    )

    inventario.sort(
        key=lambda x: x["inicio"]
    )

    for canal in (
        "HNE",
        "HNN",
        "HNZ"
    ):

        registros = [
            x
            for x in inventario
            if x["channel"] == canal
        ]

        if registros:

            inicio = min(
                x["inicio"]
                for x in registros
            )

            fin = max(
                x["fin"]
                for x in registros
            )

            print(
                f"\n{canal}:"
            )

            print(
                f"  archivos: "
                f"{len(registros)}"
            )

            print(
                f"  inicio: "
                f"{inicio}"
            )

            print(
                f"  fin: "
                f"{fin}"
            )

        else:

            print(
                f"\n{canal}: "
                f"NO ENCONTRADO"
            )

    return inventario


# ============================================================
# BUSCAR ARCHIVOS
# ============================================================

def buscar_archivos_en_ventana(
    inventario,
    canal,
    inicio,
    fin
):

    registros = [

        registro

        for registro in inventario

        if registro["channel"] == canal

        and registro["fin"] >= inicio

        and registro["inicio"] <= fin
    ]

    registros.sort(
        key=lambda x: x["inicio"]
    )

    return registros


# ============================================================
# CARGAR TRAZA
# ============================================================

def cargar_traza_ventana(
    registros,
    inicio,
    fin
):

    if not registros:
        return None

    stream = Stream()

    archivos_leidos = set()

    for registro in registros:

        ruta = registro["ruta"]

        if ruta in archivos_leidos:
            continue

        archivos_leidos.add(ruta)

        try:

            st = read(ruta)

            for tr in st:

                if (
                    tr.stats.channel
                    != registro["channel"]
                ):
                    continue

                stream += tr

        except Exception as e:

            print(
                f"\n⚠️ Error cargando:"
                f"\n{ruta}"
                f"\n{e}"
            )

    if not stream:
        return None

    stream.sort()

    try:

        stream.merge(
            method=1,
            fill_value="interpolate"
        )

    except Exception as e:

        print(
            f"\n⚠️ Error haciendo merge:"
            f"\n{e}"
        )

        return None

    try:

        stream.trim(
            starttime=inicio,
            endtime=fin
        )

    except Exception as e:

        print(
            f"\n⚠️ Error recortando:"
            f"\n{e}"
        )

        return None

    if len(stream) == 0:
        return None

    return stream[0]


# ============================================================
# REDUCCIÓN MIN-MAX
# ============================================================

def reducir_traza_minmax(
    tr,
    max_puntos
):

    datos = np.asarray(
        tr.data,
        dtype=np.float64
    )

    n = len(datos)

    if n <= max_puntos:
        return tr.copy()

    cantidad_bloques = max(
        1,
        max_puntos // 2
    )

    tam_bloque = max(
        1,
        n // cantidad_bloques
    )

    indices = []

    for inicio in range(
        0,
        n,
        tam_bloque
    ):

        fin = min(
            inicio + tam_bloque,
            n
        )

        bloque = datos[
            inicio:fin
        ]

        if len(bloque) == 0:
            continue

        idx_min = (
            inicio
            + np.argmin(bloque)
        )

        idx_max = (
            inicio
            + np.argmax(bloque)
        )

        if idx_min < idx_max:

            indices.extend([
                idx_min,
                idx_max
            ])

        else:

            indices.extend([
                idx_max,
                idx_min
            ])

    indices = np.unique(
        indices
    )

    idx_pico = np.argmax(
        np.abs(datos)
    )

    if idx_pico not in indices:

        indices = np.append(
            indices,
            idx_pico
        )

    indices = np.sort(
        indices
    )

    tr_reducida = tr.copy()

    tr_reducida.data = datos[
        indices
    ]

    return tr_reducida


# ============================================================
# PREPARAR TRAZA
# ============================================================

def preparar_traza(tr):

    tr = tr.copy()

    tr.data = (
        tr.data.astype(
            np.float64
        )
        / CUENTAS_POR_MM_S2
    )

    tr.detrend(
        "spline",
        order=3,
        dspline=500
    )

    return tr


# ============================================================
# PGA
# ============================================================

def calcular_pga(tr):

    datos = np.asarray(
        tr.data,
        dtype=np.float64
    )

    if len(datos) == 0:
        return None

    idx = np.argmax(
        np.abs(datos)
    )

    pga = float(
        np.abs(
            datos[idx]
        )
    )

    tiempo_pico = (
        tr.stats.starttime
        + idx * tr.stats.delta
    )

    return {
        "pga": pga,
        "idx": idx,
        "tiempo_pico": tiempo_pico
    }


# ============================================================
# GRÁFICA
# ============================================================

def graficar_evento(
    componentes,
    evento,
    duracion,
    ruta_salida
):

    fig, axes = plt.subplots(
        3,
        1,
        figsize=(16, 9),
        sharex=True
    )

    if duracion == "10 min":

        locator = (
            mdates.MinuteLocator(
                interval=1
            )
        )

    else:

        locator = (
            mdates.MinuteLocator(
                byminute=[0, 30]
            )
        )

    formatter = (
        mdates.DateFormatter(
            "%H:%M"
        )
    )

    nombres = {
        "E": "E (HNE)",
        "N": "N (HNN)",
        "Z": "Z (HNZ)",
    }

    for ax, (
        tr,
        nombre,
        pga
    ) in zip(
        axes,
        componentes
    ):

        if tr is None:

            ax.text(
                0.5,
                0.5,
                "Sin datos disponibles",
                transform=ax.transAxes,
                ha="center",
                va="center",
                fontsize=11
            )

            ax.set_ylabel(
                "Aceleración\nmm/s²"
            )

            ax.grid(
                True,
                alpha=0.3
            )

            ax.set_title(
                nombres[nombre],
                loc="left"
            )

            ax.xaxis.set_major_locator(
                locator
            )

            ax.xaxis.set_major_formatter(
                formatter
            )

            continue

        tiempo = tr.times(
            "matplotlib"
        )

        tiempo_local = (
            tiempo
            - (5 / 24)
        )

        ax.plot(
            tiempo_local,
            tr.data,
            color=COLORES[nombre],
            linewidth=0.8
        )

        ax.grid(
            True,
            alpha=0.3
        )

        if pga is not None:

            ax.legend(
                [
                    f"{nombres[nombre]} - "
                    f"PGA: {pga:.0f} mm/s²"
                ],
                loc="upper right"
            )

        ax.set_ylabel(
            "Aceleración\nmm/s²"
        )

        ax.xaxis.set_major_locator(
            locator
        )

        ax.xaxis.set_major_formatter(
            formatter
        )

    titulo = (
        f"{evento['referencia']} | "
        f"M{evento['magnitud']:.1f} | "
        f"Fecha/Hora Local: "
        f"{evento['fecha_local'].strftime('%d/%m/%Y %H:%M:%S')} | "
        f"PGA máximo: "
        f"{evento['pga_max']:.0f} mm/s² | "
        f"Duración: {duracion}"
    )

    fig.suptitle(
        titulo,
        fontsize=11
    )

    axes[-1].set_xlabel(
        "Hora Local"
    )

    fig.autofmt_xdate()

    fig.tight_layout(
        rect=[
            0,
            0,
            1,
            0.96
        ]
    )

    fig.savefig(
        ruta_salida,
        format="pdf",
        bbox_inches="tight",
        pad_inches=0.05
    )

    plt.close(fig)


# ============================================================
# PROCESAMIENTO PESADO DE UN EVENTO
# ============================================================

def procesar_evento(
    numero,
    fila,
    inventario
):

    fecha_local = fila[
        "FECHA"
    ]

    tiempo_evento = (
        hora_excel_a_utc(
            fecha_local
        )
    )

    referencia = str(
        fila["REFERENCIA"]
    )

    magnitud = float(
        fila["MAGNITUD"]
    )

    print(
        f"\n[{numero}] "
        f"{referencia} | "
        f"M{magnitud:.1f} | "
        f"{fecha_local.strftime('%d/%m/%Y %H:%M:%S')}"
    )

    inicio = (
        tiempo_evento
        - HORAS_ANTES * 3600
    )

    fin = (
        tiempo_evento
        + HORAS_DESPUES * 3600
    )

    # --------------------------------------------------------
    # COBERTURA
    # --------------------------------------------------------

    cobertura = {}

    for componente, canal in CANALES.items():

        cobertura[componente] = (
            buscar_archivos_en_ventana(
                inventario,
                canal,
                inicio,
                fin
            )
        )

    # --------------------------------------------------------
    # CARGAR E/N/Z
    # --------------------------------------------------------

    trazas = {
        "E": None,
        "N": None,
        "Z": None,
    }

    for componente in (
        "E",
        "N",
        "Z"
    ):

        registros = cobertura[
            componente
        ]

        if not registros:
            continue

        traza = (
            cargar_traza_ventana(
                registros,
                inicio,
                fin
            )
        )

        if traza is not None:

            trazas[
                componente
            ] = traza

    # --------------------------------------------------------
    # PREPARAR
    # --------------------------------------------------------

    for componente in (
        "E",
        "N",
        "Z"
    ):

        traza = trazas[
            componente
        ]

        if traza is None:
            continue

        try:

            trazas[
                componente
            ] = preparar_traza(
                traza
            )

        except Exception as e:

            print(
                f"\n⚠️ Error preparando "
                f"{componente}: {e}"
            )

            trazas[
                componente
            ] = None

    # --------------------------------------------------------
    # PGA
    # --------------------------------------------------------

    pga_componentes = {
        "E": None,
        "N": None,
        "Z": None,
    }

    resultados = []

    for componente in (
        "Z",
        "N",
        "E"
    ):

        traza = trazas[
            componente
        ]

        if traza is None:
            continue

        resultado = (
            calcular_pga(
                traza
            )
        )

        if resultado is None:
            continue

        pga_componentes[
            componente
        ] = resultado["pga"]

        resultados.append({

            "nombre":
                componente,

            "traza":
                traza,

            **resultado
        })

    # --------------------------------------------------------
    # EVENTO SIN DATOS
    # --------------------------------------------------------

    if not resultados:

        print(
            f"[{numero}] "
            f"⚠ SIN DATOS"
        )

        componentes_180 = []

        for componente in (
            "Z",
            "N",
            "E"
        ):

            componentes_180.append(
                (
                    None,
                    componente,
                    None
                )
            )

        componentes_10 = []

        for componente in (
            "Z",
            "N",
            "E"
        ):

            componentes_10.append(
                (
                    None,
                    componente,
                    None
                )
            )

        evento_grafica = {

            "referencia":
                referencia,

            "magnitud":
                magnitud,

            "fecha_local":
                fecha_local,

            "pga_max":
                0
        }

        return {

            "evento":
                numero,

            "referencia":
                referencia,

            "magnitud":
                magnitud,

            "hora":
                fecha_local.strftime(
                    "%d/%m/%Y %H:%M:%S"
                ),

            "pgae":
                None,

            "pgan":
                None,

            "pgaz":
                None,

            "pga_max":
                0,

            "componentes_180":
                componentes_180,

            "componentes_10":
                componentes_10,

            "evento_grafica":
                evento_grafica
        }

    # --------------------------------------------------------
    # PGA MÁXIMO
    # --------------------------------------------------------

    maximo = max(
        resultados,
        key=lambda x: x["pga"]
    )

    pga_max = maximo[
        "pga"
    ]

    tiempo_pico = maximo[
        "tiempo_pico"
    ]

    print(
        f"[{numero}] "
        f"PGA máximo: "
        f"{pga_max:.2f} mm/s² "
        f"({maximo['nombre']})"
    )

    # --------------------------------------------------------
    # ZOOM ±5 MIN
    # --------------------------------------------------------

    inicio_zoom = (
        tiempo_pico
        - MINUTOS_PGA_ANTES * 60
    )

    fin_zoom = (
        tiempo_pico
        + MINUTOS_PGA_DESPUES * 60
    )

    trazas_zoom = []

    for componente in (
        "Z",
        "N",
        "E"
    ):

        traza = trazas[
            componente
        ]

        if traza is None:

            trazas_zoom.append({
                "nombre":
                    componente,

                "traza":
                    None,

                "pga":
                    None
            })

            continue

        zoom = traza.copy()

        try:

            zoom.trim(
                starttime=inicio_zoom,
                endtime=fin_zoom
            )

        except Exception:

            zoom = None

        if (
            zoom is None
            or len(zoom.data) == 0
        ):

            trazas_zoom.append({
                "nombre":
                    componente,

                "traza":
                    None,

                "pga":
                    None
            })

            continue

        pga_zoom = float(
            np.max(
                np.abs(
                    zoom.data
                )
            )
        )

        trazas_zoom.append({

            "nombre":
                componente,

            "traza":
                zoom,

            "pga":
                pga_zoom
        })

    # --------------------------------------------------------
    # REDUCCIÓN 180 MIN
    # --------------------------------------------------------

    componentes_180 = []

    for componente in (
        "Z",
        "N",
        "E"
    ):

        traza = trazas[
            componente
        ]

        if traza is None:

            componentes_180.append(
                (
                    None,
                    componente,
                    None
                )
            )

            continue

        tr_reducida = (
            reducir_traza_minmax(
                traza,
                MAX_PUNTOS_180MIN
            )
        )

        componentes_180.append(
            (
                tr_reducida,
                componente,
                pga_componentes[
                    componente
                ]
            )
        )

    # --------------------------------------------------------
    # REDUCCIÓN 10 MIN
    # --------------------------------------------------------

    componentes_10 = []

    for item in trazas_zoom:

        traza = item[
            "traza"
        ]

        if traza is not None:

            traza = (
                reducir_traza_minmax(
                    traza,
                    MAX_PUNTOS_10MIN
                )
            )

        componentes_10.append(
            (
                traza,
                item["nombre"],
                item["pga"]
            )
        )

    # --------------------------------------------------------
    # INFORMACIÓN GRÁFICA
    # --------------------------------------------------------

    evento_grafica = {

        "referencia":
            referencia,

        "magnitud":
            magnitud,

        "fecha_local":
            fecha_local,

        "pga_max":
            pga_max
    }

    # --------------------------------------------------------
    # RESULTADO
    # --------------------------------------------------------

    return {

        "evento":
            numero,

        "referencia":
            referencia,

        "magnitud":
            magnitud,

        "hora":
            fecha_local.strftime(
                "%d/%m/%Y %H:%M:%S"
            ),

        "pgae":
            pga_componentes["E"],

        "pgan":
            pga_componentes["N"],

        "pgaz":
            pga_componentes["Z"],

        "pga_max":
            pga_max,

        "componentes_180":
            componentes_180,

        "componentes_10":
            componentes_10,

        "evento_grafica":
            evento_grafica
    }


# ============================================================
# GENERAR PDFs
# ============================================================

def generar_pdfs(resultado):

    numero = resultado[
        "evento"
    ]

    nombre_base = (
        f"evento_{numero}"
    )

    ruta_180 = (
        CARPETA_SALIDA
        / f"{nombre_base}_180min.pdf"
    )

    ruta_10 = (
        CARPETA_SALIDA
        / f"{nombre_base}_10min.pdf"
    )

    graficar_evento(
        resultado[
            "componentes_180"
        ],
        resultado[
            "evento_grafica"
        ],
        "180 min",
        ruta_180
    )

    graficar_evento(
        resultado[
            "componentes_10"
        ],
        resultado[
            "evento_grafica"
        ],
        "10 min",
        ruta_10
    )

    return resultado


# ============================================================
# MAIN
# ============================================================

def main():

    print("\n")
    print("=" * 70)
    print(" ANALIZADOR AUTOMÁTICO DE ONDAS SÍSMICAS")
    print("=" * 70)

    print(
        f"\nProcesos:   {N_PROCESOS}"
    )

    print(
        f"Batch size: {BATCH_SIZE}"
    )

    # ========================================================
    # EXCEL
    # ========================================================

    try:

        df_eventos = (
            cargar_eventos_excel()
        )

    except Exception as e:

        print(
            f"\n❌ Error leyendo "
            f"el Excel:\n{e}"
        )

        return

    # ========================================================
    # MINISeed
    # ========================================================

    try:

        archivos = (
            descubrir_archivos()
        )

    except Exception as e:

        print(
            f"\n❌ Error buscando "
            f"MiniSEED:\n{e}"
        )

        return

    if not archivos:

        print(
            "\n❌ No se encontraron "
            "archivos MiniSEED."
        )

        return

    # ========================================================
    # INVENTARIO
    # ========================================================

    try:

        inventario = (
            crear_inventario(
                archivos
            )
        )

    except Exception as e:

        print(
            f"\n❌ Error creando "
            f"inventario:\n{e}"
        )

        return

    if not inventario:

        print(
            "\n❌ No se encontraron "
            "HNE/HNN/HNZ."
        )

        return

    # ========================================================
    # PREPARAR EVENTOS
    # ========================================================

    eventos = []

    for indice, fila in (
        df_eventos.iterrows()
    ):

        numero = indice + 1

        eventos.append(
            (
                numero,
                fila,
                inventario
            )
        )

    total_eventos = len(
        eventos
    )

    resultados_csv = []

    print("\n")
    print("=" * 70)

    print(
        f"PROCESAMIENTO DE "
        f"{total_eventos} EVENTOS"
    )

    print("=" * 70)

    # ========================================================
    # PROCESAMIENTO POR LOTES
    # ========================================================

    for inicio_lote in range(
        0,
        total_eventos,
        BATCH_SIZE
    ):

        lote = eventos[
            inicio_lote:
            inicio_lote + BATCH_SIZE
        ]

        numero_lote = (
            inicio_lote
            // BATCH_SIZE
            + 1
        )

        total_lotes = (
            (
                total_eventos
                + BATCH_SIZE
                - 1
            )
            // BATCH_SIZE
        )

        print("\n")
        print(
            "=" * 70
        )

        print(
            f"LOTE "
            f"{numero_lote}/"
            f"{total_lotes}"
            f" | "
            f"Eventos "
            f"{inicio_lote + 1}-"
            f"{min(inicio_lote + BATCH_SIZE, total_eventos)}"
        )

        print(
            "=" * 70
        )

        # ----------------------------------------------------
        # WORKERS
        # ----------------------------------------------------

        with ProcessPoolExecutor(
            max_workers=N_PROCESOS
        ) as executor:

            futuros = {

                executor.submit(
                    procesar_evento,
                    numero,
                    fila,
                    inventario
                ):
                    numero

                for numero, fila, inventario
                in lote
            }

            resultados_lote = []

            for futuro in as_completed(
                futuros
            ):

                numero = futuros[
                    futuro
                ]

                try:

                    resultado = (
                        futuro.result()
                    )

                    if resultado is not None:

                        resultados_lote.append(
                            resultado
                        )

                except Exception as e:

                    print(
                        f"\n❌ Error "
                        f"evento {numero}:"
                    )

                    print(e)

        # ----------------------------------------------------
        # ORDENAR LOTE
        # ----------------------------------------------------

        resultados_lote.sort(
            key=lambda x:
            x["evento"]
        )

        # ----------------------------------------------------
        # PDFs
        # ----------------------------------------------------

        print(
            "\nGenerando PDFs del lote..."
        )

        for resultado in (
            resultados_lote
        ):

            try:

                resultado = (
                    generar_pdfs(
                        resultado
                    )
                )

                resultados_csv.append(
                    resultado
                )

            except Exception as e:

                print(
                    f"\n❌ Error "
                    f"generando PDFs "
                    f"del evento "
                    f"{resultado['evento']}:"
                )

                print(e)

                # Aunque falle la generación del PDF,
                # conservamos el resultado del PGA.
                resultados_csv.append(
                    resultado
                )

        print(
            f"\n✓ Lote "
            f"{numero_lote} terminado."
        )

    # ========================================================
    # CSV
    # ========================================================

    if resultados_csv:

        resultados_csv.sort(
            key=lambda x:
            x["evento"]
        )

        filas_csv = []

        for resultado in resultados_csv:

            filas_csv.append({

                "Evento":
                    resultado["evento"],

                "Referencia":
                    resultado["referencia"],

                "Magnitud":
                    round(
                        resultado["magnitud"],
                        1
                    ),

                "Hora":
                    resultado["hora"],

                "PGAE":
                    (
                        round(
                            resultado["pgae"]
                        )
                        if resultado["pgae"]
                        is not None
                        else "-"
                    ),

                "PGAN":
                    (
                        round(
                            resultado["pgan"]
                        )
                        if resultado["pgan"]
                        is not None
                        else "-"
                    ),

                "PGAZ":
                    (
                        round(
                            resultado["pgaz"]
                        )
                        if resultado["pgaz"]
                        is not None
                        else "-"
                    )
            })

        df_resultados = pd.DataFrame(
            filas_csv,
            columns=[
                "Evento",
                "Referencia",
                "Magnitud",
                "Hora",
                "PGAE",
                "PGAN",
                "PGAZ"
            ]
        )

        ruta_csv = (
            CARPETA_SALIDA
            / "pga.csv"
        )

        df_resultados.to_csv(
            ruta_csv,
            index=False,
            sep=";",
            encoding="utf-8-sig"
        )

        print("\n")
        print("=" * 70)
        print("CSV GENERADO")
        print("=" * 70)

        print(
            f"\n{ruta_csv.resolve()}"
        )

        print("\nResumen:")

        print(
            f"  Total eventos: "
            f"{len(df_resultados)}"
        )

        print(
            "\nContenido:"
        )

        print(
            df_resultados.to_string(
                index=False
            )
        )

    else:

        print(
            "\n⚠️ No se generaron "
            "resultados."
        )

    print("\n")
    print("=" * 70)
    print("PROCESAMIENTO FINALIZADO")
    print("=" * 70)


# ============================================================
# EJECUCIÓN
# ============================================================

if __name__ == "__main__":

    main()
