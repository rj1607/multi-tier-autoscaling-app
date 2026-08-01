from flask import Blueprint, jsonify
from models.product import Product

products_bp = Blueprint("products", __name__)

products = [
    Product(
        1,
        "Laptop",
        "High Performance Laptop",
        50000,
        15
    ),
    Product(
        2,
        "Keyboard",
        "Mechanical Keyboard",
        2500,
        30
    ),
    Product(
        3,
        "Mouse",
        "Wireless Mouse",
        1200,
        50
    )
]


@products_bp.route("/products", methods=["GET"])
def get_products():
    return jsonify([product.to_dict() for product in products])