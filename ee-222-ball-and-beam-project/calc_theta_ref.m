function theta_ref = calc_theta_ref(p_ball_ref, v_ball_ref, theta_ref_prev, dt)
    r_g = 0.0254; % (m)
    L = 0.4255;   % (m)
    g = 9.81;     % (m/s^2)
    
    syms theta_d   % theta_desired = theta_ref
    eqn = v_ball_ref ...
        == (5*g)/(7*L)*r_g*sin(theta_d) - 5/7*(L/2-p_ball_ref)*(r_g/L)^2*((theta_d - theta_ref_prev)/dt)^2*cos(theta_d);
    theta_ref = solve(eqn, theta_d);
end

