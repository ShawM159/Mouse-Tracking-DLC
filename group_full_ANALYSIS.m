%% Group Full Analysis
% --> script to run full analysis on all video data included in
% video_parameters structure array
% --> runs full analysis for each video individually with user feedback for
% each video on whether plots should be included for that video
    % --> returns video_parameters (v(i)) array with movement,
    % nest_times and xy_distance (see full_ANALYSIS for details)
% --> additional prompt for the inclusion of group plots where the data from
% all videos for each mouse are plotted on the same graphs for direct
% comparison (see group_plots for details)

video_parameters % read in video structure array

for i=1:size(v,2)
    [v(i)]=full_ANALYSIS(v(i)); % run full_ANALYSIS for each video in the array
end

prompt=['Would you like to plot group results? (y/n)']; % ask user if group plots should be included
if input(prompt,'s')=='y'
    group_plots(v,animals); % plots grouped plots of multiple videos per mouse
end

clear i