import json
import sqlite3
import requests

url = "https://api.upbit.com/v1/market/all"
res = requests.get(url)
json_data = json.loads(res.text)
for v in json_data:
    print(v)
conn = sqlite3.connect('mydb.db')
cur = conn.cursor()
sql = """
    INSERT INTO tb_coin VALUES(?,?,?)
"""

for row in json_data:
    cur.execute(sql, [row['market'], row['korean_name'],row['english_name']])
conn.commit()
conn.close()