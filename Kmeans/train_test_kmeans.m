rng('default');  % For reproducibility

% Reading the dataset
Data = readtable('../DATASETS/Soria_T_H.csv');
DataSetSize = size(Data)

number_of_samples = DataSetSize(1)

% Create Training and test sets
Trainingset_orig = table2array(Data(1:number_of_samples/2,1:2))
Testset_orig = table2array(Data(fix(number_of_samples/2)+1:number_of_samples,1:2))

% Normalizing the Dataset
Data_normalized = normalize (Data);

Trainingset = normalize(Trainingset_orig)
Testset = normalize(Testset_orig)


% Creating the classifier
% https://www.mathworks.com/help/stats/kmeans.html 
%[idx3,C,sumdist3] = kmeans(Trainingset,10,'Distance','cityblock','Display','final','Replicates',50);
[idx3,C,sumdist3] = kmeans(Trainingset,5,'Distance','sqeuclidean','Display','final','Replicates',50);

%vhttps://www.mathworks.com/help/stats/silhouette.html
 
% Creating Silhouette Graph
%[silh3,h] = silhouette(Trainingset,idx3,'cityblock');
% [silh3,h] = silhouette(Trainingset,idx3,'sqeuclidean');
% xlabel('Silhouette Value')
% ylabel('Cluster')
% set(gca,'FontSize',14)
% 
% 
% pause
%  
% gscatter (Trainingset_orig(:,1),Trainingset_orig(:,2),idx3)
% xlabel('Temperature (Centigrades)')
% ylabel('Humidity (%)')
% set(gca,'FontSize',14)

% Computing the class for the test dataset
[~,idx_test] = pdist2(C,Testset,'euclidean','Smallest',1);

writematrix([Testset_orig, idx_test'],'Output.csv') 

colors = [[1,0,0],
[0,0.9,0],
[0,0,1],
[1,0.8,0],
[1,0,1],
[0,0.9,0.9],
[1,0.5,0],
[0,0.5,1],
[1,0,0.5],
[0.5,0.5,0],
[1,0,1],
[0.2,0,1],
[1,0.5,0],
[0.5,0,1],
[1,0,1],
[0.5,0,0.5],
[1,0,0],
[0.7,0.7,0],
[0,1,0],
[1,0,1],
]

gscatter (Testset_orig(:,1),Testset_orig(:,2),idx_test, colors)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',16)
title ('K-means (5 classes)')
legend(gca,'off');