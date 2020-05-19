%% Analyse nest times
%--> takes input of singular video struct and answer as 'plot' for plots to
% be included or another 4 character word (e.g.'dont') for no plots
% --> returns nest_times array of time in nest and time out of nest (s)
    % --> calc_nest_time subfunction uses still image of video and
    % specified nest bounds to count the frames where the mouse is in and
    % out of the nest and convert the number of frames to time (s)
        % --> creates array with columns:
            % time in nest (s), time out nest(s)
                % columns 1:2 repeat for each bodypart
% --> if 'answer'=='plot'
    % --> plot_nest_times subfunction plots pie charts of time in and out
    % of nest in tiled layout for each bodypart


function [video]=analyse_nest_time(video,answer)

% Calculate nest times for each bodypart
    % columns: time in nest (s), time out nest(s)
[video]=calc_nest_time(video);

% Plot nest times for each bodypart
if answer=='plot'
    plot_nest_times(video);
end

%% Functions ----------------------------------------------
% Calculate nest times from coordinate postion in deeplabcut track array
% using specified nest bounds taken from still image of video
function [video]=calc_nest_time(video)
    image=imread(video.imagepath); % read in still image
    low_x=video.nest_bounds(1); % x-coord of left of nest
    upp_x=size(image,2)-video.nest_bounds(2); % x-coord of right of nest
    low_y=video.nest_bounds(3); % y-coord of top of nest (y position tracked top to bottom)
    upp_y=size(image,1)-video.nest_bounds(4); % y-coord of base of nest (y position tracked top to bottom)
    video.nest_times=zeros(1,2*video.num_bodyparts); % create an empty array of frame, time(s) + time in nest and time out nest repeated for each bodypart
    x_col=2; % first bodypart x-coordinate column in track array
    first_col=1; % location for first bodypart time in nest value
    for bp=1:video.num_bodyparts % for each bodypart
        frames_in_nest=0; 
        frames_out_nest=0; 
        y_col=x_col+1; % bodypart y-coordinate column in track array
        for row=2:video.num_frames
            if video.track(row,x_col)>=low_x && video.track(row,x_col)<=upp_x && video.track(row,y_col)>=low_y && video.track(row,y_col)<=upp_y
                frames_in_nest=frames_in_nest+1; % if x & y coordinates are within nest bounds add one to frames_in_nest count
            elseif ~isnan(video.track(row,2)) && ~isnan(video.track(row,3))
                frames_out_nest=frames_out_nest+1; % else (if not nan) add one to frames_out_nest count
            end
        end
        time_in_nest=frames_in_nest/video.FPS; % convert frame count to time (s)
        time_out_nest=frames_out_nest/video.FPS;
        video.nest_times(first_col)=time_in_nest; % add value to bodypart location in struct.nest_times
        video.nest_times(first_col+1)=time_out_nest;
        first_col=first_col+2; % update time in nest location for next bodypart
    end
end

% Plot pie charts of time in and out nest for each bodypart
function plot_nest_times(video)
    figure
    tiledlayout('flow') % tiled layout for each bodypart
    first_col=1; % start of first bodypart
    for bp=1:video.num_bodyparts % for each bodypart
        nexttile
        pie(video.nest_times(first_col:first_col+1),{'Inside Nest','Outside Nest'}); % plot pie chart of time in and out of nest (s)
        title([video.animal ' ' video.name_parts(bp)]); % title of video and bodypart
        first_col=first_col+2; % update to start of next bodypart
    end
end        
    
end
