from flask import Blueprint, jsonify

products_bp = Blueprint("products", __name__)

PRODUCTS = [
    {
        "id": 1,
        "name": "Laptop",
        "price": 50000
    },
    {
        "id": 2,
        "name": "Keyboard",
        "price": 1200
    },
    {
        "id": 3,
        "name": "Mouse",
        "price": 700
    }
]

@products_bp.route("/products", methods=["GET"])
def products():
    return jsonify(PRODUCTS)