
while loop0<=K
for loop2 = 1:loop0
        maxBSdistance(loop0,loop2) = 0;      % Dmax_ij
        for loop2 = 1:length(clusterStruc(loop0).cluster(loop2).BS)
            for loop3 = loop2:length(clusterStruc(loop0).cluster(loop2).BS)
                
                BS1 = clusterStruc(loop0).cluster(loop2).BS(loop2);
                BS2 = clusterStruc(loop0).cluster(loop2).BS(loop3);
                tempDist = simpleDistance (BS_location(BS1,:), BS_location(BS2,:) );
                
                if tempDist>maxBSdistance(loop0,loop2)
                    maxBSdistance(loop0,loop2) = tempDist;
                end
            end
        end
end
    
end