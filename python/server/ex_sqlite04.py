import requests

market = "KRW-BTC"
url = f"https://api.upbit.com/v1/ticker?markets={market}"

res = requests.get(url)
print(res.json())

create_sql = """
    CREATE TABLE IF NOT EXISTS coin_price(
        seq INTEGER PRIMARY KEY AUTOINCREMENT
        ,market TEXT
        ,price REAL
        ,collect_dt DATETIME DEFAULT CURRENT_TIMESTAMP
"""