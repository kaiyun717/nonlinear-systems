function xdot = plant_SIR_controlled(t, x, N, beta, gamma, I_max)
u = max([0, 1 - (gamma*N*I_max) / (beta*x(1)*x(2))]);

Sdot = - beta/N * (1 - u) * x(1) * x(2);
Idot = beta/N * (1 - u) * x(1) * x(2) - gamma * x(2);

xdot(1) = Sdot;
xdot(2) = Idot;
xdot = xdot';

end