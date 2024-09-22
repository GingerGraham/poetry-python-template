# Poetry Python Template

This repository is a template for a Python project using Poetry. It includes a basic project structure, a `pyproject.toml` file with the necessary dependencies, and a `README.md` file with instructions on how to use the template.

The basic structure of the project includes some common utilities such as:

- `main.py` is a simple script that uses the utilities in the project to demonstrate how they can be used.
- `pyproject.toml` includes the dependencies required for the provided utilities.
- An argument parser using `argparse` in `args.py`
- A logging configuration using `logging` in `logging.py`
- Some templated logging messages in `output.py`
- A version number in `version.py`
- An example pre-commit hook in `.pre-commit-config.yaml` is provided although it is not enabled by default.
- A script called `lints_and checks.sh` runs a number of common tools and linters to format and check the code.
