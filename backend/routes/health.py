from flask import Blueprint

from database.db import database_available

health_bp = Blueprint("health", __name__)


@health_bp.route("/status", methods=["GET"])
def health():
    """
    Application health endpoint.
    """

    if database_available():
        return {
            "status": "healthy",
            "application": "running",
            "database": "connected"
        }, 200

    return {
        "status": "healthy",
        "application": "running",
        "database": "not_configured",
        "message": "Application is running without database."
    }, 200