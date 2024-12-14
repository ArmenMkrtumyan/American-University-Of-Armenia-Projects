# pipeline_dimensional_data/flow.py

import logging
from utils import generate_uuid
from pipeline_dimensional_data.tasks import (
    create_staging_tables,
    create_dim_scd_sor_tables,
    # ingest_all_tables,
    # ingest_multiple_tables,
    # delete_data_from_table
)

class DimensionalDataFlow:
    """
    Class to manage the sequential execution of dimensional data pipeline tasks.
    """

    def __init__(self):
        """
        Initializes the DimensionalDataFlow instance with a unique execution ID.
        """
        self.execution_id = generate_uuid()
        logging.info(f"Initialized DimensionalDataFlow with Execution ID: {self.execution_id}")

    def exec(self, start_date, end_date):
        """
        Executes the dimensional data pipeline tasks sequentially.

        :param start_date: Start date for data ingestion (YYYY-MM-DD).
        :param end_date: End date for data ingestion (YYYY-MM-DD).
        :return: Dictionary indicating overall success status.
        """
        logging.info(f"Execution ID {self.execution_id}: Starting Dimensional Data Flow execution.")

        # Task 1: Create Staging Tables
        logging.info(f"Execution ID {self.execution_id}: Executing Task 1 - Create Staging Tables.")
        sql_filename = "staging_raw_table_creation.sql"
        result = create_staging_tables(start_date, end_date, sql_filename)
        if not result.get('success'):
            logging.error(f"Execution ID {self.execution_id}: Task 1 Failed - {result.get('message')}")
            return {'success': False, 'message': f"Task 1 Failed: {result.get('message')}"}

        # Task 2: Create Dim Tables, SCDs, and SORs
        logging.info(f"Execution ID {self.execution_id}: Executing Task 2 - Create Dim Tables, SCDs, and SORs.")
        sql_filename = "dimensional_db_table_creation.sql"
        result = create_dim_scd_sor_tables(start_date, end_date, sql_filename)
        if not result.get('success'):
            logging.error(f"Execution ID {self.execution_id}: Task 2 Failed - {result.get('message')}")
            return {'success': False, 'message': f"Task 2 Failed: {result.get('message')}"}

        # Task 3: Ingest All Tables
        # logging.info(f"Execution ID {self.execution_id}: Executing Task 3 - Ingest All Tables.")
        # result = ingest_all_tables(start_date, end_date)
        # if not result.get('success'):
        #     logging.error(f"Execution ID {self.execution_id}: Task 3 Failed - {result.get('message')}")
        #     return {'success': False, 'message': f"Task 3 Failed: {result.get('message')}"}

        # # Task 4: Ingest Multiple Tables
        # logging.info(f"Execution ID {self.execution_id}: Executing Task 4 - Ingest Multiple Tables.")
        # result = ingest_multiple_tables(start_date, end_date)
        # if not result.get('success'):
        #     logging.error(f"Execution ID {self.execution_id}: Task 4 Failed - {result.get('message')}")
        #     return {'success': False, 'message': f"Task 4 Failed: {result.get('message')}"}

        # # Task 5: Delete Data from Table
        # logging.info(f"Execution ID {self.execution_id}: Executing Task 5 - Delete Data from Table.")
        # # Example parameters; adjust as needed
        # table_type = 'dim'
        # table_name = 'dim_customers'
        # delete_start_date = '2022-01-01'
        # delete_end_date = '2022-12-31'
        # result = delete_data_from_table(table_type, table_name, delete_start_date, delete_end_date)
        # if not result.get('success'):
        #     logging.error(f"Execution ID {self.execution_id}: Task 5 Failed - {result.get('message')}")
        #     return {'success': False, 'message': f"Task 5 Failed: {result.get('message')}"}

        logging.info(f"Execution ID {self.execution_id}: Dimensional Data Flow executed successfully.")
        return {'success': True}
