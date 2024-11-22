clear
clc
load('dataFAO_final1.mat');
data_matrix = cell2mat(data(:, 2:8));

% Extract necessary columns
col2 = data_matrix(:, 1); % Column 2 - FAO
col3 = data_matrix(:, 2); % Column 3 - GlobalNet
col5 = data_matrix(:, 4); % Column 5 - GlobalNet
col6 = data_matrix(:, 5); % Column 6 - GlobalNet
col7 = data_matrix(:, 6); % Column 7 - GlobalNetMin
col8 = data_matrix(:, 7); % Column 8 - matches.Value1
annex = data(:, 9); % Column 9 - matches.Annex

% Remove rows where column 2 is zero
nonzero_rows = col2 ~= 0;
col2 = col2(nonzero_rows);
col3 = col3(nonzero_rows);
col5 = col5(nonzero_rows);
col6 = col6(nonzero_rows);
col7 = col7(nonzero_rows);
col8 = col8(nonzero_rows);
annex = annex(nonzero_rows);
countries = data(nonzero_rows, 1); % Column 1 - Country names

% Calculate required values (t/ha = MgC/ha)
x_values = (col2 ./ col7);
VOD_values = (col3 ./ col7);
cci_values = (col5 ./ col7);
xu_values = (col6 ./ col7);

figure;
set(gcf, 'Position', [100 100 400 270]);

% Set consistent xlim and ylim
xlim([0, 0.3]);
ylim([0, 0.3]);
hold on;
% Add 1:1 line
plot([0, 0.3], [0, 0.3], 'k--');
% Define colors
color_I = [0 0.4470 0.7410]; % Blue
color_II = [0.8500 0.3250 0.0980]; % Orange
index_I = strcmp(annex, 'I');
index_II = strcmp(annex, 'II');
% Plot scatter with different colors
scatter(x_values(index_I), VOD_values(index_I), 50, 'filled', 'MarkerFaceColor', color_I, 'MarkerFaceAlpha', 0.5);
scatter(x_values(index_II), VOD_values(index_II), 50, 'filled', 'MarkerFaceColor', color_II, 'MarkerFaceAlpha', 0.5);
% Set axis ticks
xticks([0, 0.1, 0.2, 0.3]);
yticks([0, 0.1, 0.2, 0.3]);
% Enable minor grid lines
ax = gca;
ax.FontSize = 9;
ax.XMinorGrid = 'off';
ax.YMinorGrid = 'off';
% Enable main grid lines
grid on;

% Customize main grid line style
ax.GridLineStyle = '-';
ax.GridColor = [0.8 0.8 0.8];
ax.GridAlpha = 0.9; % Opacity of main grid lines
ax.LineWidth = 0.2; % Width of main grid lines

% Add minor grid lines manually
x_minor_ticks = [0.05, 0.15, 0.25];
y_minor_ticks = [0.05, 0.15, 0.25];

for i = 1:length(x_minor_ticks)
    plot([x_minor_ticks(i), x_minor_ticks(i)], ylim, '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.2);
end

for i = 1:length(y_minor_ticks)
    plot(xlim, [y_minor_ticks(i), y_minor_ticks(i)], '--', 'Color', [0.8 0.8 0.8], 'LineWidth', 0.2);
end
ax.Box = 'on';

% Calculate and display metrics for Annex I and Annex II countries
% Annex I countries
x_I = x_values(index_I);
y_I = VOD_values(index_I);
fit_I = polyfit(x_I, y_I, 1);
y_fit_I = polyval(fit_I, x_I);
R2_I = 1 - sum((y_I - y_fit_I).^2) / sum((y_I - mean(y_I)).^2);
slope_I = fit_I(1);
RMSE_I = sqrt(mean((y_I - y_fit_I).^2));
RRMSE_I = (RMSE_I / mean(y_I)) * 100; % Convert to percentage
r = corr(x_I, y_I);

text(0.01, 0.28, sprintf('R^2 = %.2f, slope = %.2f, RRMSE = %.2f%%', R2_I, slope_I, RRMSE_I), 'FontSize', 9, 'Color', color_I);

% Annex II countries
x_II = x_values(index_II);
y_II = VOD_values(index_II);
fit_II = polyfit(x_II, y_II, 1);
y_fit_II = polyval(fit_II, x_II);
R2_II = 1 - sum((y_II - y_fit_II).^2) / sum((y_II - mean(y_II)).^2);
slope_II = fit_II(1);
RMSE_II = sqrt(mean((y_II - y_fit_II).^2));
RRMSE_II = (RMSE_II / mean(y_II)) * 100; % Convert to percentage
text(0.01, 0.25, sprintf('R^2 = %.2f, slope = %.2f, RRMSE = %.2f%%', R2_II, slope_II, RRMSE_II), 'FontSize', 9, 'Color', color_II);

% Add legend
legend('1:1 line', 'Annex I', 'Annex II', 'Location', 'best');

% Add labels and title
xlabel('FAO biomass density (MgC ha^-^1)', 'FontSize', 10);
ylabel('L-VOD biomass density (MgC ha^-^1)', 'FontSize', 10);
text(-0.045, 0.31, '(a)', 'FontSize', 11, 'FontWeight', 'bold');

hold off;
