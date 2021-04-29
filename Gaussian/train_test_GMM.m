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

% GAUSSIAN MODEL
% https://www.mathworks.com/help/stats/fitgmdist.html
gmmoptions = statset('MaxIter',1000);
GMModel = fitgmdist(Trainingset, 15, 'Replicates', 50, 'Options', gmmoptions);


% https://stackoverflow.com/questions/26261555/labelling-new-data-using-trained-gaussian-mixture-model

idx = cluster ( GMModel, Testset)

writematrix([Testset_orig, idx],'Output.csv') 


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


gscatter (Testset_orig(:,1),Testset_orig(:,2),idx, colors)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',16)
title ('Gaussian Mixture (15 classes)')
legend(gca,'off');




