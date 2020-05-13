%% Movement Analysis

function [struct]=analyse_movement(struct)
   
% Calculate movement distance, direction and speed per frame
% Add to struct.movement array
    % Columns: frame, time(s), distance(m), direction(deg), speed(m/s), cumulative distance(m)
[struct]=calc_movement(struct);

% Plot trajectory coloured by direction
plot_color_traj(struct);

% Plot speeds
figure
plot(struct.movement(:,2),struct.movement(:,5));
title(struct.animal);

% Plot polarhistogram of frequency of movements in direction bins of 30deg
figure
polarhistogram(struct.movement(:,4),12);
title(struct.animal);

% Create array for mean speed in each direction
% Add to struct.dir_speeds
    % Columns: E,NE,N,NW,W,SW,S,SE
[struct]=calc_mean_dir_speed(struct);


%% Functions -----------------------------------------------------------
function [struct]=calc_movement(struct)
    struct.movement=[0 0 0 0 0];
    for row=2:struct.num_frames 
        if isnan(struct.track(row,2)) || isnan(struct.track(row,2))
            distance=NaN;
            direction=NaN;
        else 
            y_change=(struct.track(row,3)*-1)-(struct.track(row-1,3)*-1); % negative y coord to correct orientation to graphical representation
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

% Plot trajectory coloured by movement direction
function plot_color_traj(struct)
    figure
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

end