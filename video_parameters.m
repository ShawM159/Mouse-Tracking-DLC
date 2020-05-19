% Structure arrays for each video
i=0;

% Video 1
i=i+1;
v(i).animal='A1 iter0'; % video identification: A=mouse, 1=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200326/iter=0/A_WIN_20200326_18_15_04_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/A1_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=159; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/A1.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[78,150,53,75]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[766,0,309,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 2
i=i+1;
v(i).animal='A2 iter0';  % video identification: A=mouse, 2=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200327/iter=0/A_WIN_20200327_18_20_59_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/A2_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=169; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/A2.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30;  % frames per second
v(i).cage_bounds=[0,0,0,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[0,742,0,308]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 3
i=i+1;
v(i).animal='B1 iter0'; % video identification: B=mouse, 1=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200327/iter=0/B_WIN_20200327_13_40_18_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/B1_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan');  % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=211; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/B1.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[0,18,0,16]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[769,0,303,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 4
i=i+1;
v(i).animal='B2 iter0'; % video identification: B=mouse, 2=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200328/iter=0/B_WIN_20200328_19_27_06_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/B2_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=251; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/B2.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[0,0,0,88]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[757,0,220,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 5
i=i+1;
v(i).animal='A1 iter1'; % video identification: A=mouse, 1=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200326/iter=1/A_WIN_20200326_18_15_04_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/A1_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=159; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/A1.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[78,150,53,75]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[766,0,309,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 6
i=i+1;
v(i).animal='A2 iter1';  % video identification: A=mouse, 2=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_A_BD/A_WIN_20200327/iter=1/A_WIN_20200327_18_20_59_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/A2_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=169; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/A2.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30;  % frames per second
v(i).cage_bounds=[0,0,0,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[0,742,0,308]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 7
i=i+1;
v(i).animal='B1 iter1'; % video identification: B=mouse, 1=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200327/iter=1/B_WIN_20200327_13_40_18_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/B1_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan');  % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=211; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/B1.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[0,18,0,16]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[769,0,303,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 8
i=i+1;
v(i).animal='B2 iter1'; % video identification: B=mouse, 2=day
v(i).num_bodyparts=1; % number of tracked bodyparts
v(i).name_parts='headbase'; % name of tracked bodyparts
v(i).basefilepath='Deep_Lab_Cut/Orig_Videos/MD200312_B_BD/B_WIN_20200328/iter=1/B_WIN_20200328_19_27_06_ProDLC_resnet50_Full_TrackingApr17shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/B2_edited.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=251; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/B2.png'; % path to still image
v(i).num_frames=27001; % start position + 15 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[0,0,0,88]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[757,0,220,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[]; % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 9
i=i+1;
v(i).animal='B1 0to5min iter=0'; % video identification: B=mouse, 1=day
v(i).num_bodyparts=3; % number of tracked bodyparts
v(i).name_parts={'R ear','L ear','C back'}; % name of tracked bodyparts, MUST be in the SAME order as deeplabcut tracking
v(i).basefilepath='Deep_Lab_Cut/Short_Videos/Analysed video iter=0/B1_0to5minDLC_resnet50_Ear_TrackingMay11shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/B1_0to5min_edited_iter0.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=211; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/B1.png'; % path to still image
v(i).num_frames=9001; % start position + 5 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[0,18,0,16]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[769,0,303,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[];  % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];

% Video 10
i=i+1;
v(i).animal='B1 0to5min iter=1'; % video identification: B=mouse, 1=day
v(i).num_bodyparts=3;  % number of tracked bodyparts
v(i).name_parts={'R ear','L ear','C back'}; % name of tracked bodyparts, MUST be in the SAME order as deeplabcut tracking
v(i).basefilepath='Deep_Lab_Cut/Short_Videos/Analysed video iter=1/B1_0to5minDLC_resnet50_Ear_TrackingMay11shuffle1_2400filtered.csv'; % path to original video data
%v(i).trackpath='Tracking Results/B1_0to5min_edited_iter1.csv'; % path to edited coordinate track
v(i).track=medfilt1(readmatrix(v(i).basefilepath),'omitnan'); % filtered coordinate track from deeplabcut
v(i).actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
v(i).coord_length=211; % Approx mouse coordinate length from nose to tailbase
v(i).conv_factor=v(i).actual_length/v(i).coord_length; % approx coordinate distance in metres
v(i).imagepath='Deep_Lab_Cut/Still_Images/B1.png'; % path to still image
v(i).num_frames=27001; % start position + 5 mins at 30FPS
v(i).FPS=30; % frames per second
v(i).cage_bounds=[0,18,0,16]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).nest_bounds=[769,0,303,0]; % [low_x,upp_x,low_y,upp_y], upp_x/y is to be taken away from x/y image size
v(i).movement=[];  % empty arrays for data analysis
v(i).dir_speeds=[];
v(i).nest_times=[];
v(i).xy_distance=[];



% Number of animals
animals={'A' 'B'};

% Clear i
clear i
