# Lab 3: Unsupervised Learning (Using K-Means Clustering)

## Data Exploration

Let's prepare the data
1.	Import the sklearn datasets module
2.	From the module, load the Iris dataset
3.	Create a Pandas data frame from the Iris data
4.	Add the column names to the data frame from the Iris dataset feature_names
5.	Add the species label (the target) into the data frame from the Iris dataset


## Clustering 

Without training the model, let’s cluster the data by the available features
1.	Import KMeans model from the sklearn cluster module
2.	Instantiate a new KM model and set the number of clusters to 3 (think about what this constructor param means and we’ll discuss)
3.	Fit the KM model with the Iris data we have
4.	After fitting, print the KM model’s labels (the model will label the clusters it has found as 1,2 and 3)
5.	For a clearer indication, scatter plot the Iris data and the clustered data (side by side) using the scatter function in the pyplot module of matplotlib.
6.	What comment can you make with regards to the what the model has learned from the data, versus the “ground truth” of the data?