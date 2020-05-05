%% addpath(genpath('/Users/u1984428/Documents/Training Year/Leicester Project/MATLAB Scripts/'))

%% Find Number of Frames per Second

% Read in unedited tracks
%[A1_filtered,A2_filtered,B1_filtered,B2_filtered]=read_filtered_tracks();
%short=readmatrix('Deep_Lab_Cut/PRACTICE/Mouse_A_26-MS-2020-04-14/videos/SHORT_WIN_20200326_18_15_04_ProDLC_resnet50_Mouse_A_26Apr14shuffle1_2000filtered.csv');

% Length of each video:
    % A1 --> 15:03
    % A2 --> 15:01
    % B1 --> 15:00
    % B2 --> 15:01
    % short --> 5:01
    
find_FPS(A1_filtered,15,3); % --> 30.0078
find_FPS(A2_filtered,15,1); % --> 30.0022
find_FPS(B1_filtered,15,0); % --> 30.0122
find_FPS(B2_filtered,15,1); % --> 29.99
find_FPS(short,5,1);        % --> 30.01     % Approx 30 FPS %

%% Functions -------------------------------------------------------

% Read in unedited filtered tracks

function [A1_filtered,A2_filtered,B1_filtered,B2_filtered]=read_filtered_tracks()
    A1_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200326/A_WIN_20200326_18_15_04_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
    A2_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200327/A_WIN_20200327_18_20_59_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
    B1_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200327/B_WIN_20200327_13_40_18_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
    B2_filtered=readmatrix('Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200328/B_WIN_20200328_19_27_06_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv');
end

function find_FPS(track,track_mins,track_seconds)
    numframes=size(track,1)-1;
    tot_seconds=(track_mins*60)+track_seconds;
    approxFPS=numframes/tot_seconds;
    result=['approxFPS: ' num2str(approxFPS)];
    disp(result)
end
