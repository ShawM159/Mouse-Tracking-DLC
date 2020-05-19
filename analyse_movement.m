%% Analyse movement
% --> takes input of singular video struct (video) with character input
% 'plot' to plot results or another 4 character word to ignore plots
% (answer)
% --> returns video struct with movement array and dir_speeds array   
    % --> calc_movement subfunction uses the deeplabcut recorded track of
    % coordinate mouse position after being filtered with medfilt1
        % --> calculates coordinate vectors of distance and angular direction 
        % anticlockwise from 0deg west between each consecutive frame
        % --> converts distance into metres using video conversion factor
        % (calculated from measured pixel mouse length/actual mouse
        % length(m))
        % --> calculates speed and cumulative distance travelled per frame
        % --> results are filtered using medfilt1
        % --> creates array of columns:
            % frame, time(s), distance(m), direction(deg),
            % speed(m/s), cumulative distance(m)
            % --> columns 2:6 repeat for different tracked bodyparts
    % --> calc_mean_dir_speed subfunction uses calculated directions and
    % speeds from movement array created with calc_movement
        % --> calculates mean speeds of frames with directions in 45deg
        % bins around orientational directions (+/- 22.5deg from 0deg east,
        % 45deg northeast, 90deg north etc.)
        % --> east bin is directions 0deg-22.5deg and 337.5deg-360deg
        % --> creates array of mean speeds from east
        % anticlockwise to southeast
            % --> whole array repeats for different tracked bodyparts
% --> if input 'answer' == 'plot'
    % --> plots trajectory of pixel coordinates colour coded by direction
        % --> plot_trajectory subfunction
    % --> plots speed/time graph of speeds per frame
    % --> plots polarhistogram of frequency of movements in 30deg bins of
    % angular direction anticlockwise from 0deg east
    % --> plots spiderplot of mean speeds in 45deg bins (+/- 22.5deg from
    % orientational directions [east, northeast, north etc.])
        % --> spider_plot_R2019b subfunction adapted from Moses,2019
            % Copyright (c) 2019-2020, Moses
            % All rights reserved.
            % https://www.mathworks.com/matlabcentral/fileexchange/59561-spider_plot
        
function [video]=analyse_movement(video,answer)

%% Calculations --------------------------------------------

% Calculate movement distance, direction and speed per frame
% Add to struct.movement array
    % Columns: frame, time(s), distance(m), direction(deg), speed(m/s), cumulative distance(m)
[video]=calc_movement(video);

% Create array for mean speed in each direction
% Add to struct.dir_speeds
    % Columns: E,NE,N,NW,W,SW,S,SE
[video]=calc_mean_dir_speed(video);

%% Plotting ---------------------------------------------

if answer=='plot' % input answer, from prompt response in full_analysis and group_full_analysis
    
    % Plot pixel coordinate trajectory coloured by direction of travel
    plot_color_traj(video);

    % Plot speeds of movement per frame
    figure
    tiledlayout('flow') % tiled layout for different bodyparts
    speed_col=5; % first speed column of movement array
    for bp=1:video.num_bodyparts
        nexttile
        plot(video.movement(:,2),video.movement(:,speed_col)); % time vs speed
        title([video.animal ' ' video.name_parts(bp)]); % title of video with which bodypart
        xlabel('Time (s)');
        ylabel('Speed (m/s)');
        speed_col=speed_col+4; % update to next speed column of next bodypart
    end

    % Plot polarhistogram of frequency of movements in direction bins of
    % 30deg from 0deg east
    figure
    tiledlayout('flow') % tiled layout for different bodyparts
    dir_col=4; % first angular direction column of movement array
    for bp=1:video.num_bodyparts
        nexttile
        polarhistogram(video.movement(:,dir_col),12); % 12 bins of 30deg from 0deg east
        title([video.animal ' ' video.name_parts(bp)]); % title of video with which bodypart
        dir_col=dir_col+4; % update to next angular direction column of next bodypart
    end

    % Plot spiderplot of mean speeds (cm/s) in each direction
        % subfunction from Moses,2019 (see above) works better with cm/s
        % than m/s due to small decimal numbers
    figure
    tiledlayout('flow') % tiled layout for different bodyparts
    first_col=1; % column of first mean speed (east) for bodypart 1
    for bp=1:video.num_bodyparts
        nexttile
        last_col=first_col+7; % column of last mean speed (southeast) for bodypart
        mouse=[video.dir_speeds(first_col:last_col)*100]; % singular bodypart section of dir_speeds array, *100 to convert to cm/s
        max_s=ceil(max(mouse)); % find max mean speed and round up to next whole number for upper plot limit
        spider_plot_R2019b(mouse,...
        'AxesLabels',{'E','NE','N','NW','W','SW','S','SE'},... % set axis labels
        'AxesLimits',[0 0 0 0 0 0 0 0;max_s max_s max_s max_s max_s max_s max_s max_s],... % set axis limits
        'Direction','counterclockwise'); % set direction of plotting (same direction as array formation in calc_dir_speeds)
        title([video.animal ' ' video.name_parts(bp)]); % title of video with bodypart
        first_col=first_col+8; % update starting position for next bodypart mean speed
    end
end

%% Functions -----------------------------------------------------------

% Use deeplabcut coordinate track to calculate distance, direction,
% speed, and cumulative distance for each bodypart
function [video]=calc_movement(video)
    x_col=2; % column of first bodypart x coordinates in track
    dist_col=3; % column location for first bodypart distance results
    video.movement=zeros(video.num_frames,2+(4*video.num_bodyparts)); % create empty movement array of frame & time columns + number of repeating 4 movement columns
    for bp=1:video.num_bodyparts % for each bodypart
        y_col=x_col+1; % column of bodypart y coordinates in track
        for row=2:video.num_frames 
            if isnan(video.track(row,x_col)) || isnan(video.track(row,y_col))
                distance=NaN; % dont calculate distance or direction if missing coordinate position
                direction=NaN;
            else 
                y_change=(video.track(row,y_col)*-1)-(video.track(row-1,y_col)*-1); % negative y coord to correct orientation to graphical representation (0 at top of the page)
                x_change=video.track(row,x_col)-video.track(row-1,x_col);
                distance=sqrt(x_change^2 + y_change^2); % use pythagoras for distance vector
                if y_change>=0 && x_change>=0
                    direction=atand(y_change/x_change); % use tan rule for direction vector
                elseif y_change<0 && x_change>=0
                    direction=atand(y_change/x_change)+360; % +360 for directions with +ve x and -ve y change (vector rules)
                elseif x_change<0
                    direction=atand(y_change/x_change)+180; % +180 for directions with -ve x change (vector rules)
                end
            end
            video.movement(row,1)=video.track(row,1); % movement column 1 is set to frame
            video.movement(row,2)=video.track(row,1)/video.FPS; % movement column 2 is set to time (s)
            video.movement(row,dist_col)=distance*video.conv_factor; % first repeating column of bodypart is distance converted to metres (video specific conversion factor) 
            video.movement(row,dist_col+1)=direction; % second repeating column of bodypart is angular direction
        end
        video.movement(:,dist_col+2)=video.movement(:,dist_col)/(1/video.FPS); % third repeating column of bodypart is speed calculated from distance/time
        video.movement(:,dist_col+3)=cumsum(video.movement(:,dist_col),'omitnan'); % fourth repeating column of bodypart is cumulative distance
        video.movement=medfilt1(video.movement,'omitnan'); % filter results
        x_col=x_col+3; % update x coordinate column in track to next bodypart
        dist_col=dist_col+4; % update location for next bodypart distance results 
    end
end

% Plot trajectory coloured by movement direction
function plot_color_traj(video)
    figure
    tiledlayout('flow') % tiled layout for each bodypart
    x_col=2; % first bodypart x coordinates in track array
    dir_col=4; % first bodypart direction column in movement array
    for bp=1:video.num_bodyparts
        y_col=x_col+1; % bodypart y coordinates in track
        nexttile
        hp=patch([video.track(1:video.num_frames,x_col)' NaN],[video.track(1:video.num_frames,y_col)' NaN],0); % plots trajectory lines of x and y coords from track
        set(hp,'cdata', [video.movement(:,dir_col)' NaN],...
            'edgecolor','interp','facecolor','none'); % adds colour to lines determined by direction in movement array
        set(gca, 'YDir','reverse') % flips y axes so 0 is at the top same as in the video position
        hold on;
        scatter(video.track(1:video.num_frames,x_col),video.track(1:video.num_frames,y_col),20,video.movement(:,dir_col),'filled'); % adds marker dots (size 20) for coordinate position in track array coloured by direction in movement array
        colormap hsv % sets rainbow colour scale so 0deg and 360 deg are the same colour
        colorbar('Ticks',[0,45,90,135,180,225,270,315,359],...
            'TickLabels',{'E','NE','N','NW','W','SW','S','SE','E'}) % adds colorbar scale
        hold off
        xlabel('x Position');
        ylabel('y Position');
        title([video.animal ' ' video.name_parts(bp)]); % title of video and bodypart
        x_col=x_col+3; % update x coord column for next bodypart
        dir_col=dir_col+4; % update direction column for next bodypart
    end
end

% Create array for mean speed in each direction (+/-22.5deg from each orientation)
function [video]=calc_mean_dir_speed(video)
    first_col=1; % location of first bodypart first mean direction speed (east)
    dir_col=4; % first bodypart direction column in movement array
    video.dir_speeds=zeros(1,8*video.num_bodyparts); % create empty array of 8 directional bins (E,NE,NW etc.) repeating for each bodypart
    for bp=1:video.num_bodyparts
        speed_col=dir_col+1; % column of bodypart speeds in movement array
        % east bin is made up of 0-22.5deg and 337.5-360deg
        video.dir_speeds(first_col)=nanmean(video.movement(video.movement(:,dir_col)>337.5|video.movement(:,dir_col)<=22.5,speed_col)); % mean of speeds of frames with specified direction
        % other directions are made up of 45deg bins from 22.5deg
        start=22.5; % set start position for northeast bin
        for bin=1:7 % other 7 bins out of 8 (excluding first east bin)
            stop=(bin+0.5)*45; % set end position for bin in degrees
            result=nanmean(video.movement(video.movement(:,dir_col)>start&video.movement(:,dir_col)<=stop,speed_col)); % mean of speeds of frames with specified direction
            video.dir_speeds(bin+first_col)=result;
            start=stop; % update starting position to be the end of the previous bin
        end
        first_col=first_col+8; % update location of first speed (east) for next bodypart
        dir_col=dir_col+4; % update direction column for next bodypart
    end
end

end