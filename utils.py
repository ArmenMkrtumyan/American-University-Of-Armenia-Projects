# utils.py

import configparser
import logging
import os
import pyodbc

def connect_to_database(config_file, section):
    """
    Establishes a connection to the database using the provided configuration.

    :param config_file: Path to the configuration file.
    :param section: Section in the configuration file to use.
    :return: pyodbc connection object.
    """
    parser = configparser.ConfigParser()
    if not os.path.exists(config_file):
        logging.error(f"Configuration file not found: {config_file}")
        return None

    parser.read(config_file)

    if not parser.has_section(section):
        logging.error(f"Section {section} not found in the config file.")
        return None

    params = dict(parser.items(section))

    # Add timeout parameters
    params['LoginTimeout'] = '30'  # Increase login timeout to 30 seconds
    params['ConnectTimeout'] = '30'  # Add connect timeout of 30 seconds

    conn_str = ';'.join([f"{key}={value}" for key, value in params.items()])

    try:
        connection = pyodbc.connect(conn_str)
        return connection
    except pyodbc.Error as e:
        logging.error(f"Failed to connect to database: {e}")
        return None

def execute_sql_script(connection, script_path):
    """
    Reads and executes an SQL script from a file with optional parameters.

    :param connection: Active pyodbc connection object.
    :param script_path: Path to the SQL script file.
    :param params: Dictionary of parameters to format the SQL script.
    """
    if not os.path.exists(script_path):
        logging.error(f"SQL script '{script_path}' does not exist.")
        raise FileNotFoundError(f"SQL script '{script_path}' not found.")

    with open(script_path, 'r') as file:
        sql_script = file.read()

    cursor = connection.cursor()
    try:
        cursor.execute(sql_script)
        connection.commit()  # Changed from cursor.commit() to connection.commit()
    except Exception as e:
        logging.error(f"Failed to execute SQL script '{script_path}': {e}")
        connection.rollback()
        raise
