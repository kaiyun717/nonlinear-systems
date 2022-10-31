function xdot = plant(t, x, delta)

x1dot = x(2);
x2dot = x(1) - x(1)^3 - delta * x(2) + x(1)^2 * x(2);

xdot(1) = x1dot;
xdot(2) = x2dot;
xdot = xdot';

end