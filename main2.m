%% This is another implemenation of kmeans using built in function kmeans(x,k).
% here the selection of random centroid is based on kmeans++
% last date modified: 23/04/2020
%% Clear Memory & Command Window
clc
clear all
close all
%% Generate Points
%load('N_56_OLT_ONU_Only_10km_Side', 'points','olt_points');
load('N_225_10KM','point1');
%  onuPoints= region(1).point;
% tempPoints = region(1).point;
% for i = 1:200
%     tempPoints(200+i,:) = region(2).point(i,:);
% end
% for i = 1:100
%     tempPoints(400+i,:) = region(3).point(i,:);
% end
% p = 200;
% x = randperm(500,p);
% onuPoints = tempPoints(x,:);
% olt_points = [center center];
onuPoints = point1;
olt_points =[10,10];
K     = 50;                                            % Cluster Numbers    
CV    = '+r+b+c+m+k+yorobocomokoysrsbscsmsksy';       % Color Vector
%% K-means
iterationForObservation = 80;
%% Sigle stage
[clusterInfo_SingleStage]= ClusterFormationFunc(onuPoints,olt_points,K,iterationForObservation);
[RN2Points,bestClusterNo_SingleStage,bestIterationNo_SingleStage] = bestClusterSearchFunc(clusterInfo_SingleStage);
oltTOAllPointDist_SingleStage = clusterInfo_SingleStage(bestClusterNo_SingleStage).minDistance;
centToAllPointDist_SingleStage = clusterInfo_SingleStage(bestClusterNo_SingleStage).iterationNo(bestIterationNo_SingleStage).centToOnuDis;
fprintf("Number of RN2 Points = %d\n", bestClusterNo_SingleStage);
fprintf("Total distance olt to ONU for single stage structure = %4.4f\n", oltTOAllPointDist_SingleStage);
%% Two or second Stage
[clusterInfo_TwoStage]= ClusterFormationFunc(RN2Points,olt_points,size(RN2Points,1),iterationForObservation);
[RN1Points,bestClusterNo_TwoStage,bestIterationNo_TwoStage] = bestClusterSearchFunc(clusterInfo_TwoStage);
oltTOAllPointDist_TwoStage = clusterInfo_TwoStage(bestClusterNo_TwoStage).minDistance + centToAllPointDist_SingleStage ;
fprintf("Number of RN1 Points = %d\n", bestClusterNo_TwoStage);
fprintf("Total distance olt to ONU for Two stage structure = %4.4f\n", oltTOAllPointDist_TwoStage);


   
%% Plot   
% clf
% figure(1)
% hold on

%  for i = 1:bestClusterNo_SingleStage
% points = clusterInfo_SingleStage(bestClusterNo_SingleStage).iterationNo(bestIterationNo_SingleStage)...
% .cluster(i).cordinates;                            % Find points of each cluster  
% centroid_SingleStage = clusterInfo_SingleStage(bestClusterNo_SingleStage).iterationNo(bestIterationNo_SingleStage)...
% .cluster(i).centroid;
% plot(points(:,1),points(:,2),CV(2*i-1:2*i),'LineWidth',2);    % Plot points with determined color and shape
% scatter(centroid_SingleStage(:,1),centroid_SingleStage(:,2),'filled','b','MarkerFaceColor',[0 0 0.5])
% %plot(centroid_SingleStage(:,1),centroid_SingleStage(:,2),CV(2*i-1:2*i),'LineWidth',2);    % Plot points with determined color and shape
% %plot(CENTS(:,1),CENTS(:,2),'*k','LineWidth',7);       % Plot cluster centers
%  end
% %  for i = 1:bestClusterNo_TwoStage
% % centroid_TwoStage = clusterInfo_TwoStage(bestClusterNo_TwoStage).iterationNo(bestIterationNo_TwoStage).cluster(i).centroid;  
% % scatter(centroid_TwoStage(:,1),centroid_TwoStage(:,2),'filled','s','MarkerFaceColor',[0 0 0.5])
% % end
% hold off
% grid on
% pause(0.1)