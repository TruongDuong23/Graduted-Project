 
    
% Initialize the PSO with your parameters and search space

	% Initialize particle positions within the search space
	particle_positions = rand(num_particles, 1) * (search_space_max - search_space_min) + search_space_min;

	% Initialize particle velocities (can be set randomly)
	particle_velocities = rand(num_particles, 1);
	
	%Initialize Personal Best Positions and Objective Values
	personal_best_positions = particle_positions;
	personal_best_objectives = arrayfun(@(tau) objective_function(tau, M, I, theta, u, x_em), personal_best_positions);
	
	%Initialize Global Best Position and Objective Value
	[global_best_objective, global_best_index] = min(personal_best_objectives);
	global_best_position = personal_best_positions(global_best_index);
	
	%Initialize PSO Parameters
	w = 0.5;  % Inertia weight
	c1 = 2;   % Cognitive coefficient
	c2 = 2;   % Social coefficient
	
	%PSO Main Loop
	for iteration = 1:num_iterations
        
		% Update velocities and positions
		particle_velocities = w * particle_velocities + c1 * rand() * (personal_best_positions - particle_positions) + c2 * rand() * (global_best_position - particle_positions);
		particle_positions = particle_positions + particle_velocities;

		% Clip particle positions to the search space
		particle_positions = max(min(particle_positions, search_space_max), search_space_min);

		% Evaluate objective function for each particle
		objectives = arrayfun(@(tau) objective_function(tau, M, I, theta, u, x_em), particle_positions);

		% Update personal best positions and global best position
		update_indices = objectives < personal_best_objectives;
		personal_best_positions(update_indices) = particle_positions(update_indices);
		personal_best_objectives(update_indices) = objectives(update_indices);

		[min_personal_best, min_index] = min(personal_best_objectives);
		if min_personal_best < global_best_objective
            
			global_best_objective = min_personal_best;
			global_best_position = personal_best_positions(min_index);
            
        end
        
    end
   
	
    % Call the PSO function to find the optimal tau
	optimal_tau = pso_for_tau(M, I, theta, u, x_em, num_particles, num_iterations, search_space_min, search_space_max);
	
	
    % You need to use or write a PSO function, as MATLAB does not have a built-in one
    [optimal_tau, fval] = pso(@(tau) objective_function(tau, M, I, theta, u, x_em), num_particles, num_iterations, search_space_min, search_space_max);



% Display the result
disp(['The optimal tau is: ', num2str(optimal_tau)]);
disp(['The maximum value of the objective function is: ', num2str(fval)]);
