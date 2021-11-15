from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World: Overkill!</p>"

@app.route("/health")
def health():
    return "<p>UP!</p>"
