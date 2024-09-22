#!/bin/bash

# Run lints and checks with poetry installed tools
# Usage: ./lints_and_checks.sh

# Determine the root of the current project directory
PROJECT_ROOT=$(dirname $(realpath $0))

# Run isort against the src directory in the project root
poetry run isort "${PROJECT_ROOT}/src/"

# Run autopep8 against the src directory in the project root
poetry run autopep8 --recursive --in-place "${PROJECT_ROOT}/src/"

# Run black against the src directory in the project root
poetry run black "${PROJECT_ROOT}/src/"

# Run pylint against the src directory in the project root and output the results to a file
poetry run pylint "${PROJECT_ROOT}/src/" > "${PROJECT_ROOT}/pylint_results.txt"