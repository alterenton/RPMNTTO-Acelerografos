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

fig, axes = plt.subplots(len(st), 1, figsize=(16,10), sharex=True)

for ax, tr in zip(axes, st):
    fs = tr.stats.sampling_rate

    inicio = tr.stats.starttime
    fin = tr.stats.endtime

    duracion = fin - inicio

    Pxx, freqs, bins, im = ax.specgram(
        tr.data.astype(float),
        NFFT=1024,
        Fs=fs,
        noverlap=512
    )
    ax.set_ylim(
        0,
        min(10, fs/2)
    )
    texto = (
        f"Canal: {tr.id}\n"
        f"Frecuencia muestreo: {fs:.2f} Hz\n"
        f"Inicio: {inicio.strftime('%Y-%m-%d %H:%M:%S')} UTC\n"
        f"Fin: {fin.strftime('%Y-%m-%d %H:%M:%S')} UTC\n"
        f"Duración: {duracion:.2f} s"
    )
    ax.text(
        0.98,
        0.95,
        texto,
        transform=ax.transAxes,
        ha="right",
        va="top",
        fontsize=9,
        bbox=dict(
            boxstyle="round,pad=0.5",
            facecolor="white",
            alpha=0.85
        )
    )
    ax.set_title(tr.id, loc="left", fontsize=10)
    ax.set_ylabel("Frecuencia [Hz]")
    ax.grid(True, alpha=0.15)

    cbar = fig.colorbar(
        im,
        ax=ax,
        location="right",
        pad=0.02
    )
    cbar.set_label("Potencia [dB]")

def aguardar(n):
    if n==0:
        plt.tight_layout()
        plt.show()
    else:
        fig.savefig("espectrograma.png", bbox_inches="tight")

aguardar(1)