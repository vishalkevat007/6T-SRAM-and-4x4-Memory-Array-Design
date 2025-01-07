clear all;
clc;
close all;

% Importing the data
data = importdata('read_snm.csv'); % Change filename appropriately
vin = data(:,1); % First column: vin
vout = data(:,2); % Second column: vout

% Assigning variables for convenience
vin1 = vin; 
vout1 = vout;
vin2 = vout1;
vout2 = vin1;

% Initialize variables for maximum and second maximum diagonal distances
maxdiagonal = 0;
second_max_diagonal = 0;
distance = 0;

% Variables to store the points for the maximum and second maximum diagonals
myx = 0;
myy = 0;
second_myx = 0;
second_myy = 0;

% Loop through the data to calculate the diagonal distance for each point
for loopvar = 1:length(vin1)
    % Creating 45-degree lines from each point
    x = linspace(vin2(loopvar)-0.5, vin2(loopvar)+0.5, length(vin2));
    y = linspace(vout2(loopvar)-0.5, vout2(loopvar)+0.5, length(vout2));
    
    % Plotting the 45-degree lines
    plot(x, y);
    hold on;
    
    % Finding intersection points between the 45-degree lines and the original data
    P = InterX([x; y], [vin1'; vout1']);
    
    % Plot the intersection points
    plot(x, y, vin1, vout1, vin2, vout2, P(1,:), P(2,:), 'ro');
    
    try
        % Calculate the distance from the intersection point to the current point
        mypts = [vin2(loopvar) P(1); vout2(loopvar) P(2)];
        distance = dist(mypts); % Assuming 'dist' is a function to compute distance
        distance = distance(2); % Get the actual distance value
    catch
        % In case of error, skip this iteration
    end
    
    % Update maximum diagonal if the current distance is greater
    if(distance > maxdiagonal)
        % Update second maximum before updating the max
        second_max_diagonal = maxdiagonal;
        second_myx = myx;
        second_myy = myy;
        
        maxdiagonal = distance;
        myx = vin2(loopvar);
        myy = vout2(loopvar);
    elseif(distance > second_max_diagonal && distance < maxdiagonal)
        % Update the second largest diagonal if the current distance is smaller than max but larger than second max
        second_max_diagonal = distance;
        second_myx = vin2(loopvar);
        second_myy = vout2(loopvar);
    end
end

% Plot the original data points vin1 and vout1
figure();
plot(vin1, vout1, 'b-', 'LineWidth', 1.5);
hold on;

% Plot the vin2 and vout2 data points
plot(vin2, vout2, 'r-', 'LineWidth', 1.5);
grid on;
title('Read Static Noise Margin (RSNM)');
xlim([-0.1 1.1]);  % Set the x-axis limits from -0.1 to 1.1
ylim([-0.1 1.1]);  % Set the y-axis limits from -0.1 to 1.1
xlabel('V(Qb)');
ylabel('V(Q)');

% Display the maximum diagonal distance and the lowest diagonal point (myx, myy)
disp(['Max Diagonal Distance: ', num2str(maxdiagonal)]);
disp(['Second Max Diagonal Distance: ', num2str(second_max_diagonal)]);
% disp(['Lowest Diagonal Point (myx, myy): (', num2str(myx), ', ', num2str(myy), ')']);

% Calculate the highest diagonal point (x2, y2) using the max diagonal distance
x2 = myx + maxdiagonal * cosd(225);
y2 = myy + maxdiagonal * sind(225);

% Plot the diagonal line from (myx, myy) to (x2, y2)
plot([myx, x2], [myy, y2], 'g--', 'MarkerFaceColor', 'r', 'LineWidth', 1);

% Calculate the second highest diagonal point (x2, y2) using the second max diagonal distance
x2_second = second_myx + second_max_diagonal * cosd(45);
y2_second = second_myy + second_max_diagonal * sind(45);

% Plot the second-largest diagonal line from (second_myx, second_myy) to (x2_second, y2_second)
plot([second_myx, x2_second], [second_myy, y2_second], 'm--', 'MarkerFaceColor', 'r', 'LineWidth', 1);

% Plot the lowest diagonal point (myx, myy)
% plot(myx, myy, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);  % Blue circle

% Plot the highest diagonal point (x2, y2)
% plot(x2, y2, 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8);  % Green circle

% Calculate the other two points of the square by moving from (myx, myy) and (x2, y2)
x3 = myx;
y3 = myy - maxdiagonal * sind(45);

x4 = x2;
y4 = y2 + maxdiagonal * sind(45);

% Plot the square using the calculated points
plot([myx, x3], [myy, y3], 'k-', 'LineWidth', 1.5);  % Line from (myx, myy) to (x3, y3)
plot([x2, x4], [y2, y4], 'k-', 'LineWidth', 1.5);  % Line from (x2, y2) to (x4, y4)
plot([x2, x3], [y2, y3], 'k-', 'LineWidth', 1.5);  % Line from (x2, y2) to (x3, y3)
plot([x4, myx], [y4, myy], 'k-', 'LineWidth', 1.5);  % Closing the square

% Calculate the square for the second-largest diagonal
x3_second = second_myx;
y3_second = second_myy + second_max_diagonal * sind(45);

x4_second = x2_second;
y4_second = y2_second - second_max_diagonal * sind(45);

% Plot the square for the second-largest diagonal
plot([second_myx, x3_second], [second_myy, y3_second], 'k-', 'LineWidth', 1.5);  % Line from (second_myx, second_myy) to (x3_second, y3_second)
plot([x2_second, x4_second], [y2_second, y4_second], 'k-', 'LineWidth', 1.5);  % Line from (x2_second, y2_second) to (x4_second, y4_second)
plot([x2_second, x3_second], [y2_second, y3_second], 'k-', 'LineWidth', 1.5);  % Line from (x2_second, y2_second) to (x3_second, y3_second)
plot([x4_second, second_myx], [y4_second, second_myy], 'k-', 'LineWidth', 1.5);  % Closing the second square

% Show the squares and the plot
hold off;

% Calculate the side lengths for both squares
side_length_max = maxdiagonal / sqrt(2);
side_length_second_max = second_max_diagonal / sqrt(2);

% Read static noise margin
read_SNM = min(side_length_max, side_length_second_max);

disp(['Read static noise margin: ', num2str(read_SNM)]);

% Save the figure in high resolution
fig = gcf; % Get the current figure handle

% Set the resolution to 300 DPI for high quality
exportgraphics(fig, 'read_SNM.png', 'Resolution', 300); % Save as PNG
% exportgraphics(fig, 'read_SNM.pdf', 'Resolution', 300); % Save as PDF
