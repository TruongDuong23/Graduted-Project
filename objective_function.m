function objective_value = objective_function(tau, tau_0)

    sum_value = 0;
    M=10;
    I=1;
    
    for m = 1:M
        for i = 1:I
            % Define the integration domain for this i
            % Assuming D_i is a time interval [t_start, t_end]
%             t_start = 0; % Define start time for the integration
%             t_end = 7e-8; % Define end time for the integration
            
            u = zeros(length(tau), length(tau_0));

            for l = 1:length(tau_0)
                tau_00 = tau_0(l);
                u = generatePulse(md, tau_00, tau, 3);
                u(:, i) = u; % Store the generated signal in the array
            end
            
               y(1,1:10,:)
               y = squeeze(y(1,1:10,:));
    
                % Initialize sum
                x_em = y;

            
            % Perform the integral over the domain D_i
%             integral_value = integral(@(t) abs(u(t - tau) .* x_em(t, theta, m)).^2, t_start, t_end);
              integral_value = trapz(u, x_em);

            % Sum the integrals across all paths and dimensions
            sum_value = sum_value + integral_value;
        end
    end
    % Since PSO minimizes the function, and we want to maximize our sum,
    % we can return the negative of the sum
    objective_value = -sum_value;
end
