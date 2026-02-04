import pandas as pd
#데이터 전처리
#누락된 값, 중복, 이상한 문자 등..을 꺠끗하게 만드는 과정

data = {
    '이름' : ['철수','영희','민수','지수','철수','동현'],
    '나이' : [23, 45,None,24,46,32],
    '성별' : ['남','여','여',None,'여','남'],
    '점수' : [34, None, 64, 64, 90, 23]
}
df = pd.DataFrame(data)
print('원본')
print(df)
print(df.info())
print(f'결측치 수:\n{df.isnull().sum()}')
df_dropped = df.dropna() #결측치 행 삭제
print(df_dropped)
#결측치 지우기
df_filled = df.copy()
df_filled['점수'] = df_filled['점수'].fillna(0) #0으로 채움
print(df_filled)
print(f'중복된 행의 수:{df.duplicated().sum()}')
df_unique = df.drop_duplicates()
print(df_unique)
#나이 컬럼 문자열 or None -> int
df_clean = df_unique.copy()
df_clean['나이'] = df_clean['나이'].fillna(20)
df_clean['나이'] = df_clean['나이'].astype(int)
print(df_clean.info())
def get_age_group(age):
    if age >= 30:
        return '30대 이상'
    elif age >= 20:
        return '20대'
    else:
        return '10대 이하'
df_clean['연령대'] = df_clean['나이'].apply(get_age_group)
print(df_clean)