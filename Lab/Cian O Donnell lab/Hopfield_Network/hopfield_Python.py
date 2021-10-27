import numpy as np
import matplotlib.pyplot as plt
import random


# initialise weight matrix
num_neurons = 784
W = np.zeros([num_neurons,num_neurons])


# load data
train_images=np.genfromtxt('train_images.csv',delimiter=',')
test_images=np.genfromtxt('test_images.csv',delimiter=',')


# set weights from training images
for i in range(num_neurons):
    for j in range(num_neurons):
        for k in range(3):
            W[i,j] += 0.33333*train_images[k][i]*train_images[k][j]
for i in range(num_neurons):
    W[i,i] = 0

# function for updating state asynchronously
def updateState(x):
    ind = random.choice(range(784))
    total_input = np.sum(np.dot(W[ind,:],x))
    if total_input>=0:
        x[ind] = 1
    else:
        x[ind] = -1
    return x

# test image 0
x = np.copy(test_images[0])
plt.imshow(np.reshape(x,(28,28)))
plt.show()
for t in range(1000):
    x = updateState(x)
plt.imshow(np.reshape(x,(28,28)))
plt.show()
for t in range(2000):
    x = updateState(x)
plt.imshow(np.reshape(x,(28,28)))
plt.show()


# test image 1
x = np.copy(test_images[1])
plt.imshow(np.reshape(x,(28,28)))
plt.show()
for t in range(1000):
    x = updateState(x)
plt.imshow(np.reshape(x,(28,28)))
plt.show()
for t in range(2000):
    x = updateState(x)
plt.imshow(np.reshape(x,(28,28)))
plt.show()
