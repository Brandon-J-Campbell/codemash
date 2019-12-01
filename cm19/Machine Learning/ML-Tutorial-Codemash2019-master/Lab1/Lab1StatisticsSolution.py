#  Solution to lab 1.a

# Load the Boston dataset
from sklearn import datasets as ds
boston = ds.load_boston()

# Print the keys from the dataset
print(boston.keys())

# Print the feature names from the dataset
print(boston.feature_names)

# Print the data from the dataset
print(boston.data)

# Convert the data to a Pandas Dataframe
import pandas
df = pandas.DataFrame(boston.data)

# Add the column headers to the df
df.columns = boston.feature_names

# Add the PRICE column
df['PRICE'] = boston.target

# Print summary statistics
print(df.describe())

# Plot the PRICE feature
import matplotlib.pyplot as plt
plt.plot(df.PRICE)

# Solution to lab 1.b

# Split the data into output and input variables
in_vars = df.drop('PRICE', axis = 1)
out_vars = df['PRICE']

# Split the data into training and testing sets
import sklearn.model_selection as ms
in_vars_train, in_vars_test, out_vars_train, out_vars_test = \
   ms.train_test_split(in_vars, out_vars, test_size = 0.33, random_state = 5)

print(in_vars_train.shape)
print(in_vars_test.shape)
print(out_vars_train.shape)
print(out_vars_test.shape)

# Train a linear regression model
from sklearn.linear_model import LinearRegression
lm = LinearRegression()
lm.fit(in_vars_train, out_vars_train)

# Score the model using the test data
y_prediction = lm.predict(in_vars_test)

# Plot predicted versus actual prices
plt.scatter(out_vars_test, y_prediction)
plt.xlabel("Prices: $Y_i$")
plt.ylabel("Predicted prices: $\hat{Y}_i$")
plt.title("Prices vs Predicted prices: $Y_i$ vs $\hat{Y}_i$")

# Calculate the MSE for our model
from sklearn import  metrics
mse = metrics.mean_squared_error(out_vars_test, y_prediction)
print(mse)

# Calculate the coefficient of determination for our model
r2 = metrics.r2_score(out_vars_test, y_prediction)
print(r2)
