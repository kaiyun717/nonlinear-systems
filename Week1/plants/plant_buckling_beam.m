function xdot = plant_buckling_beam(t, x, mu, delta)
if nargin < 3
    mu = 0.3;
end
if nargin < 4
    delta = 1;
end

xdot(1) = x(2);
xdot(2) = mu * x(1) - x(1)^3 - delta * x(2);
xdot = xdot';
end