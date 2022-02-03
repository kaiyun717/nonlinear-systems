function xdot = plant_pendulum(t, x, d)
if nargin < d
    d = 0.00;
end
m = 1;
l = 1;
g = 9.8;

xdot(1) = x(2);
xdot(2) = - (1 / (m * l^2)) * (d * x(2) + m * g * l * sin(x(1)));
xdot = xdot';
end