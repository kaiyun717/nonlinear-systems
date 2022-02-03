clear all;
close all;
% TODO: You will have to implement your own plant_SIR_simple.m
plant = @plant_SIR_simple;
% Total population.
N = 7.5e6;
% Transmission rate.
beta = 0.51;
% Recovery rate.
gamma = 0.2; 
rho = N * gamma / beta;

init_I = 0;

plant_uncontrolled = @(t, x) plant(t, x, N, beta, gamma);
x0 = [N-init_I, init_I];

[Ts,xs]=ode23(@(t, x) plant_uncontrolled(t, x), 0:1:100, x0);

fig = open_figure('size', [800 900], 'font_size', 16, 'interpreter', 'latex');
draw_SIR_history(Ts, xs, N);
title(strcat('Uncontrolled ($\beta=$', num2str(beta, '%.2f'), ')'));
save_figure('file_name', 'SIR_small_beta', 'figure_size', [6 8], 'file_format', 'pdf');