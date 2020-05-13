%% Exclude data points from outside of cage

function exclude_data(struct)
% Read in unedited filtered track and still image
basefile=readmatrix(struct.basefilepath);
image=imread(struct.imagepath);

% Plot unedited trajectory
plot_trajectory(basefile,struct.animal);

% Exclude recorded coordinates outside of the cage limits
[track]=exclude_environ(basefile,image,struct.cage_bounds);

% Count the number ofexclusions made and add to struct
count_exclusions(track);

% Plot edited trajectory
plot_trajectory(track,[struct.animal ' Edit']);

% Save new tracks
writematrix(track,struct.trackpath);


%% Functions ----------------------------------------------------------

% Exclude any points outside of cage
    % struct.cage_bounds=[low_x,upp_x,low_y,upp_y]
function [basefile]=exclude_environ(basefile,image,cage_bounds)
    max_x=size(image,2)-cage_bounds(2)+1;
    max_y=size(image,1)-cage_bounds(4)+1;
    basefile(basefile(:,2)<=cage_bounds(1),2:3)=NaN;
    basefile(basefile(:,2)>=max_x,2:3)=NaN;
    basefile(basefile(:,3)<=cage_bounds(3),2:3)=NaN;
    basefile(basefile(:,3)>=max_y,2:3)=NaN;
end

% Count exclusions
function count_exclusions(edited_file)
    count=0;
    for row=1:size(edited_file,1)
        if isnan(edited_file(row,2))
        count=count+1;
        end
    end
    result=['Num of exclusions: ',num2str(count)];
    disp(result)
end

% Plot trajectory
function plot_trajectory(file,plot_title)
    figure
    scatter(file(:,2),file(:,3))
    set(gca, 'YDir','reverse')
    title(plot_title)
end

end