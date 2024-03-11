# SIR model simulation - plotting results
# Code written by ChatGPT 3.5 with minor modifications

import pandas as pd
import matplotlib.pyplot as plt
import argparse
import time

# Define and parse command-line arguments
parser = argparse.ArgumentParser(description="Plot Simulation Results")
parser.add_argument("input_files", nargs="+", help="Input CSV files with simulation results")
parser.add_argument("--out", default="simulation_plot.png", help="Output plot file (default: simulation_plot.png)")
args = parser.parse_args()

# Initialize data frames to store results
results = []

# Define a color-blind friendly palette
colors = ['#1f77b4', '#ff7f0e', '#2ca02c']  # Blue, orange, green

# Read data from each CSV file and plot
plt.figure(figsize=(10, 5))
for idx, input_file in enumerate(args.input_files):
    data = pd.read_csv(input_file)
    results.append(data)
    
    # Plot infected, susceptible, and recovered for the current simulation
    plt.plot(data["day"], data["infected"], color=colors[0])
    plt.plot(data["day"], data["susceptible"], color=colors[1])
    plt.plot(data["day"], data["recovered"], color=colors[2])

# Manually add legend labels for population groups
plt.plot([], [], color=colors[0], label="Infected")
plt.plot([], [], color=colors[1], label="Susceptible")
plt.plot([], [], color=colors[2], label="Recovered")

plt.xlabel('Days')
plt.ylabel('Population')
plt.title('Simulation Results')
plt.legend()
plt.grid(True)

# Save the plot to a file
plt.savefig(args.out)
plt.close()  # Close the plot window

# For demo purposes on SLURM sleep for 1 min
# time.sleep(60)

# Message
print(f"Plot saved as {args.out}")