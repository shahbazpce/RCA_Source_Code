function [clusterInfo] = ClusterFormationFunc(points,oltPoints,maxClusterNo,maxIterationNo)
%CLUSTERFORMATIONFUNC Summary of this function goes here
%   Detailed explanation goes here

F = points;
olt_points = oltPoints;
K = maxClusterNo;                                            % Cluster Numbers    
%% K-means
iterationForObservation = maxIterationNo;
loop0=1;
while loop0<=K
    for loop1 = 1 : iterationForObservation
DAL   = zeros(size(F,1),loop0+2); 
[DAL(:,loop0+1), CENTS, sumd, DAL(:,1:loop0) ] = kmeans(F,loop0);
for i = 1:size(F,1)
      [Distance,~] = min(DAL(i,1:loop0));                % 1:K are Distance from Cluster Centers 1:K                              % K+1 is Cluster Label
      DAL(i,loop0+2) = Distance;                          % K+2 is Minimum Distance
end


%% Making cluster structure to store cluster detail
clusterInfo(loop0).iterationNo(loop1).cluster(loop0) = struct('points',[],...
    'cordinates',[],'centroid',[],'centroidToPointDis',[],'oltToCentDis',[],...
    'oltToOnuDis',[],'maxOnuToOnuDis',[]);
for loop2 = 1:loop0
    clusterInfo(loop0).iterationNo(loop1).cluster(loop2).points = find(DAL(:,loop0+1) == loop2);
    clusterInfo(loop0).iterationNo(loop1).cluster(loop2).cordinates = F(DAL(:,loop0+1) == loop2,:); 
    clusterInfo(loop0).iterationNo(loop1).cluster(loop2).centroid = CENTS(loop2,:);  
    [length,~] = size(clusterInfo(loop0).iterationNo(loop1).cluster(loop2).cordinates);
    sumTemp = zeros(1,length);
    for loop3 = 1:length
      sumTemp(1,loop3) =  norm(clusterInfo(loop0).iterationNo(loop1).cluster(loop2).centroid...
           - clusterInfo(loop0).iterationNo(loop1).cluster(loop2).cordinates(loop3,:));
       clusterInfo(loop0).iterationNo(loop1).cluster(loop2).oltToCentDis = ...
           norm(clusterInfo(loop0).iterationNo(loop1).cluster(loop2).centroid...
           - olt_points);
    end
     clusterInfo(loop0).iterationNo(loop1).cluster(loop2).centroidToPointDis = sum(sumTemp);
     for loop3 = 1:length
      clusterInfo(loop0).iterationNo(loop1).cluster(loop2).oltToOnuDis = ...
          clusterInfo(loop0).iterationNo(loop1).cluster(loop2).centroidToPointDis +...
          clusterInfo(loop0).iterationNo(loop1).cluster(loop2).oltToCentDis;
    end
end


%% finding maximum distance btw two onus in a cluster
     for loop2 = 1:loop0
       maxBSdistance = 0;      % Dmax_ij
        for loop3 = 1:size(clusterInfo(loop0).iterationNo(loop1).cluster(loop2).points,1)
            for loop4 = loop3:size(clusterInfo(loop0).iterationNo(loop1).cluster(loop2).points,1)
                
                BS1 = clusterInfo(loop0).iterationNo(loop1).cluster(loop2).points(loop3);
                BS2 = clusterInfo(loop0).iterationNo(loop1).cluster(loop2).points(loop4);
                tempDist = norm(points(BS1,:)- points(BS2,:));
                
                if tempDist>maxBSdistance
                    maxBSdistance = tempDist;
                end
            end
        end
        clusterInfo(loop0).iterationNo(loop1).cluster(loop2).maxOnuToOnuDis = maxBSdistance;
        
     end
     %% More detail values
tempCentToOnuDis = zeros(1,loop0);
tempOltToOnuDis =  zeros(1,loop0);
tempMeanOnuToOnuMaxDis =  zeros(1,loop0);
for loop2 = 1:loop0
    tempCentToOnuDis(1,loop2) = clusterInfo(loop0).iterationNo(loop1).cluster(loop2).centroidToPointDis;
    tempOltToOnuDis(1,loop2) = clusterInfo(loop0).iterationNo(loop1).cluster(loop2).oltToOnuDis;
    tempMeanOnuToOnuMaxDis(1,loop2) = clusterInfo(loop0).iterationNo(loop1).cluster(loop2).maxOnuToOnuDis;
end
totalSum(1,loop1) = sum(tempCentToOnuDis);
clusterInfo(loop0).iterationNo(loop1).centToOnuDis = sum(tempCentToOnuDis);
clusterInfo(loop0).iterationNo(loop1).oltToOnuDis = sum(tempOltToOnuDis);
clusterInfo(loop0).iterationNo(loop1).meanOnuToOnuMaxDis = mean(tempMeanOnuToOnuMaxDis);
    end
    
 
loop0=loop0+1;
end
%% Chosing optimum structure
for loop3 = 1 : K
   
    for loop4 = 1:iterationForObservation
        tempDis(loop4,1) = clusterInfo(loop3).iterationNo(loop4).oltToOnuDis;
    end
    
     [clusterInfo(loop3).minDistance,clusterInfo(loop3).indexMinDistance] = min(tempDis,[],1);
       clusterInfo(loop3).maxOnuToOnuDis=...
     clusterInfo(loop3).iterationNo(clusterInfo(loop3).indexMinDistance).meanOnuToOnuMaxDis;
     
end

%% Finding the best value of K
for loop0 = 1:K
avgOfMaxDist(loop0) =  clusterInfo(loop0).maxOnuToOnuDis;
end
%avgOfMaxDist = [0 avgOfMaxDist];

kOptimal=-1; KfuncValue=-inf;
for loop0 = 2:K-1
     tempKfuncValue = abs(avgOfMaxDist(loop0-1) - avgOfMaxDist(loop0) ) /...
        abs(avgOfMaxDist(loop0+1) - avgOfMaxDist(loop0));
    kValueArray(loop0) = tempKfuncValue;
end
[value,kIndex] = max(kValueArray);
 %fprintf("Number of Cluster K = %d\n", kIndex);
 
 %% Finding the best cluster that provides the minimum total distance
 
for loop0 = 1:K
    tempMinDistance(loop0) = clusterInfo(loop0).minDistance;
end
[~,bestClusterNo] = min(tempMinDistance);  %% finding the best number of cluster
bestClusterInterationNo = clusterInfo(bestClusterNo).indexMinDistance; % finding the iteration number of best cluster obtained


