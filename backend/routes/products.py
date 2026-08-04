from flask import Blueprint
from flask import jsonify

from database.db import database_available
from models.product import Product

products_bp = Blueprint("products", __name__)


@products_bp.route("/products", methods=["GET"])
def get_products():

    #########################################
    # Database Not Configured Yet
    #########################################

    if not database_available():

        return jsonify(
            {
                "status": "database_not_configured",
                "products": [],
                "message": "Amazon RDS has not been configured yet."
            }
        ), 200

    #########################################
    # Database Available
    #########################################

    try:

        products = Product.get_all()

        return jsonify(
            {
                "status": "success",
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