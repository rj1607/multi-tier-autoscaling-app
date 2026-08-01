from flask import Blueprint, jsonify
from datetime import datetime

health_bp = Blueprint("health", __name__)


@health_bp.route("/health", methods=["GET"])
def health():

    return jsonify(
        {
            "status": "Healthy",
            "application": "Multi-Tier Auto-Scaling Web Application",
            "time": datetime.utcnow().isoformat() + "Z"
        }
    )