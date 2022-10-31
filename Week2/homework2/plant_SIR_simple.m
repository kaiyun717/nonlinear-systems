function xdot = plant_SIR_simple(t, x, N, beta, gamma)
Sdot = - beta/N * x(1) * x(2);
Idot = beta/N * x(1) * x(2) - gamma * x(2);

xdot(1) = Sdot;
xdot(2) = Idot;
xdot = xdot';

end