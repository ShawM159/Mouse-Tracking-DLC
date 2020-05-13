%% Group Movement Analysis

function [struct]=group_full_ANALYSIS(struct)

for i=1:size(struct,2)
    struct(i).track=medfilt1(struct(i).track);
end

% Calculate movement distance, direction and speed per frame
% Add to struct.movement array
    % Columns: frame, time(s), distance(m), direction(deg), speed(m/s), cumulative distance(m)
for i=1:size(struct,2)
    [struct(i)]=calc_movement(struct(i));
    % Create array for mean speed in each direction (m/s)
    % Add to struct.dir_speeds
        % Columns: E,NE,N,NW,W,SW,S,SE
    [struct(i)]=calc_mean_dir_speed(struct(i));
    % Calculate nest times
    % Add to struct.nest_times
        % Columns: time in nest (s), time out nest (s)
    [struct(i)]=calc_nest_time(struct(i));
end

%% Plotting 
% Plot trajectory coloured by direction
figure
tiledlayout('flow')
for i=1:size(struct,2)
    nexttile
    plot_color_traj(struct(i));
end

% Plot pie charts of time in and out of nest
figure
tiledlayout('flow')
for i=1:size(struct,2)
    nexttile
    pie(struct(i).nest_times,{'Inside Nest','Outside Nest'});
    title(struct(i).animal);
    colormap([0 0 1;1 1 0]);
end

% Plot speeds
figure
tiledlayout('flow')
for i=1:size(struct,2)
    nexttile
    plot(struct(i).movement(:,2),struct(i).movement(:,5));
    title(struct(i).animal);
end

% Plot polarhistogram of frequency of movements in direction bins of 30deg
figure
tiledlayout('flow')
for i=1:size(struct,2)
    nexttile
    polarhistogram(struct(i).movement(:,4),12);
    title(struct(i).animal);
end

% Plot paired cumulative distance plots
if mod(size(struct,2),2)==0
    figure
    tiledlayout('flow')
    pos=0;
    for i=1:size(struct,2)
        if mod(i,2)~=0
            subplot(1,size(struct,2)/2,i-pos)
            pos=pos+1;
            plot(struct(i).movement(:,2),struct(i).movement(:,6));
            xlabel('Time (s)')
            ylabel('Cumulative Distance (m)')
            hold on
        elseif mod(i,2)==0
            plot(struct(i).movement(:,2),struct(i).movement(:,6));
            legend_labels={struct(i-1).animal struct(i).animal};
            hold off
            legend(legend_labels,'location','southeast')
        end
    end
end

% Plot group cumulative distance plot
figure
legend_labels=[];
for i=1:size(struct,2)
    plot(struct(i).movement(:,2),struct(i).movement(:,6));
    xlabel('Time (s)')
    ylabel('Cumulative Distance (m)')
    legend_labels=[legend_labels,struct(i).animal];
    hold on        
end
hold off
legend(legend_labels,'location','southeast');

% Plot paired spider plot of mean speed (cm/s) in each direction
if mod(size(struct,2),2)==0
    figure
    tiledlayout('flow')
    pos=1;
    for i=1:size(struct,2)
        if mod(i,2)~=0
            Mouse=struct(i).dir_speeds.*100;
            legend_labels=[struct(i).animal];
        elseif mod(i,2)==0
            Mouse=[Mouse;struct(i).dir_speeds.*100];
            legend_labels=[legend_labels,struct(i).animal];
            subplot(1,size(struct,2)/2,i-pos)
            spider_plot_R2019b(Mouse,...
                'AxesLabels',{'E','NE','N','NW','W','SW','S','SE'},...
                'AxesLimits',[0 0 0 0 0 0 0 0;6 6 6 6 6 6 6 6],...
                'Direction','counterclockwise');
            legend(legend_labels,'location','northeast'); 
            pos=pos+1;
        end
    end
end

% Plot x_distance by time and y_distance by time
figure
for i=1:size(struct,2)
    [xy_distance]=calc_xy_distance(struct(i));
    subplot(2,size(struct,2),i)
    plot(xy_distance(:,2),xy_distance(:,3));
    refline(0,0)
    xlabel('Time (s)')
    ylabel('x Distance (m)')
    title([struct(i).animal ' x'])
    subplot(2,size(struct,2),i+size(struct,2))
    plot(xy_distance(:,2),xy_distance(:,4));
    refline(0,0)
    xlabel('Time (s)')
    ylabel('y Distance (m)')
    title([struct(i).animal ' y'])
end

%% Functions -----------------------------------------------------------

% Calculate distance, speed and direction of movement
function [struct]=calc_movement(struct)
    struct.movement=[0 0 0 0 0];
    for row=2:struct.num_frames 
        if isnan(struct.track(row,2)) || isnan(struct.track(row,2))
            distance=NaN;
            direction=NaN;
        else 
            y_change=(struct.track(row,3)*-1)-(struct.track(row-1,3)*-1); % use negative y coord to correct orientation to graphical representation
            x_change=struct.track(row,2)-struct.track(row-1,2);
            distance=sqrt(x_change^2 + y_change^2);
            if y_change>=0 && x_change>=0
                direction=atand(y_change/x_change);
            elseif y_change<0 && x_change>=0
                direction=atand(y_change/x_change)+360;
            elseif x_change<0
                direction=atand(y_change/x_change)+180;
            end
        end
        struct.movement=[struct.movement;struct.track(row,1) struct.track(row,1)/struct.FPS distance direction 0];
    end
    struct.movement(:,3)=struct.movement(:,3)*struct.conv_factor; % convert to metres
    struct.movement(:,3)=medfilt1(struct.movement(:,3)); % filter distance
    struct.movement(:,4)=medfilt1(struct.movement(:,4)); % filter direction
    struct.movement(:,5)=struct.movement(:,3)/(1/struct.FPS); % calculate speed
    struct.movement=[struct.movement,cumsum(struct.movement(:,3),'omitnan')];
end

% Create array for mean speed in each direction (+/-22.5deg from each orientation)
function [struct]=calc_mean_dir_speed(struct)
    struct.dir_speeds=zeros(1,8);
    struct.dir_speeds(1)=nanmean(struct.movement(struct.movement(:,4)>337.5|struct.movement(:,4)<=22.5,5));
    start=22.5;
    for bin=1:7
        stop=(bin+0.5)*45;
        result=nanmean(struct.movement(struct.movement(:,4)>start&struct.movement(:,4)<=stop,5));
        struct.dir_speeds(bin+1)=result;
        start=stop;
    end
end

% Calculate time in and out of nest
function [struct]=calc_nest_time(struct)
    image=imread(struct.imagepath);
    low_x=struct.nest_bounds(1);
    upp_x=size(image,2)-struct.nest_bounds(2);
    low_y=struct.nest_bounds(3);
    upp_y=size(image,1)-struct.nest_bounds(4);
    frames_in_nest=0;
    frames_out_nest=0;
    for row=2:struct.num_frames
        if struct.track(row,2)>=low_x && struct.track(row,2)<=upp_x && struct.track(row,3)>=low_y && struct.track(row,3)<=upp_y
            frames_in_nest=frames_in_nest+1;
        elseif ~isnan(struct.track(row,2)) && ~isnan(struct.track(row,3))
            frames_out_nest=frames_out_nest+1;
        end
    end
    time_in_nest=frames_in_nest/struct.FPS;
    time_out_nest=frames_out_nest/struct.FPS; 
    struct.nest_times=[time_in_nest time_out_nest];
end

% Plot trajectory coloured by movement direction
function plot_color_traj(struct)
    hp=patch([struct.track(1:struct.num_frames,2)' NaN],[struct.track(1:struct.num_frames,3)' NaN],0); % plots trajectory lines
    set(hp,'cdata', [struct.movement(:,4)' NaN],...
        'edgecolor','interp','facecolor','none'); % adds colour parameter
    set(gca, 'YDir','reverse')
    hold on;
    scatter(struct.track(1:struct.num_frames,2),struct.track(1:struct.num_frames,3),20,struct.movement(:,4),'filled'); % adds coloured marker dots (size 20)
    colormap hsv % sets rainbow colour scale
    colorbar('Ticks',[0,45,90,135,180,225,270,315,359],...
        'TickLabels',{'E','NE','N','NW','W','SW','S','SE','E'}) % adds colorbar scale
    hold off
    xlabel('x Position');
    ylabel('y Position');
    title(struct.animal);
end

% Calculate distance travelled per frame in x and y directions
function [xy_distance]=calc_xy_distance(struct)
    xy_distance=[0 0 0 0];
    for row=2:struct.num_frames
        if isnan(struct.track(row,2)) || isnan(struct.track(row-1,2))
            x_change=NaN;
            y_change=NaN;
        else 
            y_change=(struct.track(row,3)*-1)-(struct.track(row-1,3)*-1);
            x_change=struct.track(row,2)-struct.track(row-1,2);
        end
        xy_distance=[xy_distance;struct.track(row,1) struct.track(row,1)/struct.FPS x_change y_change];
    end
    xy_distance(:,3:4)=xy_distance(:,3:4)*struct.conv_factor; % convert to metres
    xy_distance=medfilt1(xy_distance,'omitnan');
end

% Plot x_change by time and y_change by time
function plot_xy_distance(xy_distance,plot_title)
    plot(xy_distance(:,2),xy_distance(:,3));
    refline(0,0)
    xlabel('Time (s)')
    ylabel('x Distance (m)')
    title(plot_title)
    nexttile
    plot(xy_distance(:,2),xy_distance(:,4));
    refline(0,0)
    xlabel('Time (s)')
    ylabel('y Distance (m)')
    title(plot_title)
end

end