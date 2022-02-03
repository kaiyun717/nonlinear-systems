clear all;
% close all;
% TODO: You will have to implement your own plant_SIR_controlled.m
plant = @plant_SIR_controlled;
% Total population.
N = 7.5e6;
% Transmission rate.
beta = 0.51;
% Recovery rate.
gamma = 0.2;
rho = N * gamma / beta;

init_I = 0;

plant_controlled = @(t, x) plant(t, x, N, beta, gamma);
x0 = [N-init_I, init_I];

[Ts,xs]=ode23(@(t, x) plant_controlled(t, x), 0:1:100, x0);

fig = open_figure('size', [800 900], 'font_size', 16, 'interpreter', 'latex');
draw_SIR_history(Ts, xs, N, true);
yline(rho);
title('Active safety-critical intervention');

save_figure('file_name', 'SIR_controlled', 'figure_size', [6 8], 'file_format', 'pdf');