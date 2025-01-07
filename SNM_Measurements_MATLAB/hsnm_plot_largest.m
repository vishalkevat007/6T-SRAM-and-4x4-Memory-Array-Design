clear all;
clc;
close all;

% Importing the data
data = importdata('hold_snm.csv'); % Change filename appropriately
vin = data(:,1); % First column: vin
vout = data(:,2); % Second column: vout

% Assigning variables for convenience
vin1 = vin; 
vout1 = vout;
vin2 = vout1;
vout2 = vin1;

% Initialize variables for maximum diagonal distance and calculation
maxdiagonal = 0;
distance = 0;

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
        maxdiagonal = distance;
        myx = vin2(loopvar);
        myy = vout2(loopvar);
    end
end

% Plot the original data points vin1 and vout1
figure();
plot(vin1, vout1, 'b-', 'LineWidth', 1.5);
hold on;

% Plot the vin2 and vout2 data points
plot(vin2, vout2, 'r-', 'LineWidth', 1.5);
grid on;
title('V(Q) vs V(Qb)');
xlim([-0.1 1.1]);  % Set the x-axis limits from -0.1 to 1.1
ylim([-0.1 1.1]);  % Set the y-axis limits from -0.1 to 1.1
xlabel('V(Qb)');
ylabel('V(Q)');

% Display the maximum diagonal distance and the lowest diagonal point (myx, myy)
disp(['Max Diagonal Distance: ', num2str(maxdiagonal)]);
disp(['Lowest Diagonal Point (myx, myy): (', num2str(myx), ', ', num2str(myy), ')']);

% Calculate the highest diagonal point (x2, y2) using the max diagonal distance
x2 = myx + maxdiagonal * cosd(45);
y2 = myy + maxdiagonal * sind(45);

% Plot the diagonal line from (myx, myy) to (x2, y2)
plot([myx, x2], [myy, y2], 'g--', 'MarkerFaceColor', 'r', 'LineWidth', 1);

% Calculate the other two points of the square by moving from (myx, myy) and (x2, y2)
x3 = myx;
y3 = myy + maxdiagonal * sind(45);

x4 = x2;
y4 = y2 - maxdiagonal * sind(45);

% Plot the square using the calculated points
plot([myx, x3], [myy, y3], 'k-', 'LineWidth', 1.5);  % Line from (myx, myy) to (x3, y3)
plot([x2, x4], [y2, y4], 'k-', 'LineWidth', 1.5);  % Line from (x2, y2) to (x4, y4)
plot([x2, x3], [y2, y3], 'k-', 'LineWidth', 1.5);  % Line from (x2, y2) to (x3, y3)
plot([x4, myx], [y4, myy], 'k-', 'LineWidth', 1.5);  % Closing the square

% Show the square and the plot
hold off;
