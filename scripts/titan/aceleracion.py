import obspy
import numpy as np
import matplotlib.pyplot as plt

archivo_calibracion = r"C:\Users\Hyerson\Documents\GitHub\RPMNTTO-Acelerografos\scripts\titan\SI40N_titanSMA_1375_20260921_164428.seed"

st = obspy.read(archivo_calibracion)

orden = {
        "Z": 0,
        "N": 1,
        "E": 2,
    }
st.traces.sort(key=lambda tr:orden.get(tr.stats.channel[-1], 99))

paz_sts2 = {
    "poles": [
        -9.770000e+02 + 3.280000e+02j,
        -9.770000e+02 - 3.280000e+02j,
        -1.486000e+03 + 2.512000e+03j,
        -1.486000e+03 - 2.512000e+03j,
        -5.736000e+03 + 4.946000e+03j,
        -5.736000e+03 - 4.946000e+03j
    ],

    "zeros": [
        -5.150000e+02 + 0.000000e+00j
    ],

    "gain": 1.007700e+16,
    "sensitivity": 2.040000e+05
}

st.detrend()
st.simulate(paz_remove=paz_sts2)

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
    amplitud_gal = amplitud_pp / 2

    amplitud_g = amplitud_gal / 980.665
    amplitud_mg = amplitud_g * 1000
    amplitud_ug = amplitud_g * 1_000_000

    tiempo = tr.times("matplotlib")

    ax.plot(tiempo, data, linewidth=1.2)
    ax.grid(True, alpha=0.5)

    texto = (
            f"PE.SI30N.01.HN{i}\n"
            f"Amplitud: {amplitud_gal:.3f} cm/s2 (gal)\n"
            f"P-P: {amplitud_pp:.3f} gal"
        )
    ax.legend([texto], loc="upper right", fontsize=9)

def aguardar(n):
    if n==0:
        plt.tight_layout()
        plt.show()
    else:
        fig.savefig("aceleracion.png", bbox_inches="tight")

aguardar(0)