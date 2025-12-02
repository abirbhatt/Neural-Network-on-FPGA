#!/usr/bin/env python3
"""
Generate sigmoid weights and biases from trained weight files.
Converts JSON weight files to MIF format for Icarus simulation.
"""

import sys
import os
import shutil

# Add Tut-5 zynet to path
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
tut5_dir = os.path.join(os.path.dirname(project_root), 'Tut-5')
zynet_dir = os.path.join(tut5_dir, 'zynet')
sys.path.insert(0, tut5_dir)  # Add parent directory to path

# Import modules directly to avoid circular import
import importlib.util
spec_utils = importlib.util.spec_from_file_location("utils", os.path.join(zynet_dir, "utils.py"))
utils = importlib.util.module_from_spec(spec_utils)
spec_utils.loader.exec_module(utils)

spec_gen = importlib.util.spec_from_file_location("genWegitsAndBias", os.path.join(zynet_dir, "genWegitsAndBias.py"))
genWegitsAndBias = importlib.util.module_from_spec(spec_gen)
spec_gen.loader.exec_module(genWegitsAndBias)

# Configuration matching Final_Project setup
dataWidth = 16
weightIntSize = 4
inputIntSize = 1
weightFracWidth = dataWidth - weightIntSize
biasFracWidth = dataWidth - weightIntSize - inputIntSize

# Find weight file
weight_file_new = os.path.join(tut5_dir, 'WeigntsAndBiasesSigmoidNew.txt')
weight_file_old = os.path.join(tut5_dir, 'WeigntsAndBiasesSigmoid.txt')

if os.path.exists(weight_file_new):
    weight_file = weight_file_new
elif os.path.exists(weight_file_old):
    weight_file = weight_file_old
else:
    print(f"Error: No sigmoid weight file found in {tut5_dir}/")
    sys.exit(1)

# Output directory
output_dir = os.path.join(project_root, 'data')
weights_dir = os.path.join(output_dir, 'weights')
biases_dir = os.path.join(output_dir, 'biases')

# Ensure output directories exist
os.makedirs(weights_dir, exist_ok=True)
os.makedirs(biases_dir, exist_ok=True)

print("==========================================")
print("Generating Sigmoid Weights and Biases")
print("==========================================")
print(f"Source file: {weight_file}")
print(f"Output directory: {output_dir}")
print()

# Load weights and biases
print("Loading weights and biases...")
weightArray = utils.genWeightArray(weight_file)
biasArray = utils.genBiasArray(weight_file)

# Set output path for MIF generation (temporarily to output_dir)
original_output_path = genWegitsAndBias.outputPath
genWegitsAndBias.outputPath = output_dir + os.sep

# Generate MIF files
print("Generating MIF files...")
genWegitsAndBias.genWegitsAndBias(dataWidth, weightFracWidth, biasFracWidth, weightArray, biasArray)

# Move files to proper subdirectories
print("Organizing MIF files...")
for f in os.listdir(output_dir):
    src = os.path.join(output_dir, f)
    if os.path.isfile(src):
        if f.startswith('w_') and f.endswith('.mif'):
            dst = os.path.join(weights_dir, f)
            shutil.move(src, dst)
        elif f.startswith('b_') and f.endswith('.mif'):
            dst = os.path.join(biases_dir, f)
            shutil.move(src, dst)

# Restore original path
genWegitsAndBias.outputPath = original_output_path

print()
print("==========================================")
print("Weight generation complete!")
print("==========================================")
print(f"Weights: {weights_dir}/")
print(f"Biases:  {biases_dir}/")
print()
print("You can now run simulation with sigmoid:")
print("  ./scripts/run_icarus.sh -a sigmoid")

