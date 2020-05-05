% Read in edited filtered tracks
[A1,A2,B1,B2]=read_edited_tracks();

% Read in the conversion factors for each track
[A1_mpcoord,A2_mpcoord,B1_mpcoord,B2_mpcoord]=metres_per_coord();

% Calculate movement distance, direction and speed per frame 
    % Columns: frame, time(s), distance(m), direction(deg), speed(m/s), cumulative distance(m)
[A1_movement]=calc_movement(A1,A1_mpcoord);
[A2_movement]=calc_movement(A2,A2_mpcoord);
[B1_movement]=calc_movement(B1,B1_mpcoord);
[B2_movement]=calc_movement(B2,B2_mpcoord);
clear A1_mpcoord A2_mpcoord B1_mpcoord B2_mpcoord;

% Create paired cumulative distance plot
pairplot_cumdist(A1_movement,A2_movement,'A1','A2');
pairplot_cumdist(B1_movement,B2_movement,'B1','B2');

% Create plot of all cumulative distances
groupplot_cumdist(A1_movement,A2_movement,B1_movement,B2_movement);

% Check speeds 
figure
plot(A1_movement(:,2),A1_movement(:,5));
figure
plot(A2_movement(:,2),A2_movement(:,5));
figure
plot(B1_movement(:,2),B1_movement(:,5));
figure
plot(B2_movement(:,2),B2_movement(:,5));

% Create polarhistogram of each movement in bins of 30deg
plot_freq_direction(A1_movement,A2_movement,B1_movement,B2_movement);

% Create array for mean speed in each direction for each track
    % Columns: E,NE,N,NW,W,SW,S,SE
[A1_mean_dir_speed]=calc_mean_dir_speed(A1_movement);
[A2_mean_dir_speed]=calc_mean_dir_speed(A2_movement);
[B1_mean_dir_speed]=calc_mean_dir_speed(B1_movement);
[B2_mean_dir_speed]=calc_mean_dir_speed(B2_movement);

% Create spiderplot of mean speed(cm/s)in each direction
    % adapted spider_plot_R2019b.m line 350 for horizontal start
plot_mean_dir_speed(A1_mean_dir_speed,A2_mean_dir_speed,B1_mean_dir_speed,B2_mean_dir_speed);

% Create paired cumulative distance plot
pairplot_cumdist(A1_movement,A2_movement,'A1','A2');
pairplot_cumdist(B1_movement,B2_movement,'B1','B2');

% Create plot of all cumulative distances
groupplot_cumdist(A1_movement,A2_movement,B1_movement,B2_movement);

%% Functions --------------------------------------------------------
% Calculate distance travelled per frame (30 FPS)
function [track_movement]=calc_movement(track,track_mpcoord)
    track(:,3)=track(:,3)*-1;
    track_movement=[0 0 0 0 0];
    for row=2:27001 % 15 minutes
        if isnan(track(row,2)) || isnan(track(row,2))
            distance=NaN;
            direction=NaN;
        else 
            y_change=track(row,3)-track(row-1,3);
            x_change=track(row,2)-track(row-1,2);
            distance=sqrt(x_change^2 + y_change^2);
            if y_change>=0 && x_change>=0
                direction=atand(y_change/x_change);
            elseif y_change<0 && x_change>=0
                direction=atand(y_change/x_change)+360;
            elseif x_change<0
                direction=atand(y_change/x_change)+180;
            end
        end
        track_movement=[track_movement;track(row,1) track(row,1)/30 distance direction 0];
    end
    track_movement(:,3)=track_movement(:,3)*track_mpcoord; % convert to metres
    track_movement(:,3)=medfilt1(track_movement(:,3)); % filter distance
    track_movement(:,4)=medfilt1(track_movement(:,4)); % filter direction
    track_movement(:,5)=track_movement(:,3)/(1/30); % calculate speed
    track_movement=[track_movement,cumsum(track_movement(:,3),'omitnan')];
end

% Plot paired cumulative distance per second
function pairplot_cumdist(dataset1,dataset2,legend_1,legend_2)
    figure
    plot(dataset1(:,2),dataset1(:,6));
    xlabel('Time (s)')
    ylabel('Cumulative Distance (m)')
    hold on
    plot(dataset2(:,2),dataset2(:,6));
    legend(legend_1,legend_2)
    hold off
end

% Plot group cumulative distance per second
function groupplot_cumdist(A1_movement,A2_movement,B1_movement,B2_movement)
    figure
    plot(A1_movement(:,2),A1_movement(:,6));
    xlabel('Time (s)')
    ylabel('Cumulative Distance (m)')
    hold on
    plot(A2_movement(:,2),A2_movement(:,6));
    plot(B1_movement(:,2),B1_movement(:,6));
    plot(B2_movement(:,2),B2_movement(:,6));
    legend('A1','A2','B1','B2','location','southeast')
    hold off
end


% Plot polarhist of directions using bins of 30deg
function plot_freq_direction(A1_movement,A2_movement,B1_movement,B2_movement);
    figure
    polarhistogram(A1_movement(:,4),12);
    title('A1');
    figure
    polarhistogram(A2_movement(:,4),12);
    title('A2');
    figure
    polarhistogram(B1_movement(:,4),12);
    title('B1');
    figure
    polarhistogram(B2_movement(:,4),12);
    title('B2');
end

% Create array for mean speed in each direction (+/-22.5deg from each orientation)
function [track_mean_dir_speed]=calc_mean_dir_speed(track_movement)
    track_mean_dir_speed=zeros(1,8);
    track_mean_dir_speed(1)=nanmean(track_movement(track_movement(:,4)>337.5|track_movement(:,4)<=22.5,5));
    start=22.5;
    for bin=1:7
        stop=(bin+0.5)*45;
        result=nanmean(track_movement(track_movement(:,4)>start&track_movement(:,4)<=stop,5));
        track_mean_dir_speed(bin+1)=result;
        start=stop;
    end
end

% Plot spider plot of mean speed (cm/s) in each direction
function plot_mean_dir_speed(A1_mean_dir_speed,A2_mean_dir_speed,B1_mean_dir_speed,B2_mean_dir_speed)
    A1_mean_dir_speed_cms=A1_mean_dir_speed.*100;
    A2_mean_dir_speed_cms=A2_mean_dir_speed.*100;
    B1_mean_dir_speed_cms=B1_mean_dir_speed.*100;
    B2_mean_dir_speed_cms=B2_mean_dir_speed.*100;
    MouseA=[A1_mean_dir_speed_cms;A2_mean_dir_speed_cms];
    MouseB=[B1_mean_dir_speed_cms;B2_mean_dir_speed_cms];
    figure
    spider_plot_R2019b(MouseA,...
        'AxesLabels',{'E','NE','N','NW','W','SW','S','SE'},...
        'AxesLimits',[0 0 0 0 0 0 0 0;6 6 6 6 6 6 6 6],...
        'Direction','counterclockwise');
    legend('A1','A2','location','northeast');
    title('Mouse A');
    figure
    spider_plot_R2019b(MouseB,...
        'AxesLabels',{'E','NE','N','NW','W','SW','S','SE'},...
        'AxesLimits',[0 0 0 0 0 0 0 0;6 6 6 6 6 6 6 6],...
        'Direction','counterclockwise');
    legend('B1','B2','location','northeast');
    title('Mouse B');
end







