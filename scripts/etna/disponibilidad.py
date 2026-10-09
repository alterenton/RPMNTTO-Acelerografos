import subprocess

ruta_datos = {
    "sotano": r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-055__Design\data1\data\events"
}

tiempo_inicial = "2020-06-08T12:00:00"
tiempo_final = "2022-10-16T12:00:00"

def aguardar(n, datos):
    if n==0:
        subprocess.run(["obspy-scan", "--print-gaps", "--start-time", tiempo_inicial, "--end-time", tiempo_final, ruta_datos["sotano"]], check=True)
    else:
        subprocess.run(["obspy-scan", "--output", "disponibilidad.png", datos], check=True)

aguardar(0, ruta_datos["sotano"])