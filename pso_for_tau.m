
% The PSO function should return the optimal tau
	function optimal_tau = pso_for_tau( u, x_em)
		
    % Define the PSO parameters
	num_particles = 50;     % Number of particles in the swarm
	num_iterations = 1000;   % Number of iterations to perform

% Define the search space for tau
	search_space_min = 1e-8; % Minimum value of tau
	search_space_max = 6e-8; % Maximum value of tau

% % Intialize function u
%     md.type = 'RRC';
%     md.Tp = 0.5e-9;
%     md.beta = 0.5;
   
    tau_0 = linspace(1e-8, 6e-8, 1000);
    tau = (0:4.6414e-12:14999*4.6414e-12)';
    
    M = 10;
    I = 1;
    theta = (0:pi);   
    
    % Initialization
		particle_positions = rand(num_particles, 1) * (search_space_max - search_space_min) + search_space_min;
		particle_velocities = rand(num_particles, 1);
		
		personal_best_positions = particle_positions;
		personal_best_objectives = arrayfun(@(tau) objective_function(tau, M, I, theta, u, x_em), personal_best_positions);

		[global_best_objective, global_best_index] = min(personal_best_objectives);
		global_best_position = personal_best_positions(global_best_index);

		w = 0.5;  % Inertia weight
		c1 = 2;   % Cognitive coefficient
		c2 = 2;   % Social coefficient

		% Main PSO Loop
		for iteration = 1:num_iterations
			particle_velocities = w * particle_velocities + c1 * rand() * (personal_best_positions - particle_positions) + c2 * rand() * (global_best_position - particle_positions);
			particle_positions = particle_positions + particle_velocities;

			% Clip particle positions to the search space
			particle_positions = max(min(particle_positions, search_space_max), search_space_min);

			objectives = arrayfun(@(tau) objective_function(tau, M, I, theta, u, x_em), particle_positions);

			update_indices = objectives < personal_best_objectives;
			personal_best_positions(update_indices) = particle_positions(update_indices);
			personal_best_objectives(update_indices) = objectives(update_indices);

			[min_personal_best, min_index] = min(personal_best_objectives);
			if min_personal_best < global_best_objective
				global_best_objective = min_personal_best;
				global_best_position = personal_best_positions(min_index);
			end
		end
		
		% Return the optimal tau found by PSO
		optimal_tau = global_best_position;
	end
	
	% Call the PSO function to find the optimal tau
	optimal_tau = pso_for_tau(M, I, theta_prime, u, x_em, num_particles, num_iterations, search_space_min, search_space_max);
	
	
    % You need to use or write a PSO function, as MATLAB does not have a built-in one
    [optimal_tau, fval] = pso(@(tau) objective_function(tau, M, I, theta_prime, u, x_em), num_particles, num_iterations, search_space_min, search_space_max);
