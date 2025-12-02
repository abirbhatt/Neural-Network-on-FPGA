#!/usr/bin/env python3
"""
Generate sigmoid lookup table (sigContent.mif) with specified precision.
This creates a ROM with 2^sigmoidSize entries for sigmoid activation.
"""

import sys
import os
import math

def sigmoid(x):
    """Sigmoid activation function: 1 / (1 + exp(-x))"""
    try:
        return 1.0 / (1.0 + math.exp(-x))
    except OverflowError:
        # Handle overflow for very large negative values
        return 0.0

def DtoB(num, dataWidth, fracBits):
    """Convert decimal number to two's complement binary format"""
    if num >= 0:
        num = num * (2**fracBits)
        num = int(num)
        if num == 0:
            d = 0
        else:
            d = num
    else:
        num = -num
        num = num * (2**fracBits)
        num = int(num)
        if num == 0:
            d = 0
        else:
            d = 2**dataWidth - num
    return d

def generate_sigmoid_rom(sigmoidSize=5, dataWidth=16, weightIntSize=4, inputIntSize=1, output_file="data/sigmoid/sigContent.mif"):
    """
    Generate sigmoid lookup table ROM content.
    
    Args:
        sigmoidSize: Input width to sigmoid ROM (determines number of entries = 2^sigmoidSize)
        dataWidth: Output width from sigmoid ROM
        weightIntSize: Integer width for weights
        inputIntSize: Integer width for inputs
        output_file: Path to output MIF file
    """
    # Calculate fractional bits
    fractBits = sigmoidSize - (weightIntSize + inputIntSize)
    if fractBits < 0:
        fractBits = 0
    
    # Calculate input range
    # Starting from the smallest input going to the sigmoid LUT
    start_x = -2**(weightIntSize + inputIntSize - 1)
    step_size = 2**(-fractBits)
    
    # Number of entries
    num_entries = 2**sigmoidSize
    
    # Output format: dataWidth bits with (dataWidth - inputIntSize) fractional bits
    output_frac_bits = dataWidth - inputIntSize
    
    # Ensure output directory exists
    output_dir = os.path.dirname(output_file)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)
    
    print("==========================================")
    print("Generating Sigmoid ROM")
    print("==========================================")
    print(f"Sigmoid Size: {sigmoidSize} bits")
    print(f"ROM Entries: {num_entries}")
    print(f"Data Width: {dataWidth} bits")
    print(f"Input Range: {start_x:.4f} to {start_x + (num_entries-1)*step_size:.4f}")
    print(f"Step Size: {step_size:.6f}")
    print(f"Output Format: 1 int bit, {output_frac_bits} frac bits")
    print(f"Output file: {output_file}")
    print()
    
    # Generate ROM content
    x = start_x
    with open(output_file, 'w') as f:
        for i in range(num_entries):
            # Calculate sigmoid value
            sig_val = sigmoid(x)
            
            # Convert to fixed-point binary
            bin_val = DtoB(sig_val, dataWidth, output_frac_bits)
            bin_str = format(bin_val, f'0{dataWidth}b')
            
            f.write(bin_str + '\n')
            
            # Debug: print first few and last few entries
            if i < 5 or i >= num_entries - 5:
                print(f"Entry {i:4d}: x={x:8.4f}, sigmoid={sig_val:.6f}, binary={bin_str}")
            
            x += step_size
    
    print()
    print(f"Successfully generated {num_entries} entries in {output_file}")

if __name__ == "__main__":
    # Default values matching Final_Project setup
    sigmoidSize = 10  # Changed from 5 to 10 for better precision
    dataWidth = 16
    weightIntSize = 4
    inputIntSize = 1
    
    # Get output file path
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    output_file = os.path.join(project_root, "data", "sigmoid", "sigContent.mif")
    
    # Allow command-line override of sigmoidSize
    if len(sys.argv) > 1:
        sigmoidSize = int(sys.argv[1])
    
    generate_sigmoid_rom(sigmoidSize, dataWidth, weightIntSize, inputIntSize, output_file)

