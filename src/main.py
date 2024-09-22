"""Application Main Module

This module serves as the entry point for the <insert_name> application.
It handles argument parsing, logging setup, and provides a basic structure for
logging and printing messages.

Functions:
    main(): Parses command-line arguments, sets up logging, and logs/prints
            predefined example messages.

Usage:
    Run this module directly to execute the main function.

Example:
    python terraform_state_migrator.py --log-level DEBUG

Dependencies:
    - logging
    - utils (custom module with the following functions and variables):
        - __version__: str, the version of the application.
        - log_message_section: function to log a sectioned message.
        - parse_args: function to parse command-line arguments.
        - print_message_section: function to print a sectioned message.
        - setup_logging_from_args: function to set up logging based on parsed arguments.

"""

import logging

from utils import (
    __version__,
    log_message_section,
    parse_args,
    print_message_section,
    setup_logging_from_args,
)


def main():
    """Main function
    Executes the terraform state migrator script.
    This function performs the following steps:
    1. Parses command-line arguments.
    2. Sets up logging based on the parsed arguments.
    3. Logs a starting message.
    4. Logs the current version of the script in debug mode.
    5. Logs a "Hello, World!" message.
    6. Prints a message section without logging it.
    Returns:
        None
    """

    args = parse_args()

    setup_logging_from_args(args)

    log_message_section(
        "Starting...", top=True, bottom=False, divider="=", level=logging.INFO
    )

    logging.debug("Version: %s", __version__)

    log_message_section(
        "Hello, World!", top=False, bottom=True, divider="=", level=logging.INFO
    )

    print_message_section("Print only, no log!", top=True, bottom=True, divider="-")


if __name__ == "__main__":
    main()
