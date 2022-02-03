function xdot = plant_violin_string_stiction1(t, x, b)
if nargin < 3
    b = 1.0;
end
M = 3;
k = 3;
c = 2; 
d = 3;

if x(2)>= b
  F = ((x(2)-b)-c)^2 + d;
else
  F = -((x(2)-b)+c)^2 - d;
end

xdot(1) = x(2);
xdot(2) = -1/M*(F + k * x(1));
xdot = xdot';

end