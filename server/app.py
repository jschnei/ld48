from flask import Flask, g, render_template, request
from flask_cors import CORS

import sqlite3
app = Flask(__name__)
CORS(app)


DATABASE = "data/high_scores.db"

LIST_SCORES_CLASSIC_QUERY = "select name, score from scores where gamemode = \"arcade\" order by score desc limit 20"
LIST_SCORES_UNTIMED_QUERY = "select name, score from scores where gamemode = \"untimed\" order by score desc limit 20"
INSERT_SCORE_QUERY = "insert into scores values (?, ?, ?, ?, ?)"

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

@app.route('/')
def leaderboard():
    cur = get_db().cursor()
    scores_classic = cur.execute(LIST_SCORES_CLASSIC_QUERY).fetchall()
    scores_untimed = cur.execute(LIST_SCORES_UNTIMED_QUERY).fetchall()
    return render_template('leaderboard.html', 
                           high_scores_classic=scores_classic,
                           high_scores_untimed=scores_untimed)

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