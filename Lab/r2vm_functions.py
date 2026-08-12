import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

def calculate_reaction_times_and_choices(r1_data, r2_data, threshold, dt, slide_wind):
    reaction_times_corr = []
    reaction_times_err = []
    choices = []
    ndt=175
    for r1, r2 in zip(r1_data, r2_data):
        # Find the indices where the firing rate exceeds the threshold
        r1_exceed_indices = np.where(np.array(r1) > threshold)[0]
        r2_exceed_indices = np.where(np.array(r2) > threshold)[0]

        # Determine which population reaches the threshold first
        if r1_exceed_indices.size > 0 and (r2_exceed_indices.size == 0 or r1_exceed_indices[0] < r2_exceed_indices[0]):
            reaction_time = r1_exceed_indices[0] * dt * slide_wind
            reaction_times_corr.append(reaction_time+ndt)
            choice = 1  # Indicates first population reached threshold first
        elif r2_exceed_indices.size > 0:
            reaction_time = r2_exceed_indices[0] * dt * slide_wind
            reaction_times_err.append(reaction_time+ndt)
            choice = 0  # Indicates second population reached threshold first
        else:
            reaction_time = None
            choice = None
        
        #reaction_times.append(reaction_time)
        choices.append(choice)
    
    # Calculate average reaction time (excluding None values)
    valid_reaction_times = [rt for rt in reaction_times_corr if rt is not None]
    average_reaction_time_corr = np.mean(valid_reaction_times) if valid_reaction_times else None
    
    valid_reaction_times = [rt for rt in reaction_times_err if rt is not None]
    average_reaction_time_err = np.mean(valid_reaction_times) if valid_reaction_times else None
    
    return average_reaction_time_corr, reaction_times_corr,average_reaction_time_err, reaction_times_err, choices
# Function Definitions
def update_synaptic_dynamics(s, nu, Tnmda, gamma, dt):
    s_next = s + dt*(-s/Tnmda + (1-s)*gamma*nu/1000)
    return s_next

def compute_response(Isyn, a, b, d):
    phi = (a*Isyn - b) / (1 - np.exp(-d * (a*Isyn - b)))
    # Check if phi is a numpy array and then apply the condition
    if isinstance(phi, np.ndarray):
        phi[phi < 0] = 0
    else:  # Single value case
        phi = max(phi, 0)
    return phi

def apply_stimulus(t, Tstim, Tdur, dt, JAext, mu0, coh):
    I_stim_1 = (Tstim/dt < t < (Tstim+Tdur)/dt) * (JAext * mu0 * (1 + coh/100))
    I_stim_2 = (Tstim/dt < t < (Tstim+Tdur)/dt) * (JAext * mu0 * (1 - coh/100))
    return I_stim_1, I_stim_2

def process_data_with_sliding_window(data, time_wind, slide_wind, T_total):
    mean_data = []
    # Compute the mean for the initial window
    mean_data.append(np.mean(data[0:time_wind]))

    # Compute the means for each sliding window
    for j in range(int((T_total - time_wind) / slide_wind)):
        start_index = j * slide_wind
        end_index = start_index + time_wind
        mean_data.append(np.mean(data[start_index:end_index]))

    return mean_data

# Main Simulation

def run_simulation(coh,noise,trials):
    # Stimulus parameters
    coh = coh
    mu0 = 30.0
    noise_amp = noise
    N_trials = trials
    Tstim = 600
    Tdur = 1500

    # Network parameters
    JN11 = 0.2609#.2609
    JN22 = 0.2609#.2609
    JN12 = -0.0497
    JN21 = -0.0497
    Ib1 = 0.3255
    Ib2 = 0.3255

    # Synaptic time and other constants
    Tnmda = 100
    Tampa = 2
    gamma = 0.641
    JAext = 0.00052

    # F-I curve parameters
    a = 270
    b = 108
    d = 0.1540

    # Time conditions
    dt = 0.5
    time_wind = 10
    T_total = int(5000/dt + time_wind)
    slide_wind = 40

    # Initialize data storage
    r1_traj = []
    r2_traj = []
    s1_traj = []
    s2_traj = []

    for i in range(N_trials):
        #print("Trial #", i)
        np.random.seed(i)

        # Initialize variables
        s1 = np.ones(T_total) * 0.1
        s2 = np.ones(T_total) * 0.1
        nu1 = np.ones(T_total) * 2
        nu2 = np.ones(T_total) * 2
        phi1 = np.ones(T_total) 
        phi2 = np.ones(T_total) 
        I_eta1_in = noise_amp*np.random.randn()
        I_eta2_in = noise_amp*np.random.randn()
        I_eta1 = I_eta1_in*np.ones(T_total)
        I_eta2 = I_eta2_in*np.ones(T_total)
        
        Isyn1 = np.zeros(T_total)
        Isyn2 = np.zeros(T_total)

        for t in range(T_total-1):
            # Stimulus processing
            I_stim_1, I_stim_2 = apply_stimulus(t, Tstim, Tdur, dt, JAext, mu0, coh)
            
            # Response functions
            Isyn1[t] = JN11*s1[t] + JN12*s2[t] + I_stim_1 + I_eta1[t]
            
            phi1[t] = compute_response(Isyn1[t], a, b, d)
            
            Isyn2[t] = JN22*s2[t] + JN21*s1[t] + I_stim_2 + I_eta2[t]
            
            phi2[t] = compute_response(Isyn2[t], a, b, d)
            
            # Synaptic dynamics
            s1[t+1] = update_synaptic_dynamics(s1[t], nu1[t], Tnmda, gamma, dt)
            s2[t+1] = update_synaptic_dynamics(s2[t], nu2[t], Tnmda, gamma, dt)
            
            I_eta1[t+1] = I_eta1[t] + (dt/Tampa)*(Ib1 - I_eta1[t]) + np.sqrt(dt/Tampa) * noise_amp * np.random.randn()
            I_eta2[t+1] = I_eta2[t] + (dt/Tampa)*(Ib2 - I_eta2[t]) + np.sqrt(dt/Tampa) * noise_amp * np.random.randn()
            # Ensuring firing rates are always positive
            nu1[t+1] = max(phi1[t], 0)
            nu2[t+1] = max(phi2[t], 0)
#         plt.plot((nu1[500:900]))
#         plt.plot((nu2[500:900]))
        # Inside your main simulation loop, after the time steps loop
        nu1_wind = process_data_with_sliding_window(nu1, time_wind, slide_wind, T_total)
        nu2_wind = process_data_with_sliding_window(nu2, time_wind, slide_wind, T_total)
        s1_wind = process_data_with_sliding_window(s1, time_wind, slide_wind, T_total)
        s2_wind = process_data_with_sliding_window(s2, time_wind, slide_wind, T_total)
#         plt.figure()
#         plt.plot((nu1_wind))
#         plt.plot((nu2_wind))
        # Data collection
        r1_traj.append(nu1_wind)
        r2_traj.append(nu2_wind)
        s1_traj.append(s1_wind)
        s2_traj.append(s2_wind)

    return r1_traj, r2_traj, s1_traj, s2_traj
