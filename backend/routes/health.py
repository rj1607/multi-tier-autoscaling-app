from flask import Blueprint

from database.db import get_connection

health_bp = Blueprint("health", __name__)


@health_bp.route("/status", methods=["GET"])
def health():

    try:

        connection = get_connection()

        connection.close()

        return {
            "status": "healthy",
            "database": "connected"
        }, 200

    except Exception as error:

        return {
            "status": "unhealthy",
            "error": str(error)
        }, 500