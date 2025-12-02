#!/bin/bash

# Icarus Verilog Simulation Script for Neural Network Inference
# Usage: ./run_icarus.sh [options]
#
# Options:
#   -n, --samples N    Number of test samples to run (default: 100)
#   -h, --help         Show this help message

set -e

# Default values
NUM_SAMPLES=100
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"
RTL_DIR="$PROJECT_ROOT/rtl"
TB_DIR="$PROJECT_ROOT/tb"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--samples)
            NUM_SAMPLES="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -n, --samples N    Number of test samples (default: 100)"
            echo "  -h, --help         Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Check if Icarus Verilog is installed
if ! command -v iverilog &> /dev/null; then
    echo "Error: Icarus Verilog (iverilog) is not installed."
    echo "Please install it using:"
    echo "  macOS: brew install icarus-verilog"
    echo "  Ubuntu: sudo apt-get install iverilog"
    exit 1
fi

# Create build directory
mkdir -p "$BUILD_DIR"

echo "=========================================="
echo "Neural Network Inference Simulation"
echo "=========================================="
echo "Samples: $NUM_SAMPLES"
echo "Activation: sigmoid (default)"
echo "Build directory: $BUILD_DIR"
echo ""

# Change to project root for relative paths
cd "$PROJECT_ROOT"

# Compile with Icarus Verilog
echo "Compiling RTL and testbench..."
iverilog -o "$BUILD_DIR/neural_net.vvp" \
    -g2012 \
    -I"$RTL_DIR" \
    -DMaxTestSamples=$NUM_SAMPLES \
    "$RTL_DIR"/*.v \
    "$TB_DIR"/*.v \
    2>&1 | tee "$BUILD_DIR/compile.log"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "Error: Compilation failed. Check $BUILD_DIR/compile.log for details."
    exit 1
fi

echo "Compilation successful!"
echo ""

# Run simulation
echo "Running simulation..."
echo "----------------------------------------"
vvp "$BUILD_DIR/neural_net.vvp" 2>&1 | tee "$BUILD_DIR/sim.log"

SIM_EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo "=========================================="
if [ $SIM_EXIT_CODE -eq 0 ]; then
    echo "Simulation completed successfully!"
    echo "Results saved to: $BUILD_DIR/sim.log"
else
    echo "Simulation completed with warnings/errors."
    echo "Check $BUILD_DIR/sim.log for details."
fi
echo "=========================================="

exit $SIM_EXIT_CODE

