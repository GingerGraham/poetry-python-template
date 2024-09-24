"""Argument Parsing Module

This module provides utility functions for parsing command-line arguments
for this example application.

Functions:
    parse_args(): Parses command-line arguments and returns them as a Namespace object.

"""

import argparse

from example.common.name import __app_name__
from example.common.version import __version__


def parse_args():
    """Argument Parser

    Defines the arguments provided by the Terraform State Migrator utility.

    Parses command-line arguments for the Terraform State Migrator.

    This function sets up an argument parser with options for logging configuration,
    including log file and log level.

    Returns:
        argparse.Namespace: Parsed command-line arguments.
    """

    parser = argparse.ArgumentParser(description=f"{__app_name__} v{__version__}")

    # Logging configuration
    logging_group = parser.add_argument_group("Logging Configuration")
    logging_group.add_argument(
        "-lf",
        "--log-file",
        type=str,
        help="Log file - default: no log file/console only",
    )
    logging_group.add_argument(
        "-ll", "--log-level", type=str, help="Logging level - default: INFO"
    )

    return parser.parse_args()
