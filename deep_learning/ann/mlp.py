import torch
import torch.nn as nn
import torch.optim as optim

""" 모델 만들기 """
class SimpleMLP(nn.Module):
    def __init__(self):
        super(SimpleMLP, self).__init__() 
        self.layer1 = nn.Linear(2,4)#입력층(특성 2개) -> 은닉층(노드 4개)
        self.relu = nn.ReLU()# 활성화 함수 (비선형성 추가)
        self.layer2 = nn.Linear(4,1)# 은닉층(노드 4개) -> 출력층(결과 1개)

    def forward(self, x):
        x = self.layer1(x)
        x = self.relu(x)
        x = self.layer2(x)
        return x

""" 학습 준비물 세팅 """   
model = SimpleMLP()
criterion = nn.MSELoss() # 손실 함수 (채점관: 정답과 예측값의 오차 계산)
optimizer = optim.SGD(model.parameters(), lr=0.1) # 옵티마이저 (경사하강법: 오차 줄이는 방향으로 업데이트)

inputs = torch.tensor([[0.5, 0.8]])# 임의의 데이터 (예: 변수 2개짜리 데이터 1건, 정답은 1.0)
target = torch.tensor([[1.0]])

""" 실제 학습 루프 """
for epoch in range(5):
    prediction = model(inputs) #순전파 : 일단 예측해보세여

    loss = criterion(prediction, target) #오차 계산: 정답이랑 얼마나 틀렸어?

    optimizer.zero_grad() #역전파: 틀린 만큼 책임소재(기울기)를 계산하세여
    loss.backward() #여기서 그 복잡한 미분이 일어남

    optimizer.step() #가중치 업데이트: 오차를 줄이는 방향으로 파라미터 수정!

    print(f"반복 {epoch+1} | 오차(Loss): {loss.item():.4f} | 예측값: {prediction.item():.4f}")


