import sqlite3

conn = sqlite3.connect('mydb.db')
sql = """
    CREATE TABLE tb_coin(
        market VARCHAR(20)
        ,kr_nm VARCHAR(100)
        ,en_nm VARCHAR(100)
    )
"""

cur = conn.cursor()
cur.execute(sql)
conn.close()