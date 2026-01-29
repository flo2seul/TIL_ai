import numpy as np

#활성 함수 (activation function)
#신호를 보낼 지 말지
def step_function(sum):
    if sum > 0:
        return 1
    return 0

class Perceptron:
    def __init__(self, input_size):
        #가중치 초기화 입력이 2개면 2+1 <-- 1은 편향 bias
        #w1x1 + w2x2 + bias
        self.w = np.zeros(input_size + 1)
    def predict(self, inputs):
        sum = np.dot(inputs, self.w[1:]) + self.w[0]
        # 계산된 합을 활성함수에 넣어 0 or 1 판단
        return step_function(sum)
    def train(self, train_inputs, labels, lr=0.01, epochs=100):
        for _ in range(epochs):
            for inputs, label in zip(train_inputs, labels):
                #1. 현재 가중치로 예측
                pred = self.predict(inputs)
                #2. w + 학습률 * (정답 - 예측) * 입력
                print(f'before:{self.w[1:]},{self.w[0]}')
                self.w[1:] += lr *(label - pred) * inputs
                self.w[0] += lr *(label - pred)

train_data = np.array([
    [0,0],
    [0,1],
    [1,0],
    [1,1]
])
labels = np.array([0,0,0,1]) # and 연산
model = Perception(2) #입력 2개
model.train(train_data, labels, lr=0.1)
# 결과 확인
for i, v in zip(train_data, labels):
    pred = model.predict(i)
    print(f'입력: {i}, 예측:{pred}, 정답:{v}')
print('학습된 내부 가중치')
print(f'가중치(weights):{model.w[1:]}')
print(f'편향(bias):{model.w[0]}')