clear all; close all;
% Choose the plant to simulate.
plant = @plant_zero_dynamics_2a1;

% Number of test initial states for the phase portrait.
N_init_test = 100;
% Range of random initial states.
init_range_eta_1 = [-2*pi, 2*pi];
init_range_eta_2 = [-2*pi, 2*pi];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_eta_1 = [-2*pi, 2*pi];
terminate_range_eta_2 = [-4*pi, 4*pi];
% Range of visualization
vis_range_eta_1 = terminate_range_eta_1;
vis_range_eta_2 = terminate_range_eta_2;

Ts = cell(N_init_test,1);
etas = cell(N_init_test,1);
eta0s = zeros(N_init_test,2);

fig = open_figure('size', [1200 600], 'font_size', 14, 'interpreter', 'latex');
for i=1:N_init_test    

eta0 = [(init_range_eta_1(2)-init_range_eta_1(1))*rand() + init_range_eta_1(1), ... 
            (init_range_eta_2(2)-init_range_eta_2(1))*rand() + init_range_eta_2(1)];        
plant_d = @(t, eta) plant(t, eta);
        
end_event_with_range = @(t, eta) end_event(t, eta, terminate_range_eta_1, terminate_range_eta_2);
option_end = odeset('Events', @(t, eta) end_event_with_range(t, eta));
[Ts_i,etas_i]=ode23(@(t, eta) plant_d(t, eta), [0 20], eta0, option_end);
Ts{i, 1} = Ts_i;
etas{i, 1} = etas_i;
% Plotting the trajectory.
plot(etas_i(:, 1), etas_i(:, 2), 'b'); hold on;
eta0s(i, :) = eta0;
end

xlabel('$\eta_1$');
ylabel('$\eta_2$');
xlim(vis_range_eta_1);
ylim(vis_range_eta_2);

% Uncomment to save the figure
% save_figure(fig, 'file_name', 'pendulum_phase_portrait', 'file_format', 'pdf', 'figure_size', [6 3]);

