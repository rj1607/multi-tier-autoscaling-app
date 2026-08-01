from flask import Blueprint, jsonify
from datetime import datetime

status_bp = Blueprint("status", __name__)

@status_bp.route("/status", methods=["GET"])
def status():
    return jsonify(
        {
            "application": "Multi-Tier Auto-Scaling Web Application",
            "environment": "development",
            "server_time": datetime.utcnow().isoformat() + "Z"
        }
    )