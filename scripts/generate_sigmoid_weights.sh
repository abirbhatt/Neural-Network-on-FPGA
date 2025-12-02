#!/bin/bash

# Script to generate sigmoid weights and biases from trained weights
# This is a wrapper that calls the Python script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Check if Python is available
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "Error: Python is not installed."
    exit 1
fi

PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

# Run the Python script
cd "$PROJECT_ROOT"
$PYTHON_CMD "$SCRIPT_DIR/generate_sigmoid_weights.py"

