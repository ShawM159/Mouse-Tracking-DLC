%% Analyse oscillations
%--> takes input of singular video struct and answer as 'plot' for plots to
% be included or another 4 character word (e.g.'dont') for no plots
% --> returns xy_distance array of change in x-distance (m) and
% y-distance (m) per frame
    % --> calc_xy_distance subfunction uses x-coord and y-coord positions
    % from deeplabcut track (filtered with medfilt1) and video specific
    % conversion factors to calculate distance changed in the x and y
    % directions between each consecutive frame
        % --> results are filtered using mediflt1
        % --> +ve x=right,-ve x=left, +ve y=up, -ve y=down
        % --> creates array with columns:
            % frame, time(s), x-distance(m), y-distance(m)
                % --> columns 2:4 repeat for each bodypart
% --> if input 'answer'=='plot'
    % --> plot_xy_distance subfunction plots x-distance and y-distance per
    % frame in tiled layout of bodyparts with x graph on top and y graph 
    % on bottom

function [video]=analyse_oscillation(video,answer)

% Calculate distance travelled per frame
    % Columns: frame, time (s), x-distance (m), y-distance (m)
[video]=calc_xy_distance(video);

% Plot x_distance by time and y_distance by time
if answer=='plot'
    plot_xy_distance(video);
end

%% Functions --------------------------------------------------------
% Calculate distance travelled per frame using video track from deeplabcut
function [video]=calc_xy_distance(video)
    video.xy_distance=zeros(video.num_frames,2+2*video.num_bodyparts); % create empty array of frame & time columns + x-dist and y-dist for each bodypart
    x_col=2; % column of first bodypart x-coord in track array
    first_col=3; % column location for first bodypart x-distance in xy_distance array
    for bp=1:video.num_bodyparts % for each bodypart
        y_col=x_col+1; % column of bodypart y-coord in track array
        for row=2:video.num_frames
            if isnan(video.track(row,x_col)) || isnan(video.track(row-1,y_col))
                x_change=NaN; % dont calculate distance if missing coordinates
                y_change=NaN;
            else 
                y_change=(video.track(row,y_col)*-1)-(video.track(row-1,y_col)*-1); % make y-coord negative to correct orientation to graphical representation (0 at top of the page)
                x_change=video.track(row,x_col)-video.track(row-1,x_col);
            end
            video.xy_distance(row,1)=video.track(row,1); % set first column to frame
            video.xy_distance(row,2)=video.track(row,1)/video.FPS; % set second column to time (s)
            video.xy_distance(row,first_col)=x_change*video.conv_factor; % first repeating column of bodypart is x-change converted to distance (m)
            video.xy_distance(row,first_col+1)=y_change*video.conv_factor; % second repeating column of bodypart is y-change converted to distance (m)
        end
        x_col=x_col+3; % update to next bodypart x-coord column in track array
        first_col=first_col+2; % update location to next bodypart x-distance in xy_distance array
    end
    video.xy_distance=medfilt1(video.xy_distance,'omitnan'); % filter results
end

% Plot x_distance by time and y_distance by time for each bodypart
function plot_xy_distance(video)
    figure
    x_col=3; % column of x-distance for first bodypart in xy_distance array
    for bp=1:video.num_bodyparts % for each bodypart
        y_col=x_col+1; % column of y-distance for bodypart in xy_distance array
        subplot(2,video.num_bodyparts,bp) % create subplot for x-distance in upper row in bodypart position
        plot(video.xy_distance(:,2),video.xy_distance(:,x_col)); % plot x-distance by time
        refline(0,0) % add reference line at y=0
        xlabel('Time (s)') 
        ylabel('x Distance (m)')
        title([video.animal,' ',video.name_parts(bp)]) % title of video and bodypart
        subplot(2,video.num_bodyparts,bp+video.num_bodyparts); % create subplot for y-distance in lower row in bodypart position
        plot(video.xy_distance(:,2),video.xy_distance(:,y_col)); % plot y-distance by time
        refline(0,0) % add reference line at y=0
        xlabel('Time (s)')
        ylabel('y Distance (m)')
        x_col=x_col+2; % update column of x-distance for next bodypart
    end
end

end

