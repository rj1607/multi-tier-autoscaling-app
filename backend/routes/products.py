from flask import Blueprint
from flask import jsonify

from models.product import Product

products_bp = Blueprint("products", __name__)


@products_bp.route("/products", methods=["GET"])
def get_products():

    try:

        products = Product.get_all()

        return jsonify(products), 200

    except Exception as error:

        return jsonify(
            {
                "error": str(error)
            }
        ), 500