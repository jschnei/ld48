import os
import sqlite3
import time

if os.path.isfile("high_scores.db"):
    os.rename("high_scores.db", "high_scores_{}.db".format(int(time.time())))

con = sqlite3.connect('high_scores.db')

cur = con.cursor()
cur.execute('''CREATE TABLE scores
               (name text, score int, gamemode text, transcript text, seed int)''')


