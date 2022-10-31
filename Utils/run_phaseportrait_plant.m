clear all;
close all;
plant = @plant;

% State variables.
delta = 1;

% Number of test initial states for the phase portrait.
num_init_test = 300;
% Range of random initial states.
init_range_x1 = [-3, 3];
init_range_x2 = [-3, 3];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_x1 = [-3, 3];
terminate_range_x2 = [-3, 3];
% Range of visualization
vis_range_x1 = [-3, 3];
vis_range_x2 = [-3, 3];


Ts = cell(num_init_test,1);
xs = cell(num_init_test,1);
x0s = zeros(num_init_test,2);

fig = open_figure('size', [800 600], 'font_size', 14, 'interpreter', 'latex');
for i=1:num_init_test    
plant_controlled = @(t, x) plant(t, x, delta);
x1_0 = (init_range_x1(2) - init_range_x1(1)) * rand();
x2_0 = (init_range_x2(2) - init_range_x2(1)) * rand();
x0 = [x1_0, x2_0];        

end_event_with_range = @(t, x) end_event(t, x, terminate_range_x1, terminate_range_x2);
option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
[Ts_i, xs_i] = ode23(@(t, x) plant_controlled(t, x), 0:1:10, x0);
Ts{i, 1} = Ts_i;
xs{i, 1} = xs_i;
% Plotting the trajectory.
plot(xs_i(:, 1), xs_i(:, 2), 'b'); hold on;
x0s(i, :) = x0;
end

% Plotting initial states.
plot(x0s(:, 1), x0s(:, 2), 'LineStyle', 'none', 'Marker', 'd', 'Color', 'r'); hold off;

xlabel('x1');
ylabel('x2');
xlim(vis_range_x1);
ylim(vis_range_x2);