%% addpath(genpath('/Users/u1984428/Documents/Training Year/Leicester Project/MATLAB Scripts/'))

%% Exclude data points from outside of cage - specific to each video

% Read in the filtered tracks into matrices
    % Columns: frame, xcoord, ycoord, likelihood
[A1_filtered,A2_filtered,B1_filtered,B2_filtered]=read_filtered_tracks();

% Read in a still image for each video (to measure size with less computing)
[A1_image,A2_image,B1_image,B2_image]=read_images();

% Plot unedited filtered data
plot_trajectory(A1_filtered,'A1F');
plot_trajectory(A2_filtered,'A2F');
plot_trajectory(B1_filtered,'B1F');
plot_trajectory(B2_filtered,'B2F');

% Exclude recorded coordinates outside of the cage limits
    % Video A1
        % exclude x coord below 78 or above end-150
        % y coord below 53 or above end-75
[A1_filtered]=exclude_environ(A1_filtered,A1_image,78,150,53,75);
    % Video A2
        % full screen video so no exclusions
[A2_filtered]=exclude_environ(A2_filtered,A2_image,0,0,0,0);
    % Video B1
        % x coord above end-18
        % y coord above end-16
[B1_filtered]=exclude_environ(B1_filtered,B1_image,0,18,0,16);
    % Video B2
        % y coord above end-88
[B2_filtered]=exclude_environ(B2_filtered,B2_image,0,0,0,88);

% Count exclusions in each track
count_exclusions(A1_filtered) % --> 8
count_exclusions(A2_filtered) % --> 0
count_exclusions(B1_filtered) % --> 3
count_exclusions(B2_filtered) % --> 38

% Plot edited filtered data
plot_trajectory(A1_filtered,'A1F Edit');
plot_trajectory(A2_filtered,'A2F Edit');
plot_trajectory(B1_filtered,'B1F Edit');
plot_trajectory(B2_filtered,'B2F Edit');

% Save new tracks
%writematrix(A1_filtered,'Tracking Results/A1_edited.csv');
%writematrix(A2_filtered,'Tracking Results/A2_edited.csv');
%writematrix(B1_filtered,'Tracking Results/B1_edited.csv');
%writematrix(B2_filtered,'Tracking Results/B2_edited.csv');

%% Functions -----------------------------------------------------------

% Read in filtered tracks

function [A1_filtered,A2_filtered,B1_filtered,B2_filtered]=read_filtered_tracks()
    A1_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200326/A_WIN_20200326_18_15_04_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
    A2_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200327/A_WIN_20200327_18_20_59_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
    B1_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200327/B_WIN_20200327_13_40_18_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
    B2_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200328/B_WIN_20200328_19_27_06_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
end

% Read in images

function [A1_image,A2_image,B1_image,B2_image]=read_images()
    A1_image=imread('Deep_Lab_Cut/Still_Images/A1.png');
    A2_image=imread('Deep_Lab_Cut/Still_Images/A2.png');
    B1_image=imread('Deep_Lab_Cut/Still_Images/B1.png');
    B2_image=imread('Deep_Lab_Cut/Still_Images/B2.png');
end

% Exclude any points outside of cage

function [track]=exclude_environ(track,image,low_x,upp_x,low_y,upp_y)
    max_x=size(image,2)-upp_x+1;
    max_y=size(image,1)-upp_y+1;
    track(track(:,2)<=low_x,2:3)=NaN;
    track(track(:,2)>=max_x,2:3)=NaN;
    track(track(:,3)<=low_y,2:3)=NaN;
    track(track(:,3)>=max_y,2:3)=NaN;
end

% Count exclusions
function count_exclusions(track)
    count=0;
    for row=1:size(track,1)
        if isnan(track(row,2))
        count=count+1;
        end
    end
    result=['Num of exclusions: ',num2str(count)];
    disp(result)
end

% Plot trajectory

function plot_trajectory(track,plot_title)
    figure
    scatter(track(:,2),track(:,3))
    set(gca, 'YDir','reverse')
    title(plot_title)
end
