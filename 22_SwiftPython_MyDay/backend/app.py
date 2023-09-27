import sqliteTest

from flask import Flask, url_for, request, render_template, session, redirect
from markupsafe import escape


# app = Flask(__name__)

from sqliteTest import *

app.secret_key = b'\xde\xf6@I\xa1\x06;\xd7\xf1p\xfa=\x15\x0fW#'
# os.urandom(16)


@app.route('/hello1', methods=['GET', 'POST'])
def hello():
    if request.method == 'POST':
        print(request.headers['User-Agent'])
        return "Hello post"+request.headers['User-Agent']
    elif request.method == 'GET':
        return "Hello get head: "+request.headers['User-Agent']


@app.route('/record/bodyTest', methods=['POST'])
def redord():
    body = request.json
    print(body)
    if body:
        # return 'p1:{}, p2:{}'.format(request.form['time'], request.form['value'])
        return 'p1:{}, p2:{}'.format(body['time'], body['value'])
    else:
        return "no body"


@app.route('/hello/<name>')
def hello2(name=None):
    return render_template('hello.html', name=name)


@app.route('/user/<username>/<int:id>') # string int float path uuid
def showUserName(username, id):
    with app.test_request_context():
        print(url_for('hello'))
        print(url_for('showUserName', username="ww", id=22, other="pram"))
    return f'Welcome User: {escape(username)} with id: {id}'


@app.route('/')
def index():
    if 'username' in session:
        return f'Logged in as {session["username"]}'
    return 'You are not logged in'


@app.route('/ss')
def bukeyisese():
    return render_template('index.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['username'] = request.form['username']
        session['username-halfRecordStack'] = []
        session.permanent = True
        return redirect(url_for('index'))
    return '''
        <form method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
    '''

@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('username', None)
    return redirect(url_for('index'))

@app.route('/if')
def ifILogin():
    if 'username' in session:
        return {}


@app.route('/json')
def getJson():
    return {
        "test":"haha",
        "value":5
    }

if __name__ == '__main__':
    app.run()

