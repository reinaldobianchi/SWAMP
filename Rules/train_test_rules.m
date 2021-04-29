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



AllData = Testset_orig;

DataSetSize = size(AllData);

number_of_samples = DataSetSize(1);

% Create Training and test sets
%Trainingset_orig = table2array(Data(1:number_of_samples/2,1:2));
%Testset_orig = table2array(Data(fix(number_of_samples/2)+1:number_of_samples,1:2));




for i = 1 : number_of_samples
    % Critical dry
    if (AllData(i, 1) >= 0 && AllData(i, 1) <= 48 && AllData(i, 2) >= 5 && AllData(i, 2) <= 41) 
        idx(i) = 9;
    % Lower fail
    elseif (AllData(i, 1) >= 0 && AllData(i, 1) <= 12 && AllData(i, 2) >= 40 && AllData(i, 2) <= 65) 
        idx(i) = 1; 
    % Marginal
    elseif (AllData(i, 1) >= 12 && AllData(i, 1) <= 29 && AllData(i, 2) >= 40 && AllData(i, 2) <= 65) 
        idx(i) = 2;
    % Upper Fail
    elseif (AllData(i, 1) >= 29 && AllData(i, 1) <= 48 && AllData(i, 2) >= 40 && AllData(i, 2) <= 65) 
        idx(i) = 7;
    % Cold and Humid
    elseif (AllData(i, 1) >= 0 && AllData(i, 1) <= 12 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 8; 
    % Marginal
    elseif (AllData(i, 1) >= 12 && AllData(i, 1) <= 15 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 2;
    % Lower optimal
    elseif (AllData(i, 1) >= 15 && AllData(i, 1) <= 18 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 3;
    % Optimal
    elseif (AllData(i, 1) >= 18 && AllData(i, 1) <= 28 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 4; 
    elseif (AllData(i, 1) >= 28 && AllData(i, 1) <= 32 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 5; 
    elseif (AllData(i, 1) >= 32 && AllData(i, 1) <= 36 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 6; 
    elseif (AllData(i, 1) >= 36 && AllData(i, 1) <= 47 && AllData(i, 2) >= 60 && AllData(i, 2) <= 100) 
        idx(i) = 7; 
    end
   
    
end


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


gscatter (AllData(:,1),AllData(:,2),idx,colors)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',16)
legend ('Not Classified','Lower Fail', 'Marginal', 'Lower Optimal', 'Optimal', 'Upper Optimal', 'Upper Marginal', 'Upper Fail', 'Cold and Humid', 'Critical Dry')  
title ('Fixed Rules (10 classes)')
writematrix([Testset_orig, idx'],'Output.csv') 


