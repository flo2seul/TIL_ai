import numpy as np
# 1. 배열 생성과 속성
print("="*100)
# 1차원 배열 vector
arr1d = np.array([1,2,3,4,5,6])
print(f'1d {arr1d}')
print(f'ndim(차원 수):{arr1d.ndim}')
print(f'shape(형태):{arr1d.shape}')
print(f'dtype(타입):{arr1d.dtype}')
# 2. reshape(형태 변경)
print("="*100)
arr2d = arr1d.reshape(2,3)
print(f'reshape(2,3):{arr2d}')
print(f'shape(형태):{arr2d.shape}')
print(f'dtype(타입):{arr2d.dtype}')
# 2행 -1은 나머지 알아서
arr_auto = arr1d.reshape(3,-1)
print(f'reshape(3,-1):\n{arr_auto}')

vector_id = np.array([1,2,3])
print(f'id vector:{vector_id.shape}')
# 행벡터 (1항 n열)
row_vec = vector_id.reshape(1,-1)
print(f'row vector(1x3):\n{row_vec}')
print(f'shape:{row_vec.shape}')
# 열벡터 (n항 1열)
col_vec = vector_id.reshape(-1,1)
print(f'col vector(3x1):\n{col_vec}')
print(f'shape:{col_vec.shape}')
# 행렬의 결합 (concat)
print("="*100)
A = np.array([[1,2],[3,4]])
B = np.array([[5,6],[7,8]])
print(f'A:\n{A}')
print(f'B:\n{B}')
# 수직 결합
v_stack = np.vstack((A,B))
print(f'\n[vstack] 위아래 결합:\n{v_stack}')
print(f'shape {v_stack.shape}')
# 수평 결합
h_stack = np.hstack((A,B))
print(f'\n[hstack] 옆으로 결합:\n{h_stack}')
print(f'shape {h_stack.shape}')
print("="*100)
# 브로드캐스팅
C = np.array([[10], [20]])
result = A + C
print(f'result(A + C)\n{result}')
