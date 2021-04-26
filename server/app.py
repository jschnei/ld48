from flask import Flask, g, render_template, request
from flask_cors import CORS

import datetime
import sqlite3
app = Flask(__name__)
CORS(app)


DATABASE = "data/high_scores.db"

LIST_SCORES_CLASSIC_QUERY = "select name, score from scores where gamemode = \"arcade\" order by score desc limit 20"
LIST_SCORES_UNTIMED_QUERY = "select name, score from scores where gamemode = \"untimed\" order by score desc limit 20"

LIST_SCORES_CLASSIC_DAILY_QUERY = "select name, score from scores where gamemode = \"arcade\" and seed >= {} order by score desc limit 20"
LIST_SCORES_UNTIMED_DAILY_QUERY = "select name, score from scores where gamemode = \"untimed\" and seed >= {} order by score desc limit 20"

INSERT_SCORE_QUERY = "insert into scores values (?, ?, ?, ?, ?)"

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

def time_stuff():
    cur_date = datetime.date.today()
    cur_dt = datetime.datetime(cur_date.year, cur_date.month, cur_date.day)
    next_dt = cur_dt + datetime.timedelta(days=1)

    cur_timestamp = cur_dt.timestamp()
    time_til_reset = next_dt - datetime.datetime.now()
    return cur_timestamp, round(time_til_reset.seconds/3600, 1)

@app.route('/')
def leaderboard():
    cur = get_db().cursor()
    scores_classic = cur.execute(LIST_SCORES_CLASSIC_QUERY).fetchall()
    scores_untimed = cur.execute(LIST_SCORES_UNTIMED_QUERY).fetchall()

    timestamp, time_til_reset = time_stuff()

    scores_classic_daily = cur.execute(LIST_SCORES_CLASSIC_DAILY_QUERY.format(timestamp)).fetchall()
    scores_untimed_daily = cur.execute(LIST_SCORES_UNTIMED_DAILY_QUERY.format(timestamp)).fetchall()

    return render_template('leaderboard.html', 
                           high_scores_classic=scores_classic,
                           high_scores_untimed=scores_untimed,
                           daily_scores_classic=scores_classic_daily,
                           daily_scores_untimed=scores_untimed_daily,
                           time_til_reset=time_til_reset)

@app.route('/submit_score', methods=['POST'])
def submit_score():
    if 'score' not in request.form:
        return "No score provided", 400
    name = request.form.get('name', 'Anon')
    
    score = request.form.get('score', 0)
    gamemode = request.form.get('gamemode', 'unspecified')
    transcript = request.form.get('transcript', '')
    seed = request.form.get('seed', 0)

    try:
        score = int(score)
        seed = int(seed)
    except:
        return "Invalid score/seed", 400
    

    cur = get_db().cursor()
    cur.execute(INSERT_SCORE_QUERY, (name, score, gamemode, transcript, seed))

    get_db().commit()

    return "Submitted score"