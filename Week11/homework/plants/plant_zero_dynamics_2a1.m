function eta_dot = plant_zero_dynamics_2a1(t, eta)

I = 1;
J = 1;
M = 1;
L = 1;
k = 1;
g = 9.8;

% eta_dot(1) = eta(2);
% eta_dot(2) = - M*g*L / I * sin(eta(1)) - k / I * eta(1);

eta_dot(1) = eta(2);
eta_dot(2) = - eta(1);

eta_dot = eta_dot';
end