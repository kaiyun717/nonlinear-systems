clear all;
% close all;
plant = @plant_SIR_controlled_delayed;
% Total population.
N = 7.5e6;
% Transmission rate.
beta = 0.51;
% Recovery rate.
gamma = 0.2;
I_max = 1e6;
rho = N * gamma / beta;

init_I = 1;

ts = 0;
xs = zeros([101, 2]);
x0 = [N-init_I, init_I];
xs(1, :) = x0;
us = zeros([101, 1]);
days_delay = 7;
for i = 1:100
    if i <= days_delay
        u = max(0, 1 - gamma * N * I_max / (beta * x0(1) * x0(2)));
    else
        u = max(0, 1 - gamma * N * I_max / ...
            (beta * xs(i+1-days_delay, 1) * xs(i+1-days_delay, 2)));        
    end
    us(i) = u;

    plant_controlled = @(t, x) plant(t, x, u, N, beta, gamma);
    [Ts_i,xs_i]=ode23(@(t, x) plant_controlled(t, x), [ts(end), ts(end)+1], xs(i, :)');
    ts = [ts; Ts_i(end)];
    xs(i+1, :) = xs_i(end, :);    
end
us(101) = max(0, 1 - gamma * N * I_max / ...
            (beta * xs(102-days_delay, 1) * xs(102-days_delay, 2)));

fig = open_figure('size', [800 900], 'font_size', 16, 'interpreter', 'latex');
draw_SIR_history(ts, xs, N, true, us);
title('Active safety-critical intervention with time-delay');

save_figure('file_name', 'SIR_controlled_with_delay', 'figure_size', [6 8], 'file_format', 'pdf');