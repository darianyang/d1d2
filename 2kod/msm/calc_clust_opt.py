import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import deeptime
import pickle
import wedap
from tqdm.auto import tqdm

model_name = "2024-05-27_D1D2_13k_dmat"
vamp_data = np.load(f"{model_name}/vamp.npy")
features = vamp_data

# Run K-means on multiple different cluster numbers to find an optimal n_clusters
clusters = []
dtrajs = []
for n in [100, 300, 800, 1500, 3000]:
    # n_jobs=-1 uses all avail threads (default=None, which uses 1 n_jobs)
    cluster = deeptime.clustering.KMeans(n_clusters=n, max_iter=500, progress=tqdm, n_jobs=8)
    dtraj = cluster.fit_transform(features)
    dtrajs.append(dtraj)
    clusters.append(cluster.fetch_model())

# Write data
with open(f'{model_name}/clusters_opt.pickle','wb') as file:
    pickle.dump(clusters, file)
with open(f'{model_name}/dtrajs_opt.pickle','wb') as file:
    pickle.dump(dtrajs, file)
