# Lab 2: Supervised Learning

In this lab we will explore the 1994 U.S. Census dataset, that provides various information about individuals, incluing their annual income. Our task here will be to predict if individual makes more than $50K using supervised learning techniques. 

This kind of request can happen within an NGO, where during a marketing campaign the prospective donors need to be identified and reached out to make a donation. While it can be difficult to determine an individual's income range directly from public sources, we can infer some results from other publically available features.

## Part 1: Data Exploration

Let’s explore the dataset:

1. Import numpy and pandas libraries
2. Use **pandas.read_csv** method to load **us-census-dataset.csv** file into a Pandas Dataframe 
3. Print the first 5 rows of the dataframe
4. Calculate the number of records within the dataset
5. Determine how many people are within each "<=50K" or ">50K" groups (based on "income" column values)
6. Calculate percentage of people in ">50K" group

> Note: Dataset features and available values: 
* **age**: continuous variable
* **workclass**: Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked
* **education**: Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool
* **education-num**: continuous
* **marital-status**: Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse.
* **occupation**: Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces.
* **relationship**: Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried.
* **race**: Black, White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other.
* **sex**: Female, Male.
* **capital-gain**: continuous.
* **capital-loss**: continuous.
* **hours-per-week**: continuous.
* **native-country**: United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands.

## Prepare Data


7. Split data into features (**features_raw**) and target label (**income_raw**)

### Missing values
Our dataset is clean and doesn't contain any missing or invalid data, so we don't need to do any pre-processing. 
However, this is usually not the case in the real world.

### Numerical values

8. Explore numerical features using **describe** method, and investigate the differences between 'age' and 'capital-gain' columns, for instance

As you may see after the step above we have features where values tend to be near a single number, but also some features where values can be extremely small or extremely large. Algorithms can be sensitive to such differences, and we should perform some additional steps to transform and normalise the range of value for each features ('capital-loss' / 'capital-gain' in our case) 
A common practice is to use logarithmic transformation to such ranges, where we keep the scale of values significantly, while keeping the feature distribution shape. 

9. Apply logarithmic transformation to 2 identified columns (Note: Remember that log(0) is **undefined**)

Additionally, it's a common practice to scale numerical data (while keeping the shape of each feature's distribuion as it was). It ensures that each feature is treated equally when a supervised learner algorithm is applied. We'd often scale (normalise) numerical vales to a range [0, 1]. 

**sklearn** library allows to do this by using **sklearn.preprocessing.MinMaxScaler**.

10. Import MinMaxScaler from sklearn.preprocessing
11. Scale numerical features of the previously log-transformed dataset using [MinMaxScaler](http://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.MinMaxScaler.html)


### Categorical values

As you have noticed already we also have non-numerical columns, i.e. education_level and others. Machine Learning algorithms expect to deal with numeric inputs, hence we need to use additional transformation for such columns that can convert them into numerical features. 

One-hot encoding scheme is one of popular methods to achieve that. 
If for example, our census dataset had a feature **pet** with 3 answers (dog, cat, none), after using this transformation it will be replaced by 3 features: **pet_dog**, **pet_cat**, **pet_none**, with 0 and 1 in place to identify the selection.

12. Use **pandas.get_dummies** method to perform one-hot encoding on the previously transformed dataset

13. Transform target label **income** that represented as a categorical variable with 2 responses ["<=50K, >50K"] into respective categories [0, 1].


## Part 2: Build supervised machine learning models

There are lots of supervised models available, and scikit-learn library provides a number of those out-of-the box, such as:
* Decision Trees
* Ensemble Methods (Bagging, AdaBoost, Random Forest, Gradient Boosting)
* K-Nearest Neighbors (KNeighbors)
* Support Vector Machines (SVM)
* and others

For the purpose of the lab we are going to use Decision tree model, and use it with a previously pre-processed and transformed census dataset.

1. Import train_test_split method from sklearn.cross_validation 
2. Split previously transformed dataframes (features_final, income) into training / test sets using train_test_split method:
    a. Save the results of the split into **X_train**, **X_test** for features, **y_train**, **y_test** for target label. 
    b. Specify test set size as 20% of the whole dataset.
    c. Verify the results of the split (num of rows)
3. Import DecisionTreeClassifier model from sklearn.tree
4. Initalise and train the model using X_train, y_train data
5. Score the model using the X_test features
6. Evaluate model predictions using accuracy metric from sklearn.metric against y_test data
7. [Optional] Visualise Decision Tree graph

## Part 3: Feature importance [Optional]
An important task when performing supervised learning on a dataset like ours is to define which features provide the most predictive power. 

1. When you looked at the initial census dataset, with 13 columns, which top 5 would you select that could predict whether a person is earning over or below $50K?

Many of the supervised algorithms in scikit-learn library have **_feature_importance** attribute available to access ranks given to each of the features for a given predictive model 

2. Print the features' importance values based on your model and compare results with your intuitive answer above



