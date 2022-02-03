clear all; close all;
plant = @plant_jet_engine;

% Number of test initial states for the phase portrait.
N_init_test = 100;
% Range of random initial states.
init_range_x = [-2, 6];
init_range_y = [-2.5, 10.0];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_x = [-2, 6];
terminate_range_y = [-2.5, 10.0];
% Range of visualization
vis_range_x = terminate_range_x;
vis_range_y = terminate_range_y;
% Parameter of B to simulate
Bs = [0.1, 0.3, 1.0, 10.0];

N_B = length(Bs);
Ts = cell(N_B, N_init_test);
xs = cell(N_B, N_init_test);
x0s = zeros(N_B, N_init_test,2);

fig = open_figure('size', [1200 1600], 'font_size', 14, 'interpreter', 'latex');
for i=1:N_B
    subplot(N_B, 1, i);
    B_i = Bs(i);
    plant_i = @(t, x) plant(t, x, B_i);
    for j=1:N_init_test
    x0 = [(init_range_x(2)-init_range_x(1))*rand() + init_range_x(1), ... 
                (init_range_y(2)-init_range_y(1))*rand() + init_range_y(1)];        

    end_event_with_range = @(t, x) end_event(t, x, terminate_range_x, terminate_range_y);
    option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
    [Ts_ij,xs_ij]=ode23(@(t, x) plant_i(t, x), [0 50], x0, option_end);
    Ts{i, j} = Ts_ij;
    xs{i, j} = xs_ij;
    % Plotting the trajectory.
    plot(xs_ij(:, 1), xs_ij(:, 2), 'b'); hold on;
    x0s(i, j, :) = x0;
    end
    ylabel('$x_2$');
    xlim(vis_range_x);
    ylim(vis_range_y);
    title("B=" + num2str(B_i, '%.2f')); 
end
xlabel('$x_1$');

% Uncomment to save the figure
% save_figure(fig, 'file_name', 'jet_engine_phase_portrait', 'file_format', 'pdf', 'figure_size', [6 8]);

