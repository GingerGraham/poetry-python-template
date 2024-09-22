"""File System Test Utilities

This module provides utility functions for testing file system paths.

Functions:

    is_valid_path(path): Check if the given path is a valid directory path.
    
"""

import os


def is_valid_path(path):
    """Confirm the validity of a directory path.

    Check if the given path is a valid directory path.

    Args:
        path (str): The path to be validated.

    Returns:
        bool: True if the path is a valid directory path, False otherwise.

    """
    directory = os.path.dirname(path)
    return os.path.exists(directory) and os.path.isdir(directory)


def is_valid_file(path):
    """Confirm the validity of a file path.

    Check if the given path is a valid file path.

    Args:
        path (str): The path to be validated.

    Returns:
        bool: True if the path is a valid file path, False otherwise.

    """
    return os.path.exists(path) and os.path.isfile(path)
