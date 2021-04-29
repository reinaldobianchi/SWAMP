rng('default');  % For reproducibility

% Reading the dataset
Data = readtable('../DATASETS/Soria_T_H.csv');
DataSetSize = size(Data);

number_of_samples = DataSetSize(1)

% Create Training and test sets
Trainingset_orig = table2array(Data(1:number_of_samples/2,1:2));
Testset_orig = table2array(Data(fix(number_of_samples/2)+1:number_of_samples,1:2));

% Normalizing the Dataset
Data_normalized = normalize (Data);

Trainingset = normalize(Trainingset_orig);
Testset = normalize(Testset_orig);

% HIERARCHICAL TREE
% https://www.mathworks.com/help/stats/clusterdata.html

% model = linkage(Trainingset, 'average','chebychev');
% idx = cluster(model,'Maxclust',10);
clear idx

idx = clusterdata(Trainingset,'Linkage','ward','SaveMemory','on','Maxclust',15);

% using KNN to test dataset
% https://www.mathworks.com/help/stats/exhaustivesearcher.knnsearch.html

Mdl = fitcknn(Trainingset,idx,'NumNeighbors',5,'Standardize',1)

% 
% Mdl = fitcknn(Trainingset,idx,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus'))
% 

idx_test = predict(Mdl,Testset)

% writematrix([Testset_orig, idx],'Output.csv') 
writematrix([Trainingset_orig, idx],'Output.csv')


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
title ('Hierarchical Tree (15 classes)')
legend(gca,'off');

