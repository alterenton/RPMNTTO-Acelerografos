import obspy
import numpy as np
import matplotlib.pyplot as plt

archivo_calibracion = r"C:\Users\Hyerson\Documents\GitHub\RPMNTTO-Acelerografos\scripts\titan\SI40N_titanSMA_1375_20260921_164428.seed"

st = obspy.read(archivo_calibracion)

orden = {
        "Z": 0,
        "N": 1,
        "E": 2
    }
st.traces.sort(key=lambda tr: orden.get(tr.stats.channel[-1], 99))

fig, axes = plt.subplots(
        len(st),
        1,
        figsize=(12,7),
        sharex=True
    )

for ax, tr, i in zip(axes, st, "ZNE"):
    data = tr.data.astype(float)
    maximo = np.max(data)
    minimo = np.min(data)
    amplitud_pp = maximo - minimo
    tiempo = tr.times("matplotlib")
    ax.plot(
            tiempo,
            data,
            linewidth=1.2
        )
    ax.grid(
        True,
        alpha=0.5
    )
    texto = (
            f"PE.SI30N.01.HN{i}\n"
            f"Máximo: {maximo:.0f} counts\n"
            f"Mínimo: {minimo:.0f} counts\n"
            f"P-P: {amplitud_pp:.0f} counts"
        )
    ax.legend(
            [texto],
            loc="upper right",
            fontsize=9
        )

def aguardar(n):
    if n==0:
        plt.tight_layout()
        plt.show()
    else:
        fig.savefig("cuentas.png", bbox_inches="tight")

aguardar(0)