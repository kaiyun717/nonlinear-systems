classdef studentControllerInterface < matlab.System
    properties (Access = private)
        %% You can add values that you want to store and updae while running your controller.
        % For more information of the supported data type, see
        % https://www.mathworks.com/help/simulink/ug/data-types-supported-by-simulink.html
        t_prev = -1;
        theta_d = 0;
        p_ball_prev = 0;
        
    end
    methods(Access = protected)
        % function setupImpl(obj)
        %    disp("You can use this function for initializaition.");
        % end

        function V_servo = stepImpl(obj, t, p_ball, theta)
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
            %% PID Controller - Gain Scheduling
            t_prev = obj.t_prev;
            p_ball_prev = obj.p_ball_prev;
            dt = t - t_prev;
            v_ball = (p_ball - p_ball_prev) / dt;
            % Extract reference trajectory at the current timestep.
            [p_ball_ref, v_ball_ref, a_ball_ref] = get_ref_traj(t);
            
            if abs(p_ball_ref) > 10
                p_ball_ref = 0;
            end
            
            % Error terms
            error = p_ball - p_ball_ref;
            d_error = v_ball - v_ball_ref;
            
            % Decide desired servo angle based on simple proportional feedback.
            k_p = 3;
            k_d = 3;
            
            theta_d = - k_p * error - k_d * d_error;

            % Make sure that the desired servo angle does not exceed the physical
            % limit. This part of code is not necessary but highly recommended
            % because it addresses the actual physical limit of the servo motor.
            theta_saturation = 56 * pi / 180;    
            theta_d = min(theta_d, theta_saturation);
            theta_d = max(theta_d, -theta_saturation);

            % Simple position control to control servo angle to the desired
            % position.
            k_servo = 10;
            V_servo = k_servo * (theta_d - theta);
            
            % Update class properties if necessary.
            obj.t_prev = t;
            obj.p_ball_prev = p_ball;
            obj.theta_d = theta_d;
        end
    end
    
    methods(Access = public)
        % Used this for matlab simulation script. fill free to modify it as
        % however you want.
        function [V_servo, theta_d] = stepController(obj, t, p_ball, theta)        
            V_servo = stepImpl(obj, t, p_ball, theta);
            theta_d = obj.theta_d;
        end
    end
    
end
