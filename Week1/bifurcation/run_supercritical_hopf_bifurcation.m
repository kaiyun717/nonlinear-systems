% Author: Jason Choi (jason.choi@berkeley.edu)
% Reference: Sastry, Nonlinear Systems, Ch 2.5
% Implementatin of (2.18)-(2.19) in Sastry, Nonlinear Systems.
% Observed behaviors:
% The origin changes from being a stable node to being an unstable node as
% mu->0 from the negative value.
% Supercritical Hopf bifurcation.
clear all; close all;
% Choose the set of bifurcation parameter (mu) values to simulate.
mus = [-0.5, -0.25, 0.0, 0.25, 0.5];
% Choose the plant to test out.
plant = @plant_supercritical_hopf_bifurcation;


% Number of test initial states for the phase portrait.
N_init_test = 50;
% Range of random initial states.
init_range_x = [-3.0, 3.0];
init_range_y = [-3.0, 3.0];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_x = [-3.0, 3.0];
terminate_range_y = [-3.0, 3.0];
% Range of visualization
vis_range_x = terminate_range_x;
vis_range_y = terminate_range_y;

N_mus = length(mus);
Ts = cell(N_mus, N_init_test);
xs = cell(N_mus, N_init_test);
x0s = zeros(N_mus, N_init_test,2);
fig = open_figure('size', [1200 600], 'font_size', 14, 'interpreter', 'latex');
for i = 1:N_mus
    mu_i = mus(i);
    plant_i = @(t, x) plant(t, x, mu_i);
    for j = 1:N_init_test
        x0_ij = [(init_range_x(2)-init_range_x(1))*rand() + init_range_x(1), ... 
            (init_range_y(2)-init_range_y(1))*rand() + init_range_y(1)];      

        end_event_with_range = @(t, x) end_event(t, x, terminate_range_x, terminate_range_y);
        option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
        [Ts_ij,xs_ij]=ode23(@(t, x) plant_i(t, x), [0 20], x0_ij, option_end);
        Ts{i, j} = Ts_ij;
        xs{i, j} = xs_ij;
        plot3(mu_i * ones(size(Ts_ij)), xs_ij(:, 1), xs_ij(:, 2), 'b'); hold on;
    end
    
    % plot stable periodic orbits
    if mu_i > 0
        thetas = 0:0.01:2*pi;
        % stable orbit.
        radius_stable = sqrt(mu_i);
        orbits_x = radius_stable * cos(thetas);
        orbits_y = radius_stable * sin(thetas);
        plot3(mu_i * ones(size(orbits_x)), orbits_x, orbits_y, 'k-.', 'LineWidth', 2);
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
view(16, 36);
grid on;
axis on;
