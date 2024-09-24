"""Output Utility Functions

Provides functions to print formatted messages to the console, 
or, depending on configuration, to a log file.

Functions:

    log_message_section(message, top=True, bottom=False, divider="=", level=logging.INFO)
        - Print a message, with an optional divider, using the logging module
    print_message_section(message, top=True, bottom=False, divider="=")
        - Print a message, with an optional divider, using the print function

"""

import logging


def log_message_section(
    message, top=True, bottom=False, divider="=", level=logging.INFO
):
    """Log a message with an optional divider

    Logs a message, optionally with a divider above/below the message, using the logging module.

    Args:
        message (str): Message to be printed
        top (bool): Print divider above message
        bottom (bool): Print divider below message
        divider (str): Divider to be used
        level (int): Logging level to be used

    Returns:
        None

    Example 1:
        log_message_section(
            "This is a message", top=True, bottom=True, divider="=", level=logging.INFO
        )

    Output 1:
        ===================
        This is a message
        ===================

    Example 2:
        log_message_section(
            "This is a message", top=True, bottom=False, divider="*", level=logging.WARNING
        )

    Output 2:
        ******************
        This is a message

    """
    if top:
        logging.log(level, divider * len(message))
    logging.log(level, message)
    if bottom:
        logging.log(level, divider * len(message))


def print_message_section(message, top=True, bottom=False, divider="="):
    """Print a message with an optional divider

    Prints a message, optionally with a divider above/below the message, using the print function.

    Args:
        message (str): Message to be printed
        top (bool): Print divider above message
        bottom (bool): Print divider below message
        divider (str): Divider to be used

    Returns:
        None

    Example 1:
        print_message_section("This is a message", top=True, bottom=True, divider="=")

    Output 1:
        ===================
        This is a message
        ===================

    Example 2:
        print_message_section("This is a message", top=True, bottom=False, divider="*")

    Output 2:
        ******************
        This is a message

    """

    if top:
        print(divider * len(message))
    print(message)
    if bottom:
        print(divider * len(message))
