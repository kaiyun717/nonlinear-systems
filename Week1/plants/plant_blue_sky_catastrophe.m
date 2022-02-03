function xdot = plant_blue_sky_catastrophe(t, x, mu)
% Author: Jason Choi (jason.choi@berkeley.edu)
% Implementatin of Ex 2.17 in Sastry, Nonlinear Systems.
if nargin < 3
    mu = 0.0;
end
xdot(1) = -x(1) * sin(mu) - x(2) * cos(mu) ...
    + (1 - x(1)^2 - x(2)^2)^2 * (x(1) * cos(mu) - x(2) * sin(mu));
xdot(2) = x(1) * cos(mu) - x(2) * sin(mu) ...
    + (1 - x(1)^2 - x(2)^2)^2 * (x(1) * sin(mu) + x(2) * cos(mu));
xdot = xdot';
end