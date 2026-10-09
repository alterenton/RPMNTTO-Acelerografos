import obspy
import numpy as np
import matplotlib.pyplot as plt

archivo_calibracion = r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-054__SanFelipe890\DataAzotea\Calibracion\2026-10-02-2146-44S.JM61N_003.MSEED"

st = obspy.read(archivo_calibracion)

orden = {
    "Z": 0,
    "N": 1,
    "E": 2
}
st.traces.sort(key=lambda tr: orden.get(tr.stats.channel[-1], 99))

# ------------------------------------------------------------
# FACTORES DE CONVERSIÓN
# ------------------------------------------------------------

# Factor utilizado en tu script anterior:
#
# 0.000476804 / 1000
# = 4.76804e-7 g/cuenta
#
CUENTAS_A_G = 4.76804e-7

# 1 g = 980.665 cm/s²
# 1 Gal = 1 cm/s²
G_A_GAL = 980.665

fig, axes = plt.subplots(
    len(st),
    1,
    figsize=(12, 7),
    sharex=True
)

for ax, tr in zip(axes, st):
    data = tr.data.astype(float)
    maximo = np.max(data)
    minimo = np.min(data)
    
    amplitud_pp = maximo - minimo
    amplitud_g = amplitud_pp/2 * CUENTAS_A_G
    amplitud_gal = amplitud_g * G_A_GAL

    tiempo = tr.times("matplotlib")
    manager = plt.get_current_fig_manager()
    manager.window.showMaximized()
    ax.plot(
        tiempo,
        data,
        linewidth=1.2,
        label=f"{tr.stats.channel}"
    )
    ax.set_xlabel("Tiempo [s]")
    ax.set_ylabel("Aceleración [g]")
    ax.grid(True, linestyle="--", alpha=0.5)
    ax.legend()
    plt.tight_layout()
    plt.show(block=False)

    puntos = plt.ginput(2, timeout=-1)
    punto_a, punto_b = puntos
    if punto_a[1] > punto_b[1]:
        punto_max = punto_a
        punto_min = punto_b
    else:
        punto_max = punto_b
        punto_min = punto_a

    tiempo_max, valor_max = punto_max
    tiempo_min, valor_min = punto_min

    diferencia_valor = valor_max - valor_min
    diferencia_g = diferencia_valor/2 * CUENTAS_A_G
    diferencia_gal = diferencia_g * G_A_GAL

    ax.scatter(
        [tiempo_max],
        [valor_max],
        s=60,
        marker="o",
        zorder=5
    )
    ax.scatter(
        [tiempo_min],
        [valor_min],
        s=60,
        marker="o",
        zorder=5
    )
    texto = (
        f"{tr.stats.channel}\n"
        f"Manual: {diferencia_gal:.3f} cm/s2 (gal) | {diferencia_g:.3f} g\n"
        f"Automático: {amplitud_gal:.3f} cm/s2 (gal) | {amplitud_g:.3f} g"
    )
    ax.legend([texto], fontsize=9)
    plt.draw()

def aguardar(n):
    if n == 0:
        plt.tight_layout()
        plt.show()
    else:
        fig.savefig("aceleracion.png", bbox_inches="tight")

aguardar(1)