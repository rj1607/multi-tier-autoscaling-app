from flask import Blueprint, jsonify
import platform

status_bp = Blueprint("status", __name__)


@status_bp.route("/app-status", methods=["GET"])
def application_status():
    """
    Application information endpoint.
    """

    return jsonify(
        {
            "application": "Multi-Tier Web Application",
            "backend": "Flask",
            "python_version": platform.python_version(),
            "status": "Running"
        }
    ), 200