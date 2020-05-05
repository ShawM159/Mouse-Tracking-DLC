%% addpath(genpath('/Users/u1984428/Documents/Training Year/Leicester Project/MATLAB Scripts/'))

%% Read in filtered edited tracks

% Read in filtered edited tracks
    % Columns: frame, xcoord, ycoord, likelihood
function [A1,A2,B1,B2]=read_edited_tracks()
    A1=readmatrix('Tracking Results/A1_edited.csv');
    A2=readmatrix('Tracking Results/A2_edited.csv');
    B1=readmatrix('Tracking Results/B1_edited.csv');
    B2=readmatrix('Tracking Results/B2_edited.csv');
end
