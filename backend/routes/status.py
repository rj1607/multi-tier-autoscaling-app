from flask import Blueprint, jsonify
import platform

status_bp = Blueprint("status", __name__)


@status_bp.route("/status", methods=["GET"])
def status():

    return jsonify(
        {
            "application": "Multi-Tier Auto-Scaling Web Application",
            "backend": "Flask",
            "python_version": platform.python_version(),
            "status": "Running"
        }
    )