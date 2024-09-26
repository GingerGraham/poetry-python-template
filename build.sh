#!/bin/bash

# Update versioning and build the package
# Usage: ./build.sh
# Author: Graham Watts
# Description: This script will update the versioning of the package in pyproject.toml and in ./src/tfsm/common/version.py  and build the package for distribution using poetry build

# Determine the root of the current project directory
PROJECT_ROOT=$(dirname $(realpath $0))

update_py_version() {
    # Update the value of __version__ in ${PROJECT_ROOT}/src/tfsm/common/version.py with the value passed to this function
    sed -i "s/__version__ = .*/__version__ = \"${1}\"/" "${PROJECT_ROOT}/src/tfsm/common/version.py"
}

update_pyproject_version() {
    # Update the version number in pyproject.toml with the value passed to this function
    sed -i "0,/version = .*/s//version = \"${1}\"/" "${PROJECT_ROOT}/pyproject.toml"
}

poetry_build() {
    # Build the package using poetry
    echo "[INFO] Building the package using poetry"
    if ! poetry build; then
        echo "[ERROR] Failed to build the package using poetry"
        exit 1
    else
        echo "[INFO] Wheel and Tarball packages built successfully"
    fi
}

pyinstaller_build() {
    # Get the project name from pyproject.toml which will be the first instance of name in the file
    PROJECT_NAME=$(grep -m 1 -iE "^name" "${PROJECT_ROOT}/pyproject.toml" | cut -d '"' -f 2)
    # Build the package using pyinstaller
    echo "[INFO] Building the package using pyinstaller"
    if ! poetry run pyinstaller --onefile --name "${PROJECT_NAME}" "${PROJECT_ROOT}/src/tfsm/cli.py"; then
        echo "[ERROR] Failed to build the package using pyinstaller"
        exit 1
    else
        echo "[INFO] Unix-like executable package built successfully"
    fi
}

windows_pyinstaller_build() {
    # Get the project name from pyproject.toml which will be the first instance of name in the file
    PROJECT_NAME=$(grep -m 1 -iE "^name" "${PROJECT_ROOT}/pyproject.toml" | cut -d '"' -f 2)
    # Check if docker is installed and if not error
    if ! command -v docker &> /dev/null; then
        echo "[ERROR] Docker is not installed"
        echo "[WARNING] Docker is required to build for Windows"
        exit 1
    fi
    echo "[WARNING] Windows build is not supported yet"
    # Use a WINE docker image to build the package for Windows ensuring that the package is stored in ${PROJECT_ROOT}/dist
    # echo "[INFO] Building the package for Windows using pyinstaller"

    # if ! docker run --rm -v "${PROJECT_ROOT}:/src:Z" -w /src localhost/winpyinstall:latest --onefile --name "${PROJECT_NAME}" "./src/tfsm/cli.py"; then # Doesn't work, the image is missing pyinstaller and maybe other requirements - might need a Dockerfile and custom build
    # # if ! docker run --rm -v "${PROJECT_ROOT}:/src:Z" -w /src localhost/winpyinstall:latest; then # Doesn't work, the image and python/pyinstaller are too old
    #     echo "[ERROR] Failed to build the package for Windows using pyinstaller"
    #     exit 1
    # else
    #     echo "[INFO] Windows executable package built successfully"
    # fi
}

# Get the current version number from pyproject.toml
CURRENT_VERSION=$(grep -m 1 -iE "^version" "${PROJECT_ROOT}/pyproject.toml" | cut -d '"' -f 2)

# Prompt the user is this the correct value or not
echo "[INFO] The current version number is ${CURRENT_VERSION}"
read -p "Is this the correct version number? [y/n]: " CORRECT_VERSION

# If this is the correct number check if src/tfsm/common/version.py is the same and if not update it
if [[ "${CORRECT_VERSION}" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  # Get the version number from src/tfsm/common/version.py
  CURRENT_VERSION_SRC=$(grep -iE "^__version__" "${PROJECT_ROOT}/src/tfsm/common/version.py" | cut -d '"' -f 2)
  if [[ "${CURRENT_VERSION}" != "${CURRENT_VERSION_SRC}" ]]; then
    echo "[INFO] The version number in pyproject.toml and src/tfsm/common/version.py do not match"
    echo "[INFO] Updating the version number in ${PROJECT_ROOT}/src/tfsm/common/version.py to ${CURRENT_VERSION}"
    if ! update_py_version "${CURRENT_VERSION}"; then
      echo "[ERROR] Failed to update the version number in ${PROJECT_ROOT}/src/tfsm/common/version.py"
      exit 1
    else
      echo "[INFO] Version number in ${PROJECT_ROOT}/src/tfsm/common/version.py updated successfully to ${CURRENT_VERSION}"
      poetry_build
      pyinstaller_build
      windows_pyinstaller_build
      exit 0
    fi
  else
    echo "[INFO] The version number in pyproject.toml and ${PROJECT_ROOT}/src/tfsm/common/version.py match"
    poetry_build
    pyinstaller_build
    windows_pyinstaller_build
    exit 0
  fi
fi

# If the user says no then ask for one of the following:
# 1. Is it a patch update
# 2. Is it a minor update
# 3. Is it a major update
# 4. The user to provide a version number
# If the answer is 1-3 check that CURRENT_VERSION matches 3 dot notation semantic versioning such 1.0.1 or 0.1.3 and update the version number accordingly
# If the answer is 4 check that the version number matches 3 dot notation semantic versioning such 1.0.1 or 0.1.3 and update the version number accordingly

# Ask if this is a (p)atch, (m)inor, (M)ajor update or a (c)ustom version number
read -p "Is this a (p)atch, (m)inor, (M)ajor update or a (c)ustom version number? [p/m/M/c]: " VERSION_UPDATE

# If VERSION_UPDATE is p, P, patch, Patch, PATCH update the version number as a patch update
if [[ "${VERSION_UPDATE}" =~ ^([pP][aA][tT][cC][hH]|[pP])$ ]]; then
  # Check that the current version number matches 3 dot notation semantic versioning such 1.0.1 or 0.1.3
  if [[ "${CURRENT_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Split the version number into its components
    MAJOR=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 1)
    MINOR=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 2)
    PATCH=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 3)
    # Increment the patch number
    PATCH=$((PATCH + 1))
    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    echo "[INFO] Updating the version number in pyproject.toml and ${PROJECT_ROOT}/src/tfsm/common/version.py to ${NEW_VERSION}"
    if ! update_py_version "${NEW_VERSION}" || ! update_pyproject_version "${NEW_VERSION}"; then
      echo "[ERROR] Failed to update the version number correctly"
      exit 1
    else
      echo "[INFO] Version number in ${PROJECT_ROOT}/src/tfsm/common/version.py updated successfully to ${NEW_VERSION}"
      poetry_build
      pyinstaller_build
      windows_pyinstaller_build
      exit 0
    fi
  else
    echo "[ERROR] The current version number does not match 3 dot notation semantic versioning"
    exit 1
  fi
fi

# If VERSION_UPDATE is m, minor, Minor, MINOR update the version number as a minor update
if [[ "${VERSION_UPDATE}" =~ ^([mM][iI][nN][oO][rR]|[m])$ ]]; then
  # Check that the current version number matches 3 dot notation semantic versioning such 1.0.1 or 0.1.3
  if [[ "${CURRENT_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Split the version number into its components
    MAJOR=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 1)
    MINOR=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 2)
    PATCH=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 3)
    # Increment the minor number
    MINOR=$((MINOR + 1))
    PATCH=0
    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    echo "[INFO] Updating the version number in pyproject.toml and ${PROJECT_ROOT}/src/tfsm/common/version.py to ${NEW_VERSION}"
    if ! update_py_version "${NEW_VERSION}" || ! update_pyproject_version "${NEW_VERSION}"; then
      echo "[ERROR] Failed to update the version number correctly"
      exit 1
    else
      echo "[INFO] Version number in ${PROJECT_ROOT}/src/tfsm/common/version.py updated successfully to ${NEW_VERSION}"
      poetry_build
      pyinstaller_build
      windows_pyinstaller_build
      exit 0
    fi
  else
    echo "[ERROR] The current version number does not match 3 dot notation semantic versioning"
    exit 1
  fi
fi

# If VERSION_UPDATE is M, major, Major, MAJOR update the version number as a major update
if [[ "${VERSION_UPDATE}" =~ ^([mM][aA][jJ][oO][rR]|[M])$ ]]; then
  # Check that the current version number matches 3 dot notation semantic versioning such 1.0.1 or 0.1.3
  if [[ "${CURRENT_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # Split the version number into its components
    MAJOR=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 1)
    MINOR=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 2)
    PATCH=$(echo "${CURRENT_VERSION}" | cut -d '.' -f 3)
    # Increment the major number
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
    echo "[INFO] Updating the version number in pyproject.toml and ${PROJECT_ROOT}/src/tfsm/common/version.py to ${NEW_VERSION}"
    if ! update_py_version "${NEW_VERSION}" || ! update_pyproject_version "${NEW_VERSION}"; then
      echo "[ERROR] Failed to update the version number correctly"
      exit 1
    else
      echo "[INFO] Version number in ${PROJECT_ROOT}/src/tfsm/common/version.py updated successfully to ${NEW_VERSION}"
      poetry_build
      pyinstaller_build
      windows_pyinstaller_build
      exit 0
    fi
  else
    echo "[ERROR] The current version number does not match 3 dot notation semantic versioning"
    exit 1
  fi
fi

# If VERSION_UPDATE is c, custom, Custom, CUSTOM ask the user for a version number
if [[ "${VERSION_UPDATE}" =~ ^([cC][uU][sS][tT][oO][mM]|[cC])$ ]]; then
  read -p "Please provide a version number in 3 dot notation semantic versioning such as 1.0.1 or 0.1.3: " NEW_VERSION
  # Check that the version number matches 3 dot notation semantic versioning such 1.0.1 or 0.1.3
  if [[ "${NEW_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "[INFO] Updating the version number in pyproject.toml and ${PROJECT_ROOT}/src/tfsm/common/version.py to ${NEW_VERSION}"
    if ! update_py_version "${NEW_VERSION}" || ! update_pyproject_version "${NEW_VERSION}"; then
      echo "[ERROR] Failed to update the version number correctly"
      exit 1
    else
      echo "[INFO] Version number in ${PROJECT_ROOT}/src/tfsm/common/version.py updated successfully to ${NEW_VERSION}"
      poetry_build
      pyinstaller_build
      windows_pyinstaller_build
      exit 0
    fi
  else
    echo "[ERROR] The version number does not match 3 dot notation semantic versioning"
    exit 1
  fi
fi
