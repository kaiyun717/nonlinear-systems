function [value, isterminal, direction] = end_event(t, x, terminate_range_x, terminate_range_y)
if x(1) < terminate_range_x(1) || x(1) > terminate_range_x(2) || ...
        x(2) < terminate_range_y(1) || x(2) > terminate_range_y(2)
    value = 1;
else
    value = -1;
end
isterminal = 1;
direction = 1;
end