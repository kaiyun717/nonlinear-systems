% Author: Jason Choi (jason.choi@berkeley.edu)
% Reference: Sastry, Nonlinear Systems, Ch 2.5
clear all; close all;
plant = @plant_buckling_beam;
% Choose the set of bifurcation parameter (mu) values to simulate.
mus = [-0.4, -0.2, 0.0, 0.2, 0.4];


% Number of test initial states for the phase portrait.
N_init_test = 50;
% Range of random initial states.
init_range_x = [-2.0, 2.0];
init_range_y = [-1.5, 1.5];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_x = [-2.0, 2.0];
terminate_range_y = [-2.5, 2.5];
% Range of visualization
vis_range_x = terminate_range_x;
vis_range_y = terminate_range_y;

N_mus = length(mus);
Ts = cell(N_mus, N_init_test);
xs = cell(N_mus, N_init_test);
x0s = zeros(N_mus, N_init_test,2);
fig = open_figure('size', [1200 600], 'font_size', 14, 'interpreter', 'latex');
for i = 1:N_mus
    for j = 1:N_init_test
        plant_i = @(t, x) plant(t, x, mus(i));
        x0_ij = [(init_range_x(2)-init_range_x(1))*rand() + init_range_x(1), ... 
            (init_range_y(2)-init_range_y(1))*rand() + init_range_y(1)];

        end_event_with_range = @(t, x) end_event(t, x, terminate_range_x, terminate_range_y);
        option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
        [Ts_ij,xs_ij]=ode23(@(t, x) plant_i(t, x), [0 50], x0_ij, option_end);
        Ts{i, j} = Ts_ij;
        xs{i, j} = xs_ij;
        plot3(mus(i) * ones(size(Ts_ij)), xs_ij(:, 1), xs_ij(:, 2), 'k'); hold on;
    end
end
xlabel('$\mu$');
ylabel('$x_1$');
zlabel('$x_2$');
mu_range = [min(mus), max(mus)];
xlim(mu_range);
ylim(vis_range_x);
zlim(vis_range_y);
line(mu_range, [0, 0], [0, 0], 'Color', 'r', 'LineWidth', 2);
line([0, 0], vis_range_x, [0, 0], 'Color', 'r', 'LineWidth', 2);
line([0 0], [0, 0], vis_range_y, 'Color', 'r', 'LineWidth', 2);

%% Plot equilibrium points
line(mu_range, [0, 0], [0, 0], 'Color', 'b', 'LineWidth', 2, 'LineStyle', '-.');
mus_continuous = 0.0:0.01:max(mus);
plot3(mus_continuous, sqrt(mus_continuous), zeros(size(mus_continuous)), ...
    'Color', 'b', 'LineWidth', 2, 'LineStyle', '-.');
plot3(mus_continuous, -sqrt(mus_continuous), zeros(size(mus_continuous)), ...
    'Color', 'b', 'LineWidth', 2, 'LineStyle', '-.');
view(16, 36);
grid on;
axis on;

% Uncomment to save the figure
save_figure(fig, 'file_name', 'buckling_beam_bifurcation', 'file_format', 'pdf', 'figure_size', [6 3]);

