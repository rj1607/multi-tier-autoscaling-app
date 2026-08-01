from flask import Flask, jsonify
from flask_cors import CORS

from routes.health import health_bp
from routes.products import products_bp
from routes.status import status_bp

app = Flask(__name__)

CORS(app)

app.register_blueprint(health_bp)
app.register_blueprint(products_bp)
app.register_blueprint(status_bp)


@app.route("/")
def home():

    return jsonify(
        {
            "project": "Multi-Tier Auto-Scaling Web Application",
            "version": "1.0.0",
            "backend": "Flask",
            "developer": "Janvi",
            "status": "Running"
        }
    )


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )