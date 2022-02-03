clear all;
close all;
% TODO: You will have to implement your own plant_SIR_simple.m
plant = @plant_SIR_controlled;
% Total population.
N = 7.5e6;
% Transmission rate.
beta = 0.51;
% Recovery rate.
gamma = 0.2; 
rho = N * gamma / beta;
% I maximum value
I_max = 10^6;

% Number of test initial states of I(t) for the phase portrait.
I_init_test = 50;
% Range of random initial states.
init_range_S = [0, N];
init_range_I = [0, I_max];
% Range of the termination of the simulation in case the trajectory
% diverges.
terminate_range_S = [0, N];
terminate_range_I = [0, N];
% Range of visualization
vis_range_S = [0, N];
vis_range_I = [0, 2 * 10^6];


Ts = cell(I_init_test,1);
xs = cell(I_init_test,1);
x0s = zeros(I_init_test,2);

fig = open_figure('size', [800 600], 'font_size', 14, 'interpreter', 'latex');
for i=1:I_init_test    
plant_controlled = @(t, x) plant(t, x, N, beta, gamma, I_max);
I_0 = (init_range_I(2) - init_range_I(1)) * rand();
S_0 = N - I_0;
x0 = [S_0, I_0];        

end_event_with_range = @(t, x) end_event(t, x, terminate_range_S, terminate_range_I);
option_end = odeset('Events', @(t, x) end_event_with_range(t, x));
[Ts_i,xs_i] = ode23(@(t, x) plant_controlled(t, x), 0:1:100, x0);
Ts{i, 1} = Ts_i;
xs{i, 1} = xs_i;
% Plotting the trajectory.
plot(xs_i(:, 1), xs_i(:, 2), 'b'); hold on;
x0s(i, :) = x0;
end

% Plotting initial states.
plot(x0s(:, 1), x0s(:, 2), 'LineStyle', 'none', 'Marker', 'd', 'Color', 'r'); hold off;

% Plotting the I maximum value for reference.
yline(I_max, 'Color', 'r', 'LineWidth', 5);

xlabel('$S$');
ylabel('$I$');
xlim(vis_range_S);
ylim(vis_range_I);