import FinanceDataReader as fdr
import pandas as pd
import matplotlib.pyplot as plt
#한글 폰트 설정
plt.rcParams['font.family'] = 'Malgun Gothic'
plt.rcParams['axes.unicode_minus'] = False
df = fdr.DataReader('005930','2024-01-01')
print(df.head())
plt.figure(figsize=(10,8))
plt.subplot(2,1,1)
plt.plot(df.index, df['Close'], label='samsung close', color='navy')
plt.title('삼성전자 주가 추이(2024~)')
plt.ylabel('가격(원)')
plt.grid(True)
plt.legend()
plt.show()