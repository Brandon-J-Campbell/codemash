# Solution to Lab 3.a

# Load the Iris data
from sklearn.datasets import load_iris
iris = load_iris()

# Create a Pandas data frame from the iris data
from pandas import DataFrame
df = DataFrame(iris.data)

# Add the column names to the data frame
df.columns = iris.feature_names
df['TARGET'] = iris.target
df

# Solution to Lab 3.b

# Import the kmeans model
from sklearn.cluster import KMeans

# Instantiate a new km model and set the number of clusters to 3
km = KMeans(n_clusters=3)

# Fit the KM model with the Iris data we have.
km.fit(iris.data)

# What was the result of the clustering?
km.labels_

# Visualise the actual data with our clusters for comparison
import matplotlib.pyplot as plt
X = iris.data[:, :2]
y = iris.target
new_labels = km.labels_

# Plot the identified clusters and compare with the answers
fig, axes = plt.subplots(1, 2, figsize=(16,8))
axes[0].scatter(X[:, 0], X[:, 1], c=y, cmap='gist_rainbow',
edgecolor='k', s=150)
axes[1].scatter(X[:, 0], X[:, 1], c=new_labels, cmap='jet',
edgecolor='k', s=150)
axes[0].set_xlabel('Sepal length', fontsize=18)
axes[0].set_ylabel('Sepal width', fontsize=18)
axes[1].set_xlabel('Sepal length', fontsize=18)
axes[1].set_ylabel('Sepal width', fontsize=18)
axes[0].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[1].tick_params(direction='in', length=10, width=5, colors='k', labelsize=20)
axes[0].set_title('Actual', fontsize=18)
axes[1].set_title('Predicted', fontsize=18)






