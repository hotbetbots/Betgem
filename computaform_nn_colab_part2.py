
# 📘 COMPUTAFORM INTELLIGENCE ENGINE - PART 2
# Comment Clustering & Tip Engine Training Setup

# ✅ STEP 1: Load Previous DataFrame (Assumes Part 1 already run)
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

# ✅ STEP 2: Comment Clustering (Group Similar Computaform Tips)
embeddings = np.stack(df["embedding"].values)
n_clusters = 15  # Can be tuned
kmeans = KMeans(n_clusters=n_clusters, random_state=42)
df["comment_cluster"] = kmeans.fit_predict(embeddings)

# ✅ STEP 3: Dimensionality Reduction for Visual Debug
pca = PCA(n_components=2)
reduced = pca.fit_transform(embeddings)

plt.figure(figsize=(10,6))
plt.scatter(reduced[:,0], reduced[:,1], c=df["comment_cluster"], cmap="tab10")
plt.title("Comment Clustering (Unsupervised)")
plt.xlabel("PC1")
plt.ylabel("PC2")
plt.grid(True)
plt.show()

# ✅ STEP 4: Save Clustered Comment Dataset for Future Training
df.to_csv("clustered_comments.csv", index=False)

# ✅ STEP 5: Preview Clustered Comments
for i in range(n_clusters):
    print(f"\n🧠 Cluster {i} Sample Comments:")
    print(df[df["comment_cluster"] == i]["raw_comment"].head(3).to_string(index=False))
