import subprocess

datos_sotano = r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-052__TorredelParque1\DataSotanoTorreparque1\Data\2026"
datos_azotea = r"C:\Users\Hyerson\Documents\Informes_Mantenimientos\RPMNTTO-2026-052__TorredelParque1\DataAzoteaTorreparque1\Data"

subprocess.run(["obspy-scan", "--output", "disponibilidad.png", datos_azotea], check=True)