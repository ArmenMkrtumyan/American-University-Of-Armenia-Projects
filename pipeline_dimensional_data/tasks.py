# pipeline_dimensional_data/tasks.py

import os
from utils import connect_to_database, execute_sql_script
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Dynamically construct the path to the configuration file
# Assuming tasks.py is in pipeline_dimensional_data/
current_dir = os.path.dirname(__file__)
CONFIG_FILE = os.path.abspath(os.path.join(current_dir, '..', 'infrastructure_initiation', 'sql_server_config.cfg'))

DATABASE_SECTION = 'ORDER_DDS'  # Ensure this section exists in the config file
SQL_SCRIPTS_DIR = os.path.abspath(os.path.join(current_dir, '..', 'infrastructure_initiation'))  # Adjust if needed



def create_table(connection, schema, table_name):
    """
    Creates a table in the specified schema.

    :param connection: Active pyodbc connection object.
    :param schema: Schema name where the table will be created.
    :param table_name: Name of the table to create.
    :return: Dictionary indicating success status.
    """
    sql_script_path = os.path.join(SQL_SCRIPTS_DIR, 'staging_raw_table_creation.sql')
    params = {
        'schema': schema,
        'table_name': table_name
    }
    try:
        execute_sql_script(connection, sql_script_path, params)
        logging.info(f"Table '{schema}.{table_name}' created successfully.")
        return {'success': True}
    except Exception as e:
        logging.error(f"Failed to create table '{schema}.{table_name}': {e}")
        return {'success': False, 'message': str(e)}


def ingest_data(connection, schema, table_name, source_schema, source_table, start_date, end_date):
    """
    Ingests data into the specified table from a source table within a date range.

    :param connection: Active pyodbc connection object.
    :param schema: Destination schema name.
    :param table_name: Destination table name.
    :param source_schema: Source schema name.
    :param source_table: Source table name.
    :param start_date: Start date for data ingestion (YYYY-MM-DD).
    :param end_date: End date for data ingestion (YYYY-MM-DD).
    :return: Dictionary indicating success status.
    """
    sql_script_path = os.path.join(SQL_SCRIPTS_DIR, 'ingest_data.sql')
    params = {
        'schema': schema,
        'table_name': table_name,
        'source_schema': source_schema,
        'source_table': source_table,
        'start_date': start_date,
        'end_date': end_date
    }
    try:
        execute_sql_script(connection, sql_script_path, params)
        logging.info(f"Data ingested into '{schema}.{table_name}' successfully.")
        return {'success': True}
    except Exception as e:
        logging.error(f"Failed to ingest data into '{schema}.{table_name}': {e}")
        return {'success': False, 'message': str(e)}


def setup_dimensional_tables(start_date, end_date):
    """
    Sets up dimensional tables by creating necessary tables and ingesting data.

    :param start_date: Start date for data ingestion (YYYY-MM-DD).
    :param end_date: End date for data ingestion (YYYY-MM-DD).
    :return: Dictionary indicating overall success status.
    """
    connection = None
    try:
        connection = connect_to_database(CONFIG_FILE, DATABASE_SECTION)
        logging.info("Database connection established.")

        # Define table configurations
        tables = [
            {
                'schema': 'dim',
                'table_name': 'dim_customers',
                'source_schema': 'staging',
                'source_table': 'stg_customers'
            },
            {
                'schema': 'dim',
                'table_name': 'dim_products',
                'source_schema': 'staging',
                'source_table': 'stg_products'
            },
            # Add more tables as needed
        ]

        # Begin transaction
        connection.autocommit = False
        cursor = connection.cursor()

        # Create tables
        for table in tables:
            result = create_table(connection, table['schema'], table['table_name'])
            if not result['success']:
                raise Exception(result.get('message'))

        # Ingest data
        for table in tables:
            result = ingest_data(
                connection,
                table['schema'],
                table['table_name'],
                table['source_schema'],
                table['source_table'],
                start_date,
                end_date
            )
            if not result['success']:
                raise Exception(result.get('message'))

        # Commit transaction if all operations succeeded
        connection.commit()
        logging.info("All tables created and data ingested successfully.")
        return {'success': True}

    except Exception as e:
        if connection:
            connection.rollback()
            logging.error("Transaction rolled back due to an error.")
        logging.error(f"Error in setup_dimensional_tables: {e}")
        return {'success': False, 'message': str(e)}

    finally:
        if connection:
            connection.close()
            logging.info("Database connection closed.")


def ingest_multiple_tables(start_date, end_date):
    """
    A single task responsible for ingesting data into multiple destination tables.

    :param start_date: Start date for data ingestion (YYYY-MM-DD).
    :param end_date: End date for data ingestion (YYYY-MM-DD).
    :return: Dictionary indicating success status.
    """
    logging.info("Starting ingestion of multiple tables...")
    return setup_dimensional_tables(start_date, end_date)


def create_all_tables(start_date, end_date):
    """
    Task to create all necessary tables before data ingestion.

    :param start_date: Not used in this task but included for consistency.
    :param end_date: Not used in this task but included for consistency.
    :return: Dictionary indicating success status.
    """
    connection = None
    try:
        connection = connect_to_database(CONFIG_FILE, DATABASE_SECTION)
        logging.info("Database connection established for table creation.")

        # Define table configurations
        tables = [
            {
                'schema': 'dim',
                'table_name': 'dim_customers'
            },
            {
                'schema': 'dim',
                'table_name': 'dim_products'
            },
            # Add more tables as needed
        ]

        # Begin transaction
        connection.autocommit = False
        cursor = connection.cursor()

        # Create tables
        for table in tables:
            result = create_table(connection, table['schema'], table['table_name'])
            if not result['success']:
                raise Exception(result.get('message'))

        # Commit transaction if all table creations succeeded
        connection.commit()
        logging.info("All tables created successfully.")
        return {'success': True}

    except Exception as e:
        if connection:
            connection.rollback()
            logging.error("Transaction rolled back due to an error in table creation.")
        logging.error(f"Error in create_all_tables: {e}")
        return {'success': False, 'message': str(e)}

    finally:
        if connection:
            connection.close()
            logging.info("Database connection closed.")


def ingest_all_tables(start_date, end_date):
    """
    Task to ingest data into all tables after they have been created.

    :param start_date: Start date for data ingestion (YYYY-MM-DD).
    :param end_date: End date for data ingestion (YYYY-MM-DD).
    :return: Dictionary indicating success status.
    """
    logging.info("Starting data ingestion for all tables...")
    connection = None
    try:
        connection = connect_to_database(CONFIG_FILE, DATABASE_SECTION)
        logging.info("Database connection established for data ingestion.")

        # Define table configurations
        tables = [
            {
                'schema': 'dim',
                'table_name': 'dim_customers',
                'source_schema': 'staging',
                'source_table': 'stg_customers'
            },
            {
                'schema': 'dim',
                'table_name': 'dim_products',
                'source_schema': 'staging',
                'source_table': 'stg_products'
            },
            # Add more tables as needed
        ]

        # Begin transaction
        connection.autocommit = False
        cursor = connection.cursor()

        # Ingest data
        for table in tables:
            result = ingest_data(
                connection,
                table['schema'],
                table['table_name'],
                table['source_schema'],
                table['source_table'],
                start_date,
                end_date
            )
            if not result['success']:
                raise Exception(result.get('message'))

        # Commit transaction if all data ingestions succeeded
        connection.commit()
        logging.info("Data ingested into all tables successfully.")
        return {'success': True}

    except Exception as e:
        if connection:
            connection.rollback()
            logging.error("Transaction rolled back due to an error in data ingestion.")
        logging.error(f"Error in ingest_all_tables: {e}")
        return {'success': False, 'message': str(e)}

    finally:
        if connection:
            connection.close()
            logging.info("Database connection closed.")


def delete_data_from_table(schema, table_name, start_date, end_date):
    """
    Deletes data from a specified table within a date range.

    :param schema: Schema name.
    :param table_name: Table name.
    :param start_date: Start date for deletion (YYYY-MM-DD).
    :param end_date: End date for deletion (YYYY-MM-DD).
    :return: Dictionary indicating success status.
    """
    sql_script_path = os.path.join(SQL_SCRIPTS_DIR, 'delete_data.sql')
    params = {
        'schema': schema,
        'table_name': table_name,
        'start_date': start_date,
        'end_date': end_date
    }
    try:
        connection = connect_to_database(CONFIG_FILE, DATABASE_SECTION)
        execute_sql_script(connection, sql_script_path, params)
        logging.info(f"Data deleted from '{schema}.{table_name}' successfully.")
        connection.close()
        return {'success': True}
    except Exception as e:
        logging.error(f"Failed to delete data from '{schema}.{table_name}': {e}")
        return {'success': False, 'message': str(e)}
