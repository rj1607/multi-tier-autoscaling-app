from flask import Blueprint, jsonify
from database.db import get_connection

products_bp = Blueprint("products", __name__)


@products_bp.route("/products", methods=["GET"])
def get_products():

    connection = get_connection()

    cursor = connection.cursor()

    cursor.execute("SELECT * FROM products")

    products = cursor.fetchall()

    cursor.close()

    connection.close()

    return jsonify(products)