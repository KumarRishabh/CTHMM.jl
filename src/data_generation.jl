# Data Generating model as per contact process on a torus

using Random
using Plots

# Initialize parameters
width, height = 50, 50  # dimensions of the grid
prob_infect = 0.2       # probability of infecting a neighbor
prob_recover = 0.1      # probability of recovery
prob_noise = 0.05       # probability of observation noise
num_steps = 100         # number of time steps to simulate

# Initialize the grid
state = zeros(Bool, width, height)
initial_infections = 10  # start with 10 infected individuals
for _ in 1:initial_infections
    state[rand(1:width), rand(1:height)] = true
end

# Function to update the state of the grid
function update_state(state)
    new_state = copy(state)
    for i in 1:width
        for j in 1:height
            if state[i, j]  # if the node is currently infected
                # Recovery process
                if rand() < prob_recover
                    new_state[i, j] = false
                end
                
                # Infection process
                neighbors = [(i-1) % width + 1, (i+1) % width + 1,
                             (j-1) % height + 1, (j+1) % height + 1]
                for (ni, nj) in [(i, neighbors[3]), (i, neighbors[4]), (neighbors[1], j), (neighbors[2], j)]
                    if rand() < prob_infect
                        new_state[ni, nj] = true
                    end
                end
            end
        end
    end
    return new_state
end

# Function to add noise to observations
function add_noise(state)
    noisy_state = copy(state)
    for i in 1:width
        for j in 1:height
            if rand() < prob_noise
                noisy_state[i, j] = !noisy_state[i, j]
            end
        end
    end
    return noisy_state
end

# Initialize the plot
heatmap(state, color=:green, aspect_ratio=:equal, xlims=(1, width), ylims=(1, height), cbar=false)

# Run the simulation
for step in 1:num_steps
    state = update_state(state)
    noisy_state = add_noise(state)
    heatmap!(noisy_state, color=:red)
    display(plot!)
    sleep(0.1)  # Add a small delay between each step for visualization
end

println("Simulation completed.")
