function xdot = plant_van_der_pol(t, x, reverse)
if nargin < 3
    reverse = 0;
end
xdot(1) = x(2);
xdot(2) = -x(1) -(x(1)^2 - 1) * x(2);
xdot = xdot';
if reverse
    xdot = -xdot;
end
end