rng('default');  % For reproducibility

% DEFINING CONSTANTS FOR ANALYSIS
data_file = '../DATASETS/Soria_T_H.csv'

fileID = fopen('RESULTS.txt','w');
fileID_tex = fopen('RESULTS.tex.txt','w');

size_training_set = 20 * 24 * 60    % 20 days of samples for training 
size_test_set = 60*24               % samples for a day, 1 minute sampling rate
number_of_test_sets = 10            % 10 days for test



% CREATING THE DATA FOR ANALYSIS
% Reading the dataset
Data = readtable(data_file);
DataSetSize = size(Data);

% Finding number of samples.
number_of_samples = DataSetSize(1);

if (number_of_samples < size_training_set + size_test_set * number_of_test_sets)
    fprintf ('Not enough samples. Bailing out.\n');
    tchau
end
    

% Create the Training and test sets
Trainingset_orig = table2array(Data(1:size_training_set,1:2));
Testset_orig = table2array(Data(size_training_set+1:size_training_set + size_test_set * number_of_test_sets,1:2));

% Normalizing the Dataset
Data_normalized = normalize (Data);
Trainingset = normalize(Trainingset_orig);
Testset = normalize(Testset_orig);

for i = 1 : size_test_set * number_of_test_sets
    
    if (Testset_orig(i, 1) > 0 && Testset_orig(i, 1) < 47 && Testset_orig(i, 2) > 5 && Testset_orig(i, 2) < 35) 
        idx(i) = 0;
    elseif (Testset_orig(i, 1) > 0 && Testset_orig(i, 1) < 11 && Testset_orig(i, 2) > 40 && Testset_orig(i, 2) < 65) 
        idx(i) = 1; 
    elseif (Testset_orig(i, 1) > 12 && Testset_orig(i, 1) < 28 && Testset_orig(i, 2) > 40 && Testset_orig(i, 2) < 65) 
        idx(i) = 2;
    elseif (Testset_orig(i, 1) > 29 && Testset_orig(i, 1) < 47 && Testset_orig(i, 2) > 40 && Testset_orig(i, 2) < 65) 
        idx(i) = 7;
    elseif (Testset_orig(i, 1) > 0 && Testset_orig(i, 1) < 11 && Testset_orig(i, 2) > 70 && Testset_orig(i, 2) < 100) 
        idx(i) = 8; 
    elseif (Testset_orig(i, 1) > 12 && Testset_orig(i, 1) < 14 && Testset_orig(i, 2) > 60 && Testset_orig(i, 2) < 100) 
        idx(i) = 2;
    elseif (Testset_orig(i, 1) > 15 && Testset_orig(i, 1) < 17 && Testset_orig(i, 2) > 60 && Testset_orig(i, 2) < 100) 
        idx(i) = 3;
    elseif (Testset_orig(i, 1) > 18 && Testset_orig(i, 1) < 27 && Testset_orig(i, 2) > 60 && Testset_orig(i, 2) < 100) 
        idx(i) = 4; 
    elseif (Testset_orig(i, 1) > 28 && Testset_orig(i, 1) < 31 && Testset_orig(i, 2) > 60 && Testset_orig(i, 2) < 100) 
        idx(i) = 5; 
    elseif (Testset_orig(i, 1) > 33 && Testset_orig(i, 1) < 35 && Testset_orig(i, 2) > 60 && Testset_orig(i, 2) < 100) 
        idx(i) = 6; 
    elseif (Testset_orig(i, 1) > 36 && Testset_orig(i, 1) < 47 && Testset_orig(i, 2) > 60 && Testset_orig(i, 2) < 100) 
        idx(i) = 7; 
    end
   
    
end



 
gscatter (Testset_orig(:,1),Testset_orig(:,2),idx)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',16)
legend ('Critical Dry','Lower Fail', 'Marginal', 'Lower Optimal', 'Optimal', 'Upper Optimal', 'Upper Marginal', 'Upper Fail', 'Cold and Humid')  
title ('Fixed Rules (10 classes)')

writematrix([Testset_orig, idx'],'Output.csv') 


gscatter (Testset_orig(:,1),Testset_orig(:,2),idx)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',14)