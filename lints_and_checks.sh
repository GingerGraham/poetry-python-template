#!/bin/bash

# Run lints and checks with poetry installed tools
# Usage: ./lints_and_checks.sh
# Author: Graham Watts

# Determine the root of the current project directory
PROJECT_ROOT=$(dirname $(realpath $0))

# Check if a temp directory exists in the project root and create it if it doesn't
if [ ! -d "${PROJECT_ROOT}/temp" ]; then
    echo "[INFO] Creating temp directory in project root"
    mkdir "${PROJECT_ROOT}/temp"
    echo "[INFO] Temp directory created"
fi

# Run isort against the src directory in the project root
echo "[INFO] Running isort against the src directory in the project root"
poetry run isort "${PROJECT_ROOT}/src/"
echo "[INFO] isort run complete"

# Run autopep8 against the src directory in the project root
echo "[INFO] Running autopep8 against the src directory in the project root"
poetry run autopep8 --recursive --in-place "${PROJECT_ROOT}/src/"
echo "[INFO] autopep8 run complete"

# Run black against the src directory in the project root
echo "[INFO] Running black against the src directory in the project root"
poetry run black "${PROJECT_ROOT}/src/"
echo "[INFO] black run complete"

# Run pylint against the src directory in the project root and output the results to a file
echo "[INFO] Running pylint against the src directory in the project root"
poetry run pylint "${PROJECT_ROOT}/src/" > "${PROJECT_ROOT}/temp/pylint_results.txt"
echo "[INFO] pylint run complete. Results saved to ${PROJECT_ROOT}/temp/pylint_results.txt"

echo "[INFO] Lints and checks complete"