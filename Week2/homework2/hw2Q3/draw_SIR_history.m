function draw_SIR_history(Ts, xs, N, plot_safety, us)
if nargin < 4
    plot_safety = false;
end
if nargin < 5
    us = [];
end

% palette = get_palette_colors();
length_c = length(Ts);

if plot_safety
    subplot(3, 1, [1, 2]);
end

% plot(Ts_c, xs_c(:, 2)); hold on;
i_object = polyshape([Ts', flip(Ts')], [xs(:, 2)', zeros(1,length_c)]);
i_region = plot(i_object);
i_region.LineStyle = 'none';
% i_region.FaceColor = palette.magenta;
i_region.FaceColor = 'magenta';

i_region.DisplayName = '$I(t)$';
hold on;
s_object = polyshape([Ts', flip(Ts')], [xs(:, 1)' + xs(:, 2)', flip(xs(:, 2)')]);
s_region = plot(s_object);
s_region.LineStyle = 'none';
% s_region.FaceColor = palette.orange;
s_region.FaceColor = 'red';

s_region.DisplayName = '$S(t)$';


r_object = polyshape([Ts', flip(Ts')], [N * ones(1, length_c), flip(xs(:, 1)' + xs(:, 2)')]);
r_region = plot(r_object);
r_region.LineStyle = 'none';
% r_region.FaceColor = palette.blue;
r_region.FaceColor = 'blue';
r_region.DisplayName = '$R(t)$';

if plot_safety
    I_max = 1e6;
    h = line([0, Ts(end)], [I_max, I_max], 'Color', 'r', 'LineWidth', 2);
    h.DisplayName = '$I_{\max}$';
end
xlim([0, Ts(end)]);
ylim([0, N]);
legend('Interpreter', 'latex');
ylabel('Population');
xlabel('$t$ [days]');

%% Plot u(t)
if plot_safety
    subplot(3, 1, 3);
    gamma = 0.2;
    beta = 0.51;
    I_max = 1e6;
    N = 7.5e6;
    if isempty(us)
        us = max(zeros([length_c,1]), 1 - gamma * N * I_max ./ (beta * xs(:, 1) .* xs(:, 2)));
    end
    plot(Ts, us, 'LineWidth', 2, 'Color', 'm');
    ylabel('Intervention $u(t)$');
    xlabel('$t$ [days]');
end

end
