# pipeline_dimensional_data/flow.py

from pipeline_dimensional_data.tasks import (
    create_staging_tables,
    create_dim_scd_sor_tables,
    ingest_all_tables,
    ingest_multiple_tables,
    delete_data_from_table
)
import logging


class DimensionalDataFlow:
    """
    Class to manage the sequential execution of dimensional data pipeline tasks.
    """

    def __init__(self):
        pass  # Initialize any necessary attributes here

    def exec(self, start_date, end_date):
        """
        Executes the dimensional data pipeline tasks sequentially.

        :param start_date: Start date for data ingestion (YYYY-MM-DD).
        :param end_date: End date for data ingestion (YYYY-MM-DD).
        :return: Dictionary indicating overall success status.
        """
        logging.info("Starting Dimensional Data Flow execution.")

        # Task 1: Create all necessary tables
        logging.info("Executing Task 1: Create Staging Tables.")
        sql_filename = "staging_raw_table_creation.sql"
        result = create_staging_tables(start_date, end_date, sql_filename)
        if not result.get('success'):
            logging.error(f"Task 1 Failed: {result.get('message')}")
            return {'success': False, 'message': f"Task 1 Failed: {result.get('message')}"}

        # Task 2: Create dim tables, SCDs and SORs
        sql_filename = "dimensional_db_table_creation.sql"
        logging.info("Executing Task 2: Create Tables. (dim tables, SCDs and SORs)")
        result = create_dim_scd_sor_tables(start_date, end_date, sql_filename)
        if not result.get('success'):
            logging.error(f"Task 2 Failed: {result.get('message')}")
            return {'success': False, 'message': f"Task 2 Failed: {result.get('message')}"}

        # Task 2: Ingest data into all tables
        # logging.info("Executing Task 2: Ingest All Tables.")
        # result = ingest_all_tables(start_date, end_date)
        # if not result.get('success'):
        #     logging.error(f"Task 2 Failed: {result.get('message')}")
        #     return {'success': False, 'message': f"Task 2 Failed: {result.get('message')}"}

        # Additional tasks can be added here following the same pattern
        # For example:
        # logging.info("Executing Task 3: Delete Old Data.")
        # result = delete_data_from_table('dim', 'dim_customers', '2022-01-01', '2022-12-31')
        # if not result.get('success'):
        #     logging.error(f"Task 3 Failed: {result.get('message')}")
        #     return {'success': False, 'message': f"Task 3 Failed: {result.get('message')}"}

        logging.info("Dimensional Data Flow executed successfully.")
        return {'success': True}
