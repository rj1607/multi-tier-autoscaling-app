import pymysql

from pymysql.cursors import DictCursor

from config import Config


def database_available():

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
            autocommit=True,
            connect_timeout=5
        )

        connection.close()

        return True

    except Exception:

        return False


def get_connection():

    if not Config.database_configured():

        raise RuntimeError(
            "Database is not configured yet."
        )

    return pymysql.connect(
        host=Config.DB_HOST,
        port=Config.DB_PORT,
        user=Config.DB_USER,
        password=Config.DB_PASSWORD,
        database=Config.DB_NAME,
        cursorclass=DictCursor,
        autocommit=True,
        connect_timeout=5
    )