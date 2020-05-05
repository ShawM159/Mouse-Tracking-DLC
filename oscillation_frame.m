% Read in edited filtered tracks
%[A1,A2,B1,B2]=read_edited_tracks();

% Read in the conversion factors for each track
%[A1_mpcoord,A2_mpcoord,B1_mpcoord,B2_mpcoord]=metres_per_coord();

% Calculate movement distance, direction,and speed at 0.2s intervals
    % Columns: frame, time(s), change_x(m), changey(m), x_speed(m/s),
    % y_speed(m/s)
%[A1_movement]=calc_movement(A1,A1_mpcoord);
%[A2_movement]=calc_movement(A2,A2_mpcoord);
%[B1_movement]=calc_movement(B1,B1_mpcoord);
%[B2_movement]=calc_movement(B2,B2_mpcoord);
%clear A1_mpcoord A2_mpcoord B1_mpcoord B2_mpcoord;

% Check horizontal/vertical change 
plot_xy_distance(A1_movement,'A1');
plot_xy_distance(A2_movement,'A2');
plot_xy_distance(B1_movement,'B1');
plot_xy_distance(B2_movement,'B2');

% Plot zoomed in on grooming example
plot_xy_zoomed(A1_movement,'A1',4450:6550);
plot_xy_zoomed(A2_movement,'A2',850:1750);
plot_xy_zoomed(B1_movement,'B1',1450:2650);
plot_xy_zoomed(B2_movement,'B2',1450:8500);
plot_xy_zoomed(B2_movement,'B2',4600:5500);


%% Functions --------------------------------------------------------
% Calculate distance travelled per 0.2s (30 FPS, 6 frames in 0.2s)
function [track_movement]=calc_movement(track,track_mpcoord)
    track(:,3)=track(:,3)*-1;
    track_movement=[0 0 0 0 0 0];
    for row=2:27001
        if isnan(track(row,2)) || isnan(track(row-1,2))
            x_change=NaN;
            y_change=NaN;
        else 
            y_change=track(row,3)-track(row-1,3);
            x_change=track(row,2)-track(row-1,2);
        end
        track_movement=[track_movement;track(row,1) NaN x_change y_change 0 0];
    end
    track_movement(:,3:4)=track_movement(:,3:4)*track_mpcoord; % convert to metres
    track_movement(:,5)=track_movement(:,3)/(1/30); % calculate speed x_change
    track_movement(:,6)=track_movement(:,4)/(1/30); % calculate speed y change
    track_movement(track_movement(:,5)>0.4|track_movement(:,5)<-0.4,3:6)=NaN;
    track_movement(track_movement(:,6)>0.4|track_movement(:,6)<-0.4,3:6)=NaN;
    %track_movement=medfilt1(track_movement,'omitnan');
end

function plot_xy_distance(track_movement,plot_title)
    figure
    tiledlayout(2,1)
    nexttile
    plot(track_movement(:,1),track_movement(:,3));
    refline(0,0)
    xlabel('Frame')
    ylabel('x Distance (m)')
    title(plot_title)
    nexttile
    plot(track_movement(:,1),track_movement(:,4));
    refline(0,0)
    xlabel('Frame')
    ylabel('y Distance (m)')
end

function plot_xy_zoomed(track_movement,plot_title,limits)
    figure
    tiledlayout(2,1)
    nexttile
    plot(track_movement(limits,1),track_movement(limits,3));
    refline(0,0)
    xlabel('Frame')
    ylabel('x Distance (m)')
    title(plot_title)
    nexttile
    plot(track_movement(limits,1),track_movement(limits,4));
    refline(0,0)
    xlabel('Frame')
    ylabel('y Distance (m)')
end


