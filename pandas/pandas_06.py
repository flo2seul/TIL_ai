import FinanceDataReader as fdr
import pymysql

conn = pymysql.connect(
    host='localhost',
    user='appuser',
    password='appuser',
    db='money',
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor
)
print(conn)

df = fdr.StockListing('KRX')
sql = """
    INSERT INTO stocks(ticker, stock_nm, market_code)
    VALUES (%s, %s, %s)
"""

try:
    with conn.cursor() as cursor:
        for idx, row in df.iterrows():
            cursor.execute(sql, (row['Code'], row['Name'], row['Market']))
        conn.commit()
except Exception as e:
    print(str(e))
finally:
    conn.close()