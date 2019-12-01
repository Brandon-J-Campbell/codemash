# Lab 4: Deep Learning

In this lab we will use Keras framework to build deep learning neural networks to build a classifier that can assiss in recognition of handwritten digits.

1. Access your cloud / local environment (as per pre-requisites)
2. Create a new iPython notebook
3. Import **Keras** and additional libraries as below:

    * import keras
    * from keras.datasets import mnist
    * from keras.models import Sequential
    * from keras.layers import Dense
    * from keras.optimizers import RMSprop

4. Fetch **MNIST** dataset that's available as a part of Keras framework:
    * use mnist.load_data() method and assign training and testing set

5. Pre-process data by reshaping input data, as well as training and test labels

6. Deine a fully connected neural network (with 2 layers) that classifies input image data into 10 categories [0...9]

7. Specify model evaluation metrics and loss funcion, by using **compile** method:
    * loss='categorical_crossentropy' - how network measures its performance on the training data and steers itself into right direction
    * optimizer=RMSprop() - the mechanism how the network will update itself on the data it sees and the loss it regenerates
    * metrics=['accuracy']

8. Fit model with input images:
    * specify batch size (128 or another)
    * specify num of epochs (training runs) - between 5 and 10 (for tutorial)

9. Evaluate the model