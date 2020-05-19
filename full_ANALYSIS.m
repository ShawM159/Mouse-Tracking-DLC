%% Full analysis
% --> takes input of singular video struct
% --> returns video struct with movement data, nest_time data, and 
% xy_distance (oscillation data) with or without plots depending on user 
% feedback to prompt question
    % --> movement data: frame, time(s), distance(m), direction(deg),
    % speed(m/s), cumulative distance(m) 
        % --> Columns 3:6 repeated for each bodypart
        % --> Plots - tiled layout for each bodypart
            % --> trajectory colour coded by direction of movement
            % --> speed against time
            % --> polar histogram of frequency of movements in 30deg bins 
            % of angular direction anticlockwise from 0deg east
            % --> spiderplot of mean speeds in 45deg bins (+/- 22.5deg) 
            % around orientational directions [east, northeast, north etc.]
        % (see analyse_movement for details)
    % --> nest_time data: time in nest(s), time out nest(s)
        % --> Columns 1:2 repeated for each bodypart
        % --> Plots - tiled layout for each bodypart
            % --> pie charts of time in and out nest
        % (see analyse_nest_time for details)
    % --> xy_distance (oscillation data): frame, time(s), x-distance(m),
    % y-distance(m)
        % --> Columns 3:4 repeated for each bodypart
        % --> Plots - tiled layout for each bodypart
            % --> x-distance over time and y-distance over time
        % (see analyse_oscillation for details)
        
function [video]=full_ANALYSIS(video)
prompt=['Would you like to plot ' video.animal ' results? (y/n)']; % asks user if they would like to include plots
if input(prompt,'s')=='y'
    answer='plot'; % if user types 'y' then plot
else
    answer='dont'; % else ignore plots
end

[video]=analyse_movement(video,answer); % movement analysis for distance, direction, speed, and cumulative distance

[video]=analyse_nest_time(video,answer); % nest analysis for time in and out of nest

[video]=analyse_oscillation(video,answer); % oscillation analysis for distance moved resolved in x and y directions only

end