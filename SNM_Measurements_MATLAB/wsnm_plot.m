clear all;
clc;
close all;

% Importing the data
data = importdata('write_snm.csv'); % Change filename appropriately
vin1 = data(:,1); % First column: vin
vout1 = data(:,2); % Second column: vout
vin2 = data(:,1);
vout2 = data(:,3);

% Initialize variables for minimum diagonal distances
mindistance = inf; % Smallest diagonal distance
second_mindistance = inf; % Second smallest diagonal distance
distance = 0;

% Initialize variables to store points for the diagonals
minx = 0; miny = 0; % Smallest diagonal point
second_minx = 0; second_miny = 0; % Second smallest diagonal point

% Loop through the data to calculate the diagonal distance for each point
for loopvar = 1:length(vin1)
    % Creating 45-degree lines from each point
    y = linspace(vin2(loopvar)-0.5, vin2(loopvar)+0.5, length(vin2));
    x = linspace(vout2(loopvar)-0.5, vout2(loopvar)+0.5, length(vout2));
    
    % Plotting the 45-degree lines
    plot(x, y);
    hold on;
    
    % Finding intersection points between the 45-degree lines and the original data
    P = InterX([x; y], [vin1'; vout1']);
    
    % Plot the intersection points
    plot(x, y, vin1, vout1, vout2, vin2, P(1,:), P(2,:), 'ro');
    
    try
        % Calculate the distance from the intersection point to the current point
        mypts = [vin2(loopvar) P(1); vout2(loopvar) P(2)];
        distance = dist(mypts); % Assuming 'dist' is a function to compute distance
        distance = distance(2); % Get the actual distance value
    catch
        % In case of error, skip this iteration
        continue;
    end
    
    % Update minimum and second minimum distances
    if distance < mindistance
        % Shift the current minimum to second minimum
        second_mindistance = mindistance;
        second_minx = minx;
        second_miny = miny;
        
        % Update the smallest diagonal
        mindistance = distance;
        minx = vin2(loopvar);
        miny = vout2(loopvar);
    elseif distance < second_mindistance && distance > mindistance
        % Update only the second smallest diagonal
        second_mindistance = distance;
        second_minx = vin2(loopvar);
        second_miny = vout2(loopvar);
    end
end

% Plot the original data points vin1 and vout1
figure();
plot(vin1, vout1, 'b-', 'LineWidth', 1.5);
hold on;

% Plot the vin2 and vout2 data points
plot(vout2, vin2, 'r-', 'LineWidth', 1.5);
grid on;
title('Write Static Noise Margin (WSNM)');
xlim([-0.1 1.1]);  % Set the x-axis limits from -0.1 to 1.1
ylim([-0.1 1.1]);  % Set the y-axis limits from -0.1 to 1.1
xlabel('V(Qb)');
ylabel('V(Q)');

% Display the smallest and second smallest diagonal distances and points
disp(['Min Diagonal Distance: ', num2str(mindistance)]);
% disp(['Smallest Diagonal Point (minx, miny): (', num2str(minx), ', ', num2str(miny), ')']);
disp(['Second Min Diagonal Distance: ', num2str(second_mindistance)]);
% disp(['Second Smallest Diagonal Point (second_minx, second_miny): (', num2str(second_minx), ', ', num2str(second_miny), ')']);

% Calculate the diagonal line for the second smallest diagonal
x2_second = second_minx + second_mindistance * cosd(45);
y2_second = second_miny + second_mindistance * sind(45);

% Plot the diagonal line for the second smallest diagonal
plot([second_minx, x2_second], [second_miny, y2_second], 'g--', 'MarkerFaceColor', 'r', 'LineWidth', 1);

% Calculate the other two points of the square using the second smallest diagonal
x3_second = second_minx;
y3_second = second_miny + second_mindistance * sind(45);

x4_second = x2_second;
y4_second = y2_second - second_mindistance * sind(45);

% Plot the square using the calculated points for the second smallest diagonal
plot([second_minx, x3_second], [second_miny, y3_second], 'k-', 'LineWidth', 1.5);  % Line from (second_minx, second_miny) to (x3_second, y3_second)
plot([x2_second, x4_second], [y2_second, y4_second], 'k-', 'LineWidth', 1.5);  % Line from (x2_second, y2_second) to (x4_second, y4_second)
plot([x2_second, x3_second], [y2_second, y3_second], 'k-', 'LineWidth', 1.5);  % Line from (x2_second, y2_second) to (x3_second, y3_second)
plot([x4_second, second_minx], [y4_second, second_miny], 'k-', 'LineWidth', 1.5);  % Closing the square

% Show the square and the plot
hold off;

% Calculate the side lengths for the minimum square
side_length_min = second_mindistance / sqrt(2);

% Write static noise margin
write_SNM = side_length_min;

disp(['Write static noise margin: ', num2str(write_SNM)]);

% Save the figure in high resolution
fig = gcf; % Get the current figure handle

% Set the resolution to 300 DPI for high quality
exportgraphics(fig, 'write_SNM.png', 'Resolution', 300); % Save as PNG
% exportgraphics(fig, 'write_SNM.pdf', 'Resolution', 300); % Save as PDF
