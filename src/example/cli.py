import logging

from tfsm.common import version
from tfsm.common.logging import setup_logging_from_args
from tfsm.common.output import log_message_section, print_message_section
from example.utils.argsparser import parse_args


def main():
  """Main function
  Executes this example script.
  This function performs the following steps:
  1. Parses command-line arguments.
  2. Sets up logging based on the parsed arguments.
  3. Logs a starting message.
  4. Logs the current version of the script in debug mode.
  5. Logs an ending message.
  6. Prints a message section without logging it.
  Returns:
      None
  """


  args = parse_args()

  setup_logging_from_args(args)

  log_message_section("Hello World!", top=True, bottom=False, divider="=", level=logging.INFO)

  logging.debug("Version: %s", version.__version__)

  log_message_section("Example complete!", top=False, bottom=True, divider="-", level=logging.INFO)

  print_message_section("Print only, no log!", top=True, bottom=True, divider="*")


if __name__ == "__main__":
  main()
