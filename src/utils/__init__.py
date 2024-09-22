"""Utility functions package

This module initializes utility functions and constants for the <insert_name> project.

Modules:
  args: Contains the `parse_args` function for parsing command-line arguments.
  fstests: Contains the `is_valid_path` function for validating file paths.
  logging: Imports all logging-related functions and classes.
  output: Contains functions for logging and printing message sections.
  version: Contains the `__version__` constant representing the version of the project.

"""

from .args import parse_args
from .fstests import is_valid_path
from .logging import *
from .output import log_message_section, print_message_section
from .version import __version__
