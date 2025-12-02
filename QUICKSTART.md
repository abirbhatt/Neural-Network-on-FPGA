# Quick Start Guide

## Prerequisites

Install Icarus Verilog:
```bash
# macOS
brew install icarus-verilog

# Linux
sudo apt-get install iverilog
```

## Running Inference

From the `Final_Project` directory:

```bash
# Run with defaults (100 samples, ReLU activation)
./scripts/run_icarus.sh

# Run with custom number of samples
./scripts/run_icarus.sh -n 500

# Run with sigmoid activation
./scripts/run_icarus.sh -a sigmoid

# Combine options
./scripts/run_icarus.sh -n 1000 -a sigmoid
```

## Expected Output

```
==========================================
Neural Network Inference Simulation
==========================================
Samples: 100
Activation: relu
Build directory: /path/to/Final_Project/build

Compiling RTL and testbench...
Compilation successful!

Running simulation...
----------------------------------------
Configuration completed     200ns
1. Accuracy: 100.000000, Detected number: 7, Expected: 7
2. Accuracy: 100.000000, Detected number: 2, Expected: 2
...
Accuracy: 98.500000
==========================================
Simulation completed successfully!
```

## Troubleshooting

**Error: iverilog not found**
- Install Icarus Verilog (see Prerequisites)

**Error: File not found**
- Make sure you're running from `Final_Project` directory
- Check that all `.mif` files exist in `data/weights/` and `data/biases/`

**Simulation hangs**
- Check `build/sim.log` for errors
- Verify test data files are present in `data/test_data/`

## Project Structure

- `rtl/` - RTL source files
- `tb/` - Testbench
- `data/weights/` - Weight files (80 files)
- `data/biases/` - Bias files (80 files)  
- `data/test_data/` - Test images (10,000 files)
- `scripts/run_icarus.sh` - Main simulation script
- `build/` - Generated files (created automatically)

## Next Steps

- See `README.md` for detailed documentation
- Modify `rtl/include.v` to change network parameters
- Add your own test data to `data/test_data/`

