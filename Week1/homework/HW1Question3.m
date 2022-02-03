%% Homework 1 Question 3

[x1,x2] = meshgrid(-3:0.1:3, -3:0.1:3);
x1dot = x2;
x2dot = x1 - x1.^3;

fig = open_figure('size', [800 600], 'font_size', 14, 'interpreter', 'latex');

quiver(x1, x2, x1dot, x2dot);

hold on
%% ===============================
clear all; 
% Choose the plant to simulate.
plant = @HamiltonianFunction;

% Number of test initial states for the phase portrait.
N_init_test = 100;
% Range of random initial states.
init_range_x1 = [-2.0, 2.0];
init_range_x2 = [-2.0, 2.0];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_x1 = [-3, 3];
terminate_range_x2 = [-3, 3];
% Range of visualization
vis_range_x1 = [-3, 3];
vis_range_x2 = [-3, 3];


Ts = cell(N_init_test,1);
xs = cell(N_init_test,1);
x0s = zeros(N_init_test,2);

for i=1:N_init_test    
plant_b = @(t, x) plant(t, x);
x0 = [(init_range_x1(2)-init_range_x1(1))*rand() + init_range_x1(1), ... 
            (init_range_x2(2)-init_range_x2(1))*rand() + init_range_x2(1)];        

end_event_with_range = @(t, x) end_event(t, x, terminate_range_x1, terminate_range_x2);
option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
[Ts_i,xs_i]=ode23(@(t, x) plant_b(t, x), [0 50], x0, option_end);
Ts{i, 1} = Ts_i;
xs{i, 1} = xs_i;
% Plotting the trajectory.
plot(xs_i(:, 1), xs_i(:, 2)); hold on;
x0s(i, :) = x0;
end

% Plotting initial states
plot(x0s(:, 1), x0s(:, 2), 'LineStyle', 'none', 'Marker', 'd', 'Color', 'r'); 

% Plotting the centers
plot(-1, 0, "rx");
plot(1, 0, "gx");
hold off;

xlabel('$x_1$');
ylabel('$x_2$');
xlim(vis_range_x1);
ylim(vis_range_x2);

% Uncomment to save the figure
% save_figure(fig, 'file_name', 'violin_string_phase_portrait', 'file_format', 'pdf', 'figure_size', [4 3]);
