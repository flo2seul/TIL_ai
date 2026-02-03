import pandas as pd

#1. series(열) Dataframe(행,열)
data_list = [10,20,30,40,50] # index 디폴트 0
series = pd.Series(data_list, index=['a','b','c','d','e'])
print('\n series')
print(series)
print(f'인덱스"b"값:{series['b']}')
data_dict = {
    '이름': ['오','윤','김'],
    '나이': [30,45,34],
    '직업':['개발자','디자이너','물리학자'],
    '점수':[50,45,95]
}
df = pd.DataFrame(data_dict)
print('\n dataframe')
print(df)
print(df.head(2))
print(df.info())
#loc : 이음(Link)
#iloc : 번호(index)로 선택
print(df.loc[1,'이름'])
print(df.iloc[0,1])

#df series 반환
for idx, row in df.iterrows():
    print(idx,row['이름'], row['윤'])
#namedtuple 반환
for row in df.itertuples():
    print(row.이름)
#value만 (가장 빠름)
for v in df['이름'].values:
    print(v)
# 다양한 내장함수
total = df['age_plus'].sum()
median = df['age_plus'].quantile(0.5)
