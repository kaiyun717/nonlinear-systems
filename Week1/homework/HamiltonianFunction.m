function xdot = HamiltonianFunction(t, x)

x1 = x(1);
x2 = x(2);

xdot(1) = x2;
xdot(2) = x1 - x1.^3;

xdot = xdot';

end