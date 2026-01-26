import sqlite3
conn = sqlite3.connect('mydb.db')

# 1. array or tuple
sql = """
    INSERT INTO tb_coin VALUES(?,?,?)
"""
# 2. dict 키로 맵핑
sql2 = """INSERT INTO tb_coin VALUES(:market, :kr, :en)"""
cur = conn.cursor()
cur.execute(sql, ['test','test','test'])
cur.execute(sql2, {"market":"TEST2", "kr":"TEST2","en":"TEST2"})
conn.commit()
conn.close()