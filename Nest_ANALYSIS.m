% Read in edited filtered tracks
[A1,A2,B1,B2]=read_edited_tracks();

% Calculate times in and out of nest
    % Columns: video, time in nest(s), time out nest(s)
    % Videos: 1=A1,2=A2,3=B1,4=B2
[Nest_times]=nest_time(A1,A2,B1,B2);

% Create pie charts of times 
plot_nest_times(Nest_times);

%% Functions -----------------------------------------------------------

% Read in images
function [A1_image,A2_image,B1_image,B2_image]=read_images()
    A1_image=imread('Deep_Lab_Cut/Still_Images/A1.png');
    A2_image=imread('Deep_Lab_Cut/Still_Images/A2.png');
    B1_image=imread('Deep_Lab_Cut/Still_Images/B1.png');
    B2_image=imread('Deep_Lab_Cut/Still_Images/B2.png');
end

% Calculate time in and out of nest
function [track_in_nest,track_out_nest]=calc_nest_time(track,low_x,upp_x,low_y,upp_y)
    frames_in_nest=0;
    frames_out_nest=0;
    for row=2:(30*900+1) % 30FPS x 900s + 1 due to 0 start
        if track(row,2)>=low_x && track(row,2)<=upp_x && track(row,3)>=low_y && track(row,3)<=upp_y
            frames_in_nest=frames_in_nest+1;
        elseif ~isnan(track(row,2)) || ~isnan(track(row,3))
            frames_out_nest=frames_out_nest+1;
        end
    end
    track_in_nest=frames_in_nest/30;
    track_out_nest=frames_out_nest/30; 
end

function [Nest_Times]=nest_time(A1,A2,B1,B2)
    % Read in a still image for each video (to measure size with less computing)
    [A1_image,~,B1_image,B2_image]=read_images();
    
    % Record the in nest boundaries for each track
    A1_upp_x=size(A1_image,2);
    A1_low_x=A1_upp_x-(365+150)+1;
    A1_upp_y=size(A1_image,1);
    A1_low_y=A1_upp_y-(337+75)+1;
    A2_upp_x=538;
    A2_low_x=0;
    A2_upp_y=412;
    A2_low_y=0;
    B1_upp_x=size(B1_image,2);
    B1_low_x=B1_upp_x-(494+18)+1;
    B1_upp_y=size(B1_image,1);
    B1_low_y=B1_upp_y-(387+16)+1;
    B2_upp_x=size(B2_image,2);
    B2_low_x=B2_upp_x-524+1;
    B2_upp_y=size(B2_image,1);
    B2_low_y=B2_upp_y-(408+88)+1;
    
    % Calculate time in and out of nest for each track
    [A1_in_nest,A1_out_nest]=calc_nest_time(A1,A1_low_x,A1_upp_x,A1_low_y,A1_upp_y);
    [A2_in_nest,A2_out_nest]=calc_nest_time(A2,A2_low_x,A2_upp_x,A2_low_y,A2_upp_y);
    [B1_in_nest,B1_out_nest]=calc_nest_time(B1,B1_low_x,B1_upp_x,B1_low_y,B1_upp_y);
    [B2_in_nest,B2_out_nest]=calc_nest_time(B2,B2_low_x,B2_upp_x,B2_low_y,B2_upp_y);
    
    % Make matrix of in and out nest times
        % Columns: video, time in nest(s), time out nest(s)
        % Videos: 1=A1,2=A2,3=B1,4=B2
    Nest_Times=[1 A1_in_nest A1_out_nest;
        2 A2_in_nest A2_out_nest;
        3 B1_in_nest B1_out_nest;
        4 B2_in_nest B2_out_nest];
end

% Create pie charts of nest times for all videos
function plot_nest_times(Nest_times)
    for row=1:4
        figure
        pie(Nest_times(row,2:3),{'Inside Nest','Outside Nest'});
        if row==1 || row==2
            mouse='A';
            day=row;
        elseif row==3 || row==4
            mouse='B';
            day=row-2;
        end
        title([mouse num2str(day)])
    end
end