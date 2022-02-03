function xdot = plant_violin_string_stiction2(t, x, b)
if nargin < 3
    b = 1.0;
end
M = 1;
k = 1;

if x(2) >= 3
    F = 0.5 * (x(2)-3) + 1;
elseif x(2) >= 1
    F = -1 * (x(2)-1) + 3;
elseif x(2) >= -1
    F = -1 * (x(2)+1) - 1;
else 
    F = 0.5 * (x(2)+3) - 2;
end 
    
xdot(1) = x(2);
xdot(2) = -1/M*(F + k * x(1));
xdot = xdot';

end