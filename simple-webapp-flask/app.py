from flask import Flask
app = Flask(__name__)

@app.route("/")
def main():
    return "Welcome!"

@app.route('/how_are_you')
def hello():
    return 'I am good, how about you?'
