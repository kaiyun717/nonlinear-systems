function xdot = plant_iet_engine(t, x, B)
if nargin < 3
   B = 1;
end
xdot(1) = B*(C(x(1))-x(2));
xdot(2) = 1/B*(x(1)-inv_F_alpha(x(2)));
xdot = xdot';
end

function x = inv_F_alpha(y)
    alpha = 1;
    if y> 0
        x = alpha * sqrt(y);
    elseif y == 0
        x = 0;
    else
        x = -alpha * sqrt(-y);
    end        
end

function y = C(x)
a = 1;
b = 3;
c = 6;
y = -x^3 + (3/2)*(b + a)*x^2 - 3*a*b*x + (2*c + 3*a*b^2 - b^3)/2;
end