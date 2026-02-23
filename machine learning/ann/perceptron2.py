from sklearn.neural_network import MLPClassifier
from sklearn.linear_model import Perceptron
x = [[0,0],[1,0],[0,1],[1,1]]
y = [0, 1, 1, 0]
model = MLPClassifier(hidden_layer_sizes=(4,), activation='tanh',max_iter=1000, random_state=1)
p_model = Perceptron(max_iter=1000, random_state = 1)
#model.fit(x,y)
p_model.fit(x,y)
#print(model.predict(x))
print(p_model.predict(x))