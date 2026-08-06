from flask import Flask, jsonify
from flask_cors import CORS

from config import Config

from routes.health import health_bp
from routes.products import products_bp
from routes.status import status_bp


def create_app():
    """
    Flask Application Factory
    """

    app = Flask(__name__)

    app.config["JSON_SORT_KEYS"] = False

    CORS(app)

    # -------------------------------
    # Register Blueprints
    # -------------------------------

    app.register_blueprint(status_bp)
    app.register_blueprint(health_bp)
    app.register_blueprint(products_bp)

    # -------------------------------
    # Home
    # -------------------------------

    @app.route("/")
    def home():

        return jsonify(
            {
                "application": "Multi-Tier Web Application",
                "version": "1.0.0",
                "backend": "Flask",
                "status": "Running",
                "message": "Backend started successfully."
            }
        )

    # -------------------------------
    # 404
    # -------------------------------

    @app.errorhandler(404)
    def page_not_found(error):

        return jsonify(
            {
                "status": "error",
                "message": "Route not found."
            }
        ), 404

    # -------------------------------
    # 500
    # -------------------------------

    @app.errorhandler(500)
    def internal_server_error(error):

        return jsonify(
            {
                "status": "error",
                "message": "Internal server error."
            }
        ), 500

    return app


app = create_app()


if __name__ == "__main__":

    print("=" * 50)
    print("Starting Flask Backend")
    print("=" * 50)

    app.run(
        host=Config.APP_HOST,
        port=Config.APP_PORT,
        debug=False,
    )