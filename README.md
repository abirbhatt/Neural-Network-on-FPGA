# Neural Network MLP FPGA Implementation

This project contains a reorganized and simplified version of the neural network MLP (Multi-Layer Perceptron) FPGA implementation from the tutorial series. It's designed for easy simulation with Icarus Verilog and running inference on MNIST handwritten digit recognition.

## Project Structure

```
Final_Project/
├── rtl/              # RTL source files (neuron, layers, activation functions)
├── tb/               # Testbench files
├── data/
│   ├── weights/      # Weight files (.mif format) for pretrained network
│   ├── biases/       # Bias files (.mif format)
│   ├── sigmoid/      # Sigmoid lookup table
│   └── test_data/    # MNIST test data files (10,000 samples)
├── scripts/          # Automation scripts
│   └── run_icarus.sh # Main simulation script
├── build/            # Build artifacts (created during simulation)
└── README.md         # This file
```

## Prerequisites

1. **Icarus Verilog**: Install the simulator
   ```bash
   # macOS
   brew install icarus-verilog
   
   # Ubuntu/Debian
   sudo apt-get install iverilog
   ```

2. **Test Data**: The project includes 10,000 MNIST test samples in `data/test_data/`

## Quick Start

### Running Inference Simulation

The simplest way to run inference:

```bash
cd Final_Project
./scripts/run_icarus.sh
```

This will:
- Compile all RTL and testbench files
- Run inference on 100 test samples (default)
- Display accuracy results
- Save logs to `build/` directory

### Customizing Simulation

**Change number of test samples:**
```bash
./scripts/run_icarus.sh -n 500
```

**Use different activation function:**
```bash
./scripts/run_icarus.sh -a sigmoid
```

**Combine options:**
```bash
./scripts/run_icarus.sh -n 1000 -a sigmoid
```

### Manual Compilation

If you prefer to compile manually:

```bash
cd Final_Project
iverilog -o build/neural_net.vvp -g2012 -Irtl -DMaxTestSamples=100 rtl/*.v tb/*.v
vvp build/neural_net.vvp
```

## Network Architecture

The neural network implements a 4-layer fully connected network:

- **Input Layer**: 784 neurons (28x28 MNIST image pixels)
- **Layer 1**: 30 neurons (ReLU activation)
- **Layer 2**: 30 neurons (ReLU activation)
- **Layer 3**: 10 neurons (ReLU activation)
- **Layer 4**: 10 neurons (ReLU activation)
- **Output**: Hardmax layer (finds maximum output)

The network uses:
- **Fixed-point representation**: 16-bit data width
- **Pretrained weights**: Loaded from `.mif` files
- **Two's complement**: For signed number representation

## Configuration

Network parameters are defined in `rtl/include.v`:

- `dataWidth`: 16 bits
- `numLayers`: 5 (including hardmax)
- `sigmoidSize`: 5 (depth of sigmoid lookup table)
- `weightIntWidth`: 4 bits for integer part of weights

To change activation functions, modify `Layer*ActType` in `include.v`:
- `"relu"` for Rectified Linear Unit
- `"sigmoid"` for Sigmoid activation

## Understanding the Results

The simulation output shows:
- Per-sample accuracy as each test image is processed
- Detected digit vs expected digit
- Final overall accuracy percentage

Example output:
```
1. Accuracy: 100.000000, Detected number: 7, Expected: 7
2. Accuracy: 100.000000, Detected number: 2, Expected: 2
...
Accuracy: 98.500000
```

## File Organization

### RTL Files

- `zynet.v`: Top-level module with AXI-Lite interface
- `Layer_*.v`: Layer implementations (Layer_1 through Layer_4)
- `neuron.v`: Individual neuron implementation
- `Weight_Memory.v`: Weight storage (ROM/RAM)
- `Sig_ROM.v`: Sigmoid activation lookup table
- `relu.v`: ReLU activation function
- `maxFinder.v`: Hardmax implementation
- `axi_lite_wrapper.v`: AXI-Lite interface wrapper
- `include.v`: Configuration parameters

### Testbench

- `top_sim.v`: Main testbench that:
  - Loads test data from `data/test_data/`
  - Feeds data through the network
  - Reads results via AXI-Lite interface
  - Calculates and displays accuracy

### Data Files

- **Weights**: `w_L_N.mif` where L=layer number, N=neuron number
- **Biases**: `b_L_N.mif` where L=layer number, N=neuron number
- **Sigmoid**: `sigContent.mif` contains precomputed sigmoid values
- **Test Data**: `test_data_XXXX.txt` contains 784 pixel values + 1 label

## Troubleshooting

### Compilation Errors

1. **Missing include file**: Ensure you're running from `Final_Project` directory
2. **File not found errors**: Check that all `.mif` files are in correct directories
3. **Path issues**: The script assumes you run from `Final_Project` directory

### Simulation Issues

1. **No output**: Check `build/sim.log` for error messages
2. **Wrong accuracy**: Verify test data files are correctly formatted
3. **Memory errors**: Ensure all weight/bias files are present

### Performance

- Simulation time increases linearly with number of samples
- 100 samples: ~1-2 minutes
- 1000 samples: ~10-20 minutes
- Full 10,000 samples: ~2-3 hours

## Extending the Project

### Adding New Test Data

1. Place new test files in `data/test_data/`
2. Name them `test_data_XXXX.txt` where XXXX is a 4-digit number
3. Format: 784 binary pixel values (16-bit each) + 1 label value

### Changing Network Architecture

1. Modify `rtl/include.v` to update layer sizes
2. Generate new weight/bias files using the Python automation tools (see Tut-5)
3. Update Layer instantiation files if neuron counts change

### Using Different Activation Functions

1. Modify `Layer*ActType` in `include.v`
2. Ensure corresponding weight files are trained for that activation
3. For sigmoid: verify `sigContent.mif` matches `sigmoidSize` parameter

## References

This implementation is based on a tutorial series for implementing neural networks on FPGAs. Key concepts:

- Fixed-point arithmetic for hardware efficiency
- Sequential processing to reduce resource usage
- Pretrained networks (training done in software)
- Lookup tables for activation functions

## License

See LICENSE file in the parent directory.

