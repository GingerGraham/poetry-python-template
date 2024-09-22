"""Argument Parsing Module

This module provides utility functions for parsing command-line arguments
for the <insert_name> application.

Functions:
    parse_args(): Parses command-line arguments and returns them as a Namespace object.

"""

import argparse

from .version import __version__


def parse_args():
    """Argument Parser

    Defines the arguments provided by the <insert_name> utility.

    Parses command-line arguments for the <insert_name>.

    This function sets up an argument parser with options for logging configuration,
    including log file and log level.

    Returns:
        argparse.Namespace: Parsed command-line arguments.
    """

    parser = argparse.ArgumentParser(
        description="<insert_name> v" + __version__
    )

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
