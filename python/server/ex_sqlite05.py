import sqlite3
conn = sqlite3.connect('mydb.db')
cur = conn.cursor()
cur.execute("SELECT * FROM tb_coin kr_nm LIKE ?")
rows = cur.fetchall()
for row in rows:
    print(row)