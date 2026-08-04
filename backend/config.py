import os

from dotenv import load_dotenv

load_dotenv()


class Config:

    DB_HOST = os.getenv("DB_HOST", "")

    DB_PORT = int(os.getenv("DB_PORT", 3306))

    DB_USER = os.getenv("DB_USER", "")

    DB_PASSWORD = os.getenv("DB_PASSWORD", "")

    DB_NAME = os.getenv("DB_NAME", "")

    APP_HOST = os.getenv("APP_HOST", "0.0.0.0")

    APP_PORT = int(os.getenv("APP_PORT", 5000))

    @staticmethod
    def database_configured():

        return all(
            [
                Config.DB_HOST,
                Config.DB_USER,
                Config.DB_PASSWORD,
                Config.DB_NAME,
            ]
        )