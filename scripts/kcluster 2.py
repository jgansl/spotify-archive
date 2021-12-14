# https://realpython.com/k-means-clustering-python/
# https://duckduckgo.com/?q=spoitpy+klcustering+python&ia=web
import matplotlib.pyplot as plt
from kneed import KneeLocator
from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import StandardScaler
from sklearn import preprocessing

def getGenre(g='folk'):
   return get_track_ids(pname('folk'))


features, true_labels = make_blobs(
                           n_samples=200,
                           centers=3,
                           cluster_std=2.75,
                           random_state=42
                        )

#...get track features -> spotify_base
x = df.values 
min_max_scaler = preprocessing.MinMaxScaler()
x_scaled = min_max_scaler.fit_transform(x)
df = pd.DataFrame(x_scaled)
# https://towardsdatascience.com/k-means-clustering-using-spotify-song-features-9eb7d53d105c
columns = [
   "acousticness", 
   "danceability",
   "energy",  
   "instrumentalness", 
   "key"
   "liveness", 
   "loudness",
   "speechiness", 
   "tempo",
   "time_signature", 
   "valence", 
]

perm = permutations(columns, 3)
output = set(map(lambda x: tuple(sorted(x)),perm))