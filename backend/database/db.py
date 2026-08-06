import pymysql
from pymysql.cursors import DictCursor

from config import Config


def database_available() -> bool:
    """
    Check whether database is reachable.
    """

    if not Config.database_configured():
        return False

    try:

        connection = pymysql.connect(
            host=Config.DB_HOST,
            port=Config.DB_PORT,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
            database=Config.DB_NAME,
            cursorclass=DictCursor,
            connect_timeout=5,
            autocommit=True,
        )

        connection.close()

        return True

    except Exception:

        return False


def get_connection():
    """
    Return a database connection.
    """

    if not Config.database_configured():

        raise RuntimeError(
            "Database configuration is missing."
        )

    return pymysql.connect(
        host=Config.DB_HOST,
        port=Config.DB_PORT,
        user=Config.DB_USER,
        password=Config.DB_PASSWORD,
        database=Config.DB_NAME,
        cursorclass=DictCursor,
        connect_timeout=5,
        autocommit=True,
    )