
### Lab2: Supervised learning

## Part 1. Data exploration and pre-processing

# Load Data
# 1. Import libraries
import numpy as np
import pandas as pd

# 2. Load the US Census 1994 dataset
data = pd.read_csv("Lab2\\us-census-dataset.csv")


# 3. Display first 5 records
data.head(n=5) 

# 4. Total number of records
num_rec = data.shape[0]

# 5a. Number of records where individual's income over $50K
num_over_50K = data[data["income"] == ">50K"].shape[0]

# 5b. Number of records where individual's income less or equal $50K
num_under_50K =  data[data["income"] == "<=50K"].shape[0]

# 6. % of individuals with income over $50K
percent_over_50K = 100 * num_over_50K / (num_over_50K + num_under_50K) 

# Prepare Data

# 7. Split data into features and a target label
income_raw = data['income']
features_raw = data.drop('income', axis = 1)

# 8. Explore the dataset (by deafult only numeric columns)
print(data.describe())

# 9. Logarithmic transformation applied to 'capital-loss' and 'capital-gain' columns
transform_cols = ['capital-gain', 'capital-loss']
features_transformed = pd.DataFrame(data = features_raw)
features_transformed[transform_cols] = features_raw[transform_cols].apply(lambda x: np.log(x + 1))

# Normalise numerical features

# 10. Use MinMaxScaler available in sklearn.preprocessing library
from sklearn.preprocessing import MinMaxScaler

# 11. Initialize MinMaxScaler with default scale (0.1) and apply it to the numerical features in the log-transformed dataset
scaler = MinMaxScaler() 
numerical_cols = ['age', 'education-num', 'capital-gain', 'capital-loss', 'hours-per-week']

features_normalised = pd.DataFrame(data = features_transformed)
features_normalised[numerical_cols] = scaler.fit_transform(features_transformed[numerical_cols])

# Display the first 5 rows of a pre-processed dataset
features_normalised.head(n = 5)

# 12. Apply One-hot encoding to the 'features_log_minmax_transform' data using pandas.get_dummies()
features_final = pd.get_dummies(features_normalised)

# 13. Encode the 'income_raw' data to numerical values
income = income_raw.astype('category').cat.codes

# Print the number of the final features in the dataset after one-hot encoding
encoded = list(features_final.columns)
print("Number of features after data pre-processing steps: {}".format(len(encoded)))

## Part 2. Create a predictive model using Supervised ML.

# 1. Use train_test_split from sklearn.model_selection
from sklearn.model_selection import train_test_split

# 2. Split transformed (in Part 1) dataset into training / test sets (80/20 split) 

X_train, X_test, y_train, y_test = train_test_split (features_final, income, test_size = 0.2)

# Show the results of the split
print("Training set has {} samples.".format(X_train.shape[0]))
print("Testing set has {} samples.".format(X_test.shape[0]))

# 3. Import DecisionTreeClassifier model from sklearn.tree
from sklearn.tree import DecisionTreeClassifier

#4. Initalise and train the model using X_train, y_train data
model = DecisionTreeClassifier()
model.fit(X_train, y_train)

#5. Score the model using the X_test features
predictions_test = model.predict(X_test)

#6. Evaluate model predictions using accuracy metric from sklearn.metric against y_test data
from sklearn.metrics import accuracy_score
model_accuracy = accuracy_score(y_test, predictions_test)
print(model_accuracy)

#7. Visualise the decision tree
from sklearn.tree import export_graphviz
export_graphviz(model, out_file='Lab2\\tree.dot', feature_names = list(features_final),
                rounded = True, proportion = False, precision = 2, filled = True, max_depth = 5)
# To generate an image file using .dot file, use GraphViz software: https://www.graphviz.org


## Part 3. Feature importances

# 2. Extract feature_importances_ values
print(dict(zip(data.columns, model.feature_importances_)))