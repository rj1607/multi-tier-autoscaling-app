from flask import Blueprint
from flask import jsonify

import platform

status_bp = Blueprint("status", __name__)


@status_bp.route("/app-status", methods=["GET"])
def application_status():

    return jsonify(
        {
            "application": "Multi-Tier Auto-Scaling Web Application",
            "backend": "Flask",
            "python_version": platform.python_version(),
            "status": "Running"
        }
    ), 200