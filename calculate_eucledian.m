function [Euclean] = calculate_eucledian(onu_loaction_detail);
total_points = length(onu_location_detail);

manhattan=zeros(total_points);
for loop1 = 1 : total_points
    for loop2 = 1 : total_points
        if loop2~=loop1
            manhattan(loop1,loop2)= sqrt((onu_location_detail(loop1,1) - onu_location_detail(loop2,1))...
               + (onu_location_detail(loop1,2) - onu_location_detail(loop2,2)));
        end
    end
end