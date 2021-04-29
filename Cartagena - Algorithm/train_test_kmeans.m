rng('default');  % For reproducibility

n_classes = 10

% Reading the dataset
% Data2 = readtable('CartegenaE53-Feb-02-19.csv');
Data2 = readtable('CartagenaE53-May-05-11.csv');

Data = removevars(Data2,{'Var1','SensorId', 'TS'});

DataSetSize = size(Data)

number_of_samples = DataSetSize(1)

% Create Training and test sets
Trainingset_orig = table2array(Data(1:1200,1:DataSetSize(2)))
Testset_orig = table2array(Data(1200+1:number_of_samples,1:DataSetSize(2)))

% Normalizing the Dataset
Data_normalized = normalize (Data);

Trainingset = normalize(Trainingset_orig)
Testset = normalize(Testset_orig)


% Creating the classifier
% https://www.mathworks.com/help/stats/kmeans.html 
%[idx3,C,sumdist3] = kmeans(Trainingset,10,'Distance','cityblock','Display','final','Replicates',50);
[idx3,C,sumdist3] = kmeans(Trainingset,n_classes,'Distance','sqeuclidean','Display','final','Replicates',50);

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



%usando subltot abaixo

%subplot(3,1,1);

gscatter (Testset_orig(:,2),Testset_orig(:,1),idx_test, colors)
xlabel('Temperature (Centigrades)')
ylabel('Soil Mosture (%)')
set(gca,'FontSize',14)
title ('High Sensor')
legend(gca,'off');

pause
%subplot(3,1,2);

gscatter (Testset_orig(:,4),Testset_orig(:,3),idx_test, colors)
xlabel('Temperature (Centigrades)')
ylabel('Soil Mosture (%)')
set(gca,'FontSize',14)
title ('Middle Sensor')
legend(gca,'off');

pause
%subplot(3,1,3);

gscatter (Testset_orig(:,6),Testset_orig(:,5),idx_test, colors)
xlabel('Temperature (Centigrades)')
ylabel('Soil Mosture (%)')
set(gca,'FontSize',14)
title ('Low Sensor')
legend(gca,'off');