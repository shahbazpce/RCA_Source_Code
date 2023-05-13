function [centroidPoints,bestClusterNo,bestClusterInterationNo] = bestClusterSearchFunc(clusterInfo)
%BESTCLUSTERSEARCHFUNC Summary of this function goes here
%   it takes cluster information and provides the best cluster among the
%   given set of cluster along with the co-ordinates of centoid of selected
%   cluster
K = size(clusterInfo,2);
for loop0 = 1:K
    tempMinDistance(loop0) = clusterInfo(loop0).minDistance;
end
[~,bestClusterNo] = min(tempMinDistance);  %% finding the best number of cluster
bestClusterInterationNo = clusterInfo(bestClusterNo).indexMinDistance; % finding the iteration number of best cluster obtained
%% finding points for creating second stage remote nodes
for loop0 = 1: bestClusterNo
    centroidPoints(loop0,:) = clusterInfo(bestClusterNo).iterationNo(bestClusterInterationNo).cluster(loop0).centroid;
    centroidToOnuDistance(loop0,1) = clusterInfo(bestClusterNo).iterationNo(bestClusterInterationNo).cluster(loop0).centroidToPointDis;
end
end

