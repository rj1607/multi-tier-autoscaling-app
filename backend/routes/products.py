from flask import Blueprint, jsonify

from database.db import database_available
from models.product import Product

products_bp = Blueprint("products", __name__)


@products_bp.route("/products", methods=["GET"])
def get_products():
    """
    Return all products.
    """

    if not database_available():

        return jsonify(
            {
                "status": "database_not_configured",
                "products": [],
                "message": "Database is not configured."
            }
        ), 200

    try:

        products = Product.get_all()

        return jsonify(
            {
                "status": "success",
                "count": len(products),
                "products": products
            }
        ), 200

    except Exception as error:

        return jsonify(
            {
                "status": "error",
                "message": str(error)
            }
        ), 500