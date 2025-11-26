#!/usr/bin/env bash

# Define parameters
OWNER="$1"
REPO="$2"
TAG="$3"
NAME="$4"

# Exit the script whenever a non-zero exit status is received
set -e

if [[ -z "${OWNER}" ]]; then
    echo "git.sh: error: <OWNER> was not set"
    echo "git.sh: usage: <OWNER> <REPO> [TAG] [NAME]"
    exit 1
fi

if [[ -z "${REPO}" ]]; then
    echo "git.sh: error: <REPO> was not set"
    echo "git.sh: usage: <OWNER> <REPO> [TAG] [NAME]"
    exit 1
fi





