"""Logging Configuration Module

This module provides utility functions for setting up and configuring logging.

Functions:
    configure_logging(level=LOG_LEVEL, log_file=LOG_FILE)
        - Configures the logging system with the specified log level and log file.
    setup_logging_from_args(args, default_level=LOG_LEVEL)
        - Sets up logging based on command-line arguments, with an optional default log level.
"""

import logging
import os
import sys

from example.utils.file_system import is_valid_path

# Default values
LOG_LEVEL = logging.INFO
LOG_FORMAT = "%(asctime)s [%(levelname)s] %(message)s"

if os.name == "nt":  # Windows
    LOG_FILE = "NUL"
else:  # *nix
    LOG_FILE = "/dev/null"

# Configure default logging
logging.basicConfig(
    level=LOG_LEVEL,
    format=LOG_FORMAT,
    handlers=[logging.FileHandler(LOG_FILE), logging.StreamHandler(sys.stdout)],
)


def configure_logging(level=LOG_LEVEL, log_file=LOG_FILE):
    """Configure application logging

    Configures the logging for the application.

    This function sets the logging level and log file path, removes any existing
    handlers from the root logger, and adds new file and stream handlers with the
    specified log file and format.

    Args:
        level (int): The logging level (e.g., logging.DEBUG, logging.INFO).
        log_file (str): The path to the log file.

    Raises:
        ValueError: If the provided log file path is invalid.

    """

    if not is_valid_path(log_file):
        raise ValueError(f"Invalid log file path: {log_file}")

    logging.getLogger().setLevel(level)

    # Remove all handlers associated with the root logger object
    for handler in logging.getLogger().handlers[:]:
        logging.getLogger().removeHandler(handler)

    # Create new handlers with the updated log_file
    file_handler = logging.FileHandler(log_file)
    stream_handler = logging.StreamHandler(sys.stdout)

    # Set the same format for the new handlers
    file_handler.setFormatter(logging.Formatter(LOG_FORMAT))
    stream_handler.setFormatter(logging.Formatter(LOG_FORMAT))

    # Add the new handlers to the root logger
    logging.getLogger().addHandler(file_handler)
    logging.getLogger().addHandler(stream_handler)


def setup_logging_from_args(args, default_level=LOG_LEVEL):
    """Update logging configuration based on command-line arguments.

    Set up logging configuration based on command-line arguments.

    This function configures the logging settings based on the provided
    arguments. It sets the logging level and optionally configures a log
    file if specified.

    Args:
        args: An object containing command-line arguments. Expected to have
              'log_level' and 'log_file' attributes.
        default_level: The default logging level to use if 'log_level' is not
                       specified in the arguments.

    Raises:
        ValueError: If the provided log file path is invalid.

    """

    new_log_level = default_level
    if args.log_level:
        # Convert log level string to logging level
        new_log_level = getattr(logging, args.log_level.upper(), default_level)

    if args.log_file:
        if not is_valid_path(args.log_file):
            raise ValueError(f"Invalid log file path: {args.log_file}")
        # Configure logging with the provided log file and log level
        configure_logging(level=new_log_level, log_file=args.log_file)
    else:
        # Configure logging with the provided log level
        configure_logging(level=new_log_level)
