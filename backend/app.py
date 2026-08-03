from flask import Flask, jsonify
from flask_cors import CORS

from config import Config

from routes.health import health_bp
from routes.products import products_bp
from routes.status import status_bp


def create_app():

    app = Flask(__name__)

    CORS(app)

    app.register_blueprint(health_bp)
    app.register_blueprint(products_bp)
    app.register_blueprint(status_bp)

    @app.route("/")
    def home():

        return jsonify(
            {
                "application": "Multi-Tier Auto-Scaling Web Application",
                "version": "1.0.0",
                "backend": "Flask",
                "status": "Running"
            }
        )

    @app.errorhandler(404)
    def not_found(error):

        return jsonify(
            {
                "error": "Not Found"
            }
        ), 404

    @app.errorhandler(500)
    def internal_server_error(error):

        return jsonify(
            {
                "error": "Internal Server Error"
            }
        ), 500

    return app


app = create_app()


if __name__ == "__main__":

    app.run(
        host=Config.APP_HOST,
        port=Config.APP_PORT,
        debug=False
    )