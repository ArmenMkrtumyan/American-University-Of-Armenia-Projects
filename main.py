# main.py

from pipeline_dimensional_data.flow import DimensionalDataFlow
from datetime import datetime
import logging

# Configure logging (if not already configured in utils.py and tasks.py)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

if __name__ == "__main__":
    # Define the start and end dates for the data ingestion
    # You can modify these dates as needed or accept them as command-line arguments
    start_date = '2023-01-01'
    end_date = '2023-12-31'

    # Initialize the data flow
    data_flow = DimensionalDataFlow()

    # Execute the data flow
    result = data_flow.exec(start_date, end_date)

    if result['success']:
        logging.info("Dimensional data pipeline executed successfully.")
    else:
        logging.error(f"Dimensional data pipeline failed: {result.get('message')}")
