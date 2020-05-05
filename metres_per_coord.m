%% %% addpath(genpath('/Users/u1984428/Documents/Training Year/Leicester Project/MATLAB Scripts/'))

%% Number of coords per metre
function [A1_mpcoord,A2_mpcoord,B1_mpcoord,B2_mpcoord]=metres_per_coord()
    actual_length=0.085; % Approx real mouse length (m) from nose to tailbase
    A1_coord_length=159; % Approx A1 mouse coord length
    A2_coord_length=169; % Approx A2 mouse coord length
    B1_coord_length=211; % Approx B1 mouse coord length
    B2_coord_length=251; % Approx B2 mouse coord length
    A1_mpcoord=actual_length/A1_coord_length;
    A2_mpcoord=actual_length/A2_coord_length;
    B1_mpcoord=actual_length/B1_coord_length;
    B2_mpcoord=actual_length/B2_coord_length;
end