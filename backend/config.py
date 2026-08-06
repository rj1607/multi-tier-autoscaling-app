import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    """
    Application Configuration
    """

    APP_HOST = os.getenv("APP_HOST", "0.0.0.0")
    APP_PORT = int(os.getenv("APP_PORT", 5000))

    DB_HOST = os.getenv("DB_HOST", "")
    DB_PORT = int(os.getenv("DB_PORT", 3306))
    DB_USER = os.getenv("DB_USER", "")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_NAME = os.getenv("DB_NAME", "")

    @classmethod
    def database_configured(cls) -> bool:
        """
        Returns True if database credentials are configured.
        """

        return all([
            cls.DB_HOST,
            cls.DB_USER,
            cls.DB_PASSWORD,
            cls.DB_NAME,
        ])