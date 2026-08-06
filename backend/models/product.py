from database.db import get_connection


class Product:

    @staticmethod
    def get_all():

        connection = None

        try:

            connection = get_connection()

            with connection.cursor() as cursor:

                cursor.execute(
                    """
                    SELECT
                        id,
                        name,
                        description,
                        price,
                        stock,
                        created_at
                    FROM products
                    ORDER BY id ASC;
                    """
                )

                return cursor.fetchall()

        finally:

            if connection:

                connection.close()