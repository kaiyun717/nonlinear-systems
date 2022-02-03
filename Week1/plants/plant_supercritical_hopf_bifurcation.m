function xdot = plant_supercritical_hopf_bifurcation(t, x, mu)
% Author: Jason Choi (jason.choi@berkeley.edu)
% Implementatin of Ex 2.17 in Sastry, Nonlinear Systems.
if nargin < 3
    mu = 0.0;
end
xdot(1) = -x(2) + x(1) * (mu - x(1)^2 - x(2)^2);
xdot(2) = x(1) + x(2) * (mu - x(1)^2 - x(2)^2);
xdot = xdot';
end