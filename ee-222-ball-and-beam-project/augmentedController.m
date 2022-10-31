classdef augmentedController < matlab.System
    properties (Access = private)
        %% You can add values that you want to store and updae while running your controller.
        % For more information of the supported data type, see
        % https://www.mathworks.com/help/simulink/ug/data-types-supported-by-simulink.html
        t_prev = -1;
        p_ball_prev = 0;
        v_ball_prev = 0;
        a_ball_prev = 0;
        theta_prev = 0;
        v_theta_prev = 0;
        
        a_ball_ref_prev = 0;
        dot_a_ball_ref_prev = 0;
        theta_ref_prev = 0;
                
        K = cell2mat(struct2cell(load('lqr_gain.mat')));
    end
    methods(Access = protected)
        % function setupImpl(obj)
        %    disp("You can use this function for initializaition.");
        % end

        function [V_servo, psi] = stepImpl(obj, t, p_ball, theta)
        % This is the main function called every iteration. You have to implement
        % the controller in this function, bu you are not allowed to
        % change the signature of this function. 
        % Input arguments:
        %   t: current time
        %   p_ball: position of the ball provided by the ball position sensor (m)
        %
        %   theta: servo motor angle provided by the encoder of the motor (rad)
        % Output:
        %   V_servo: voltage to the servo input.                    
            %% Approximate 2 - Feedback Linearization
            % Model parameters
            r_g = 0.0254; % (m)
            L = 0.4255;   % (m)
            g = 9.81;     % (m/s^2)
            K = 1.5;      % (rad/sV)
            tau = 0.025;  % (s)
            % Update previous state values
            t_prev = obj.t_prev;
            p_ball_prev = obj.p_ball_prev;
            v_ball_prev = obj.v_ball_prev;
            a_ball_prev = obj.a_ball_prev;
            theta_prev = obj.theta_prev;
            v_theta_prev = obj.v_theta_prev;
            
            dt = t - t_prev;
            % Calculate ball velocity (x2) and angular velocity (x4)
            v_ball = (p_ball - p_ball_prev) / dt;
            a_ball = (v_ball - v_ball_prev) /dt;
            v_theta = (theta - theta_prev) / dt;
            
            % Observer values
            a_ball_ref_prev = obj.a_ball_ref_prev;
            dot_a_ball_ref_prev = obj.dot_a_ball_ref_prev;
            theta_ref_prev = obj.theta_ref_prev;
            
            % Extract reference trajectory at the current timestep.
                % y_d, dot(y_d), ddot(y_d)
            [p_ball_ref, v_ball_ref, a_ball_ref] = get_ref_traj(t);
                % y_d^(3)
            dot_a_ball_ref = (a_ball_ref - a_ball_ref_prev) / dt;
                % y_d^(4)
            ddot_a_ball_ref = (dot_a_ball_ref - dot_a_ball_ref_prev) / dt;
            
                % Theta Ref Observer
            theta_ref = calc_theta_ref(p_ball_ref, v_ball_ref, theta_ref_prev, dt);
            
            % Approximate normal form
            xi1 = p_ball;
            xi2 = theta;
            xi3 = (5*g)/(7*L)*r_g*sin(theta);
            xi4 = (5*g)/(7*L)*r_g*v_theta*cos(theta);
            psi2 = 5/(7*L^2)*r_g^2*p_ball*v_theta^2*cos(theta)^2 - 5/(14*L)*r_g^2*v_theta^2*cos(theta)^2;
            
            a = (5*g*K)/(7*L*tau)*r_g*cos(theta);
            b = -(5*g)/(7*L*tau)*r_g*v_theta*cos(theta) - (5*g)/(7*L)*r_g*v_theta^2*sin(theta);
            
            % Input Design
%             alpha = [4 6 4 1];
            alpha_0 = obj.K(4);
            alpha_1 = obj.K(3);
            alpha_2 = obj.K(2);
            alpha_3 = obj.K(1);
            
            % Claire Exact Tracking
            u = 1/a * (-b + ddot_a_ball_ref + alpha_3*(dot_a_ball_ref - xi4) + alpha_2*(a_ball_ref - xi3) + alpha_1*(v_ball_ref - xi2) + alpha_0*(p_ball_ref - xi1));
%             u = 1/a * (-b - alpha_3*xi4 - alpha_2*xi3 - alpha_1*xi2 - alpha_0*xi1);

            % V saturation
            K_v = 0.5;  % Under 0.7 works okay
            V_servo = K_v*u;
            V_sat = 10;
            V_servo = max(V_servo, -V_sat);
            V_servo = min(V_servo, V_sat);
            V_servo = V_servo;
            
            % Neglected nonlinearity psi
            psi = psi2;
            % Update class properties.
            obj.t_prev = t;
            obj.p_ball_prev = p_ball;
            obj.v_ball_prev = v_ball;
            obj.a_ball_prev = a_ball;
            obj.theta_prev = theta;
            obj.v_theta_prev = v_theta;
            
            obj.a_ball_ref_prev = a_ball_ref;
            obj.dot_a_ball_ref_prev = dot_a_ball_ref;
            obj.theta_ref_prev = theta_ref;
        end
    end
    
    methods(Access = public)
        % Used this for matlab simulation script. fill free to modify it as
        % however you want. 
        % (KAI) Neglected nonlinearity - psi added
        function [V_servo, theta_d, psi] = stepController(obj, t, p_ball, theta)        
            [V_servo, psi] = stepImpl(obj, t, p_ball, theta);
            theta_d = obj.theta_ref_prev;
        end
    end
    
end
