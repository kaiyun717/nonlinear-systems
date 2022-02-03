reverse_dynamics = false;
plant = @(t, x) plant_van_der_pol(t, x, reverse_dynamics);

% Number of test initial states for the phase portrait.
N_init_test = 100;
% Range of random initial states.
init_range_x = [-3.0, 3.0];
init_range_y = [-3.0, 3.0];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_x = init_range_x;
terminate_range_y = init_range_y;
% Range of visualization
vis_range_x = terminate_range_x;
vis_range_y = terminate_range_y;


Ts = cell(N_init_test,1);
xs = cell(N_init_test,1);
x0s = zeros(N_init_test,2);

fig = open_figure('size', [800 600], 'font_size', 14, 'interpreter', 'latex');
for i=1:N_init_test
    
x0 = [(init_range_x(2)-init_range_x(1))*rand() + init_range_x(1), ... 
            (init_range_y(2)-init_range_y(1))*rand() + init_range_y(1)];        
end_event_with_range = @(t, x) end_event(t, x, terminate_range_x, terminate_range_y);
option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
[Ts_i,xs_i]=ode23(@(t, x) plant(t, x), [0 50], x0, option_end);
Ts{i, 1} = Ts_i;
xs{i, 1} = xs_i;
% Plotting the trajectory.
plot(xs_i(:, 1), xs_i(:, 2), 'b'); hold on;
x0s(i, :) = x0;
end

% Plotting initial states
plot(x0s(:, 1), x0s(:, 2), 'LineStyle', 'none', 'Marker', 'd', 'Color', 'r'); hold off;

xlabel('$x_1$');
ylabel('$x_2$');
xlim(vis_range_x);
ylim(vis_range_y);

% Uncomment to save the figure
% save_figure(fig, 'file_name', 'van_der_pol_phase_portrait', 'file_format', 'pdf', 'figure_size', [4 3]);
