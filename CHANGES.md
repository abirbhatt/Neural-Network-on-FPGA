# Changes Made for Icarus Compatibility

This document summarizes the changes made to reorganize the tutorial code for Icarus Verilog simulation.

## Directory Structure

Created a clean `Final_Project/` directory with organized subdirectories:
- `rtl/` - All RTL source files
- `tb/` - Testbench files  
- `data/` - Organized data files (weights, biases, sigmoid, test_data)
- `scripts/` - Automation scripts
- `build/` - Build artifacts (created during simulation)

## Path Fixes

### 1. Include Paths
- Changed Windows-style backslashes to forward slashes
- Updated `tb/top_sim.v`: `"..\rtl\include.v"` → `"../rtl/include.v"`

### 2. Weight and Bias File Paths
- Updated all Layer files to use `data/weights/` and `data/biases/` directories
- Changed from: `weightFile("w_1_0.mif")`
- Changed to: `weightFile("data/weights/w_1_0.mif")`
- Applied to all 4 Layer files (Layer_1.v through Layer_4.v)

### 3. Sigmoid ROM Path
- Updated `rtl/Sig_ROM.v` to use `data/sigmoid/` directory
- Changed from: `"sigContent.mif"`
- Changed to: `"data/sigmoid/sigContent.mif"`

### 4. Test Data Paths
- Updated testbench to construct proper paths for test data files
- Changed from character-by-character filename construction
- Changed to: `$sformat(filePath, "data/test_data/test_data_%04d.txt", testNum)`
- All paths are now relative to project root (where simulation runs)

## Testbench Improvements

### Simplified Data Loading
- Created `loadTestData` task to replace inline code
- Uses `$sformat` for cleaner path construction
- More maintainable and readable

### Removed Unused Code
- Removed old `sendData` task (functionality moved to `loadTestData`)
- Cleaned up duplicate code sections

## New Features

### Icarus Simulation Script
Created `scripts/run_icarus.sh` with:
- Command-line argument parsing
- Configurable number of test samples
- Configurable activation function
- Automatic compilation and simulation
- Log file generation
- Error handling

### Documentation
- `README.md` - Comprehensive documentation
- `QUICKSTART.md` - Quick reference guide
- `CHANGES.md` - This file

## File Organization

### Copied Files
- All RTL files from `Tut-5/src/fpga/rtl/`
- Testbench from `Tut-5/src/fpga/tb/`
- All weight files (80 files: w_1_0.mif through w_4_9.mif)
- All bias files (80 files: b_1_0.mif through b_4_9.mif)
- Sigmoid lookup table (sigContent.mif)
- Test data files (10,000 MNIST test samples)

### Preserved Functionality
- All original RTL functionality preserved
- Pretrained network mode (weights loaded from files)
- AXI-Lite interface maintained
- Accuracy calculation and reporting
- All layer configurations intact

## Compatibility Notes

### Icarus Verilog Requirements
- Uses Verilog-2001 features (`$sformat`, `$readmemb`)
- Compatible with Icarus Verilog 10.0+
- Paths assume Unix-style forward slashes
- Simulation runs from project root directory

### Path Assumptions
- All file paths are relative to `Final_Project/` directory
- Simulation must be run from project root
- Test data files must be named `test_data_XXXX.txt` where XXXX is 4-digit number

## Testing

To verify the setup:
```bash
cd Final_Project
./scripts/run_icarus.sh -n 10
```

This should:
1. Compile without errors
2. Run simulation on 10 test samples
3. Display accuracy results
4. Exit successfully

## Future Improvements

Potential enhancements:
- Support for different data widths via command-line
- Batch processing of multiple test sets
- Performance profiling and timing reports
- Integration with Python automation tools
- Support for different network architectures via config files

