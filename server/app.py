from flask import Flask, g, render_template, request

import sqlite3
app = Flask(__name__)

DATABASE = "data/high_scores.db"

LIST_SCORES_QUERY = "select name, score from scores order by score desc limit 20"
INSERT_SCORE_QUERY = "insert into scores values (?, ?)"

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

@app.route('/')
def leaderboard():
    cur = get_db().cursor()
    scores = cur.execute(LIST_SCORES_QUERY).fetchall()
    return render_template('leaderboard.html', high_scores=scores)

@app.route('/submit_score', methods=['POST'])
def submit_score():
    if 'score' not in request.form:
        return
    name = request.form.get('name', 'Anon')
    
    score = request.form.get('score', 0)
    try:
        score = int(score)
    except:
        return

    cur = get_db().cursor()
    cur.execute(INSERT_SCORE_QUERY, (name, score))

    get_db().commit()

    return "Submitted score"