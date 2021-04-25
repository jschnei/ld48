import sqlite3
con = sqlite3.connect('high_scores.db')

cur = con.cursor()
cur.execute('''CREATE TABLE scores
               (name text, score int)''')



