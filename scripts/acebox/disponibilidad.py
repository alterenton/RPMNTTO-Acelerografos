import subprocess

# Rutas para los archivos de datos de los acelerógrafos en cada ubicación
sotano = r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-054__SanFelipe890\DataSotano\Data\DATALOG"
azotea = r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-054__SanFelipe890\DataAzotea\Data\DATALOG"

def aguardar(n, datos):
    if n==0:
        subprocess.run(["obspy-scan", "--print-gaps", datos], check=True)
    else:
        subprocess.run(["obspy-scan", "--output", "disponibilidad.png", datos], check=True)

aguardar(0, azotea)