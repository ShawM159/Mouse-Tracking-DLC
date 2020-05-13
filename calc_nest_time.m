%% Calculate time in and out of nest

function [struct]=calc_nest_time(struct)
    image=imread(struct.imagepath);
    low_x=struct.nest_bounds(1);
    upp_x=size(image,2)-struct.nest_bounds(2);
    low_y=struct.nest_bounds(3);
    upp_y=size(image,1)-struct.nest_bounds(4);
    frames_in_nest=0;
    frames_out_nest=0;
    for row=2:struct.num_frames
        if struct.track(row,2)>=low_x && struct.track(row,2)<=upp_x && struct.track(row,3)>=low_y && struct.track(row,3)<=upp_y
            frames_in_nest=frames_in_nest+1;
        elseif ~isnan(struct.track(row,2)) && ~isnan(struct.track(row,3))
            frames_out_nest=frames_out_nest+1;
        end
    end
    time_in_nest=frames_in_nest/struct.FPS;
    time_out_nest=frames_out_nest/struct.FPS; 
    struct.nest_times=[time_in_nest time_out_nest];
    pie(struct.nest_times,{'Inside Nest','Outside Nest'});
    title(struct.animal);
end
