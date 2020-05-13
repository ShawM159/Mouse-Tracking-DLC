function oscillation_frame(struct)

% Calculate distance travelled per frame
    % Columns: frame, time (s), x-distance (m), y-distance (m)
[xy_distance]=calc_xy_distance(struct);

% Plot x_distance by time and y_distance by time
plot_xy_distance(xy_distance,struct.animal);

%% Functions --------------------------------------------------------
% Calculate distance travelled per frame
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
    tiledlayout(2,1)
    nexttile
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
end

end

