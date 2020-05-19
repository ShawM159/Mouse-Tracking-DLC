%% Group plots
% --> takes input of multiple video structure array (e.g. v or v(3:6)) and
% animals array from video_parameters marking each new mouse ({'A' 'B'})
% --> returns grouped plots subplotted by mouse
    % --> Plots:
        % --> cumulative distance(m) against time(s) for all videos
        % --> cumulative distance(m) against time(s) for all videos for 
        % each mouse
        % --> spiderplots of mean speed(m/s) in each direction(E,NE,N etc.)
        % for all videos for each mouse

function group_plots(all_videos,animals)

plot_cumdist_all(all_videos); % cumulative distance against time for all videos

plot_cumdist_animal(all_videos,animals); % cumulative distance against time for all videos for each mouse

plot_dir_speed_animal(all_videos,animals); % mean speed in each direction for all videos for each mouse

%% Functions ----------------------------------------------------
% Plot all cumulative distances on one graph
function plot_cumdist_all(all_videos)
    % Create blank legend_labels array of full size
    N=0; % length of legend_labels
    for i=size(all_videos,2)
        for bp=1:all_videos(i).num_bodyparts
            N=N+1; % add one for each line
        end
    end
    legend_labels=cell(N,1); % create empty array of correct size
    % Plot group cumulative distance plot
    figure
    line=1; % first line location for legend_labels
    for i=1:size(all_videos,2) % for each video
        cumdist_col=6; % first bodypart column of cumulative distance in movement array
        for bp=1:all_videos(i).num_bodyparts % for each bodypart
            plot(all_videos(i).movement(:,2),all_videos(i).movement(:,cumdist_col),'LineWidth',2); % plot cumulative distance against time
            xlabel('Time (s)')
            ylabel('Cumulative Distance (m)')
            name=strcat(all_videos(i).animal,'-',num2str(bp)); % legend label is video name and index of bodypart
            legend_labels{line}=name; % replace empty legend_label cell with new label
            hold on % hold on for next lines to be added
            cumdist_col=cumdist_col+4; % update cumulative distance column for next bodypart
            line=line+1; % update line to next location for legend_labels
        end
    end
    hold off 
    legend(legend_labels,'location','southeast'); % add legends
end


% Plot cumulative distances for all videos of each mouse in separate
% subplot
function plot_cumdist_animal(all_videos,animals)
    % Create blank legend_labels array for each animal
    for a=1:size(animals,2) % for each animal
        N=0; % length of legend label array
        for i=size(all_videos,2) % for each video
            if isequal(all_videos(i).animal,animals{a}) % if video matches animal in question
                for bp=1:all_videos(i).num_bodyparts % for each bodypart
                    N=N+1; % add one to length of legend array
                end
            end
        end
        lgd(a).labels=cell(N,1); % structure array for legend labels to keep each animal separate
    end
    % Plot cumulative distance plots for each animal
    figure
    for a=1:size(animals,2) % for each animal
        lgd(a).line=1; % start position on animal's legend label array
        for i=1:size(all_videos,2) % for each video
            if isequal(all_videos(i).animal(1),animals{a}) % if video matches animal in question
                subplot(1,size(animals,2),a) % in subplot for animal in question
                cumdist_col=6; % first bodypart column of cumulative distance
                for bp=1:all_videos(i).num_bodyparts % for each bodypart
                    plot(all_videos(i).movement(:,2),all_videos(i).movement(:,cumdist_col),'LineWidth',2); % plot cumulative distance against time
                    xlabel('Time (s)')
                    ylabel('Cumulative Distance (m)')
                    name=strcat(all_videos(i).animal,'-',num2str(bp)); % legend label is name of video and index of bodypart
                    lgd(a).labels{lgd(a).line}=name; % replace position on animal's legend label array with new label
                    hold on % hold on subplot for future videos/bodyparts
                    cumdist_col=cumdist_col+4; % update cumulative distance column for next bodypart
                    lgd(a).line=lgd(a).line+1; % update line for next legend label position
                end
            end
        end
    end
    % Add legends
    for a=1:size(animals,2) % for each animal
        subplot(1,size(animals,2),a) % subplot for animal
        hold off % hold off subplot
        legend(lgd(a).labels,'location','southeast'); % add animal's legend labels
    end
end

% Plot spider plots of mean directional speed for all videos of each animal
function plot_dir_speed_animal(all_videos,animals)
    % Create blank legend_labels array for each animal
    for a=1:size(animals,2) % for each animal
        N=0; % length of legend label array
        for i=size(all_videos,2) % for each video
            if isequal(all_videos(i).animal,animals{a}) % if video matches animal in question
                for bp=1:all_videos(i).num_bodyparts % for each bodypart
                    N=N+1; % add one to length of legend label array
                end
            end
        end 
        lgd(a).labels=cell(N,1); % create empty array of legend labels for that animal of the correct size
    end
    % Plot spiderplots of mean directional speed for each animal
    figure
    for a=1:size(animals,2) % for each animal
        lgd(a).line=1; % first position of legend label array for that animal
        lgd(a).mouse=[]; % empty array for speed values for the spiderplot
        for i=1:size(all_videos,2) % for each video
            if isequal(all_videos(i).animal(1),animals{a}) % if the video matches the animal in question
                subplot(1,size(animals,2),a) % suplot for that animal
                first_col=1; % first speed_dir column of first bodypart
                for bp=1:all_videos(i).num_bodyparts % for each bodypart
                    last_col=first_col+7; % last column of bodypart in speed_dir array
                    lgd(a).mouse=[lgd(a).mouse;all_videos(i).dir_speeds(first_col:last_col)*100]; % add directional mean speeds in cm/s (*100) for bodypart to mouse array
                    max_s=ceil(max(max(lgd(a).mouse))); % round up max mean speed value to nearest whole number for upper plot limit
                    spider_plot_R2019b(lgd(a).mouse,... % plot spiderplot of mean speeds
                    'AxesLabels',{'E','NE','N','NW','W','SW','S','SE'},... % axis labels
                    'AxesLimits',[0 0 0 0 0 0 0 0;max_s max_s max_s max_s max_s max_s max_s max_s],... % axis limits
                    'Direction','counterclockwise'); % fill counterclockwise from 0deg east
                    name=strcat(all_videos(i).animal,'-',num2str(bp)); % legend label is name of video with index of bodypart
                    lgd(a).labels{lgd(a).line}=name; % replace legend position with new label
                    hold on % hold on for future bodyparts/videos
                    first_col=first_col+8; % update column in speed_dirs to start of next bodypart
                    lgd(a).line=lgd(a).line+1; % update legend label position for next line
                end
            end
        end
    end
    % Add legends
    for a=1:size(animals,2) % for each animal
        subplot(1,size(animals,2),a) % subplot for that animal
        hold off % hold off that subplot
        legend(lgd(a).labels,'location','southoutside'); % add legend labels for that animal/subplot
    end
end

end