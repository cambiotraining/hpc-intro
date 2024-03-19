# SIR model simulation 
# Code written by ChatGPT 3.5 with minor modifications

import numpy as np
import argparse
import csv
import time

# Define and parse command-line arguments
parser = argparse.ArgumentParser(description="Stochastic Spatial SIR Model Simulation")
parser.add_argument("--beta", type=float, default=0.3, help="Infection rate (default: 0.3)")
parser.add_argument("--gamma", type=float, default=0.1, help="Recovery rate (default: 0.1)")
parser.add_argument("--population", type=int, default=500, help="Total population size (default: 500)")
parser.add_argument("--initial_infected", type=int, default=1, help="Initial infected individuals (default: 1)")
parser.add_argument("--days", type=int, default=100, help="Number of simulation days (default: 100)")
parser.add_argument("--out", type=str, default="sir_simulation_results.csv", help="Output CSV file (default: sir_simulation_results.csv)")
args = parser.parse_args()

# Parameters
beta = args.beta
gamma = args.gamma
population = args.population
days = args.days
initial_infected = args.initial_infected
initial_susceptible = population - initial_infected
initial_recovered = 0
days = args.days

# Lists to store data
susceptible = [initial_susceptible]
infected = [initial_infected]
recovered = [initial_recovered]

# Simulation loop
for day in range(1, days+1):
  new_infections = np.random.binomial(susceptible[-1], beta * infected[-1] / population)
  new_recoveries = np.random.binomial(infected[-1], gamma)

  susceptible.append(susceptible[-1] - new_infections)
  infected.append(infected[-1] + new_infections - new_recoveries)
  recovered.append(recovered[-1] + new_recoveries)
  
  # print a progress message
  if day % 10 == 0:
    print(f"Day {day}...")
    # time.sleep(5) # make it run longer for demo purposes on SLURM

# Create and write results to a CSV file
csv_data = list(zip(range(1, days+1), infected, susceptible, recovered))
with open(args.out, "w", newline="") as csvfile:
  csv_writer = csv.writer(csvfile)
  csv_writer.writerow(["day", "infected", "susceptible", "recovered"])
  csv_writer.writerows(csv_data)

print(f"Saved output to {args.out}")
