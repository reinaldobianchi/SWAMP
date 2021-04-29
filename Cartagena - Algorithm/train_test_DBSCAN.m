rng('default');  % For reproducibility

size_training_set = 1200    % 20 days of samples for training 
size_test_set = 36               % samples for a day, 1 minute sampling rate
number_of_test_sets = 10            % 10 days for test

n_replications = 50



% CREATING THE DATA FOR ANALYSIS
% Reading the dataset
%Data = readtable('entradaCom.csv');

Data2 = readtable('CartagenaE53-May-05-11.csv');

Data = removevars(Data2,{'Var1','SensorId', 'TS'});

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

% For Huffman coding
% Create unique symbols, and assign equal probabilities of occurrence to them.
symbols = 1:n_classes; 


% Create a Huffman dictionary based on the symbols and their probabilities.
% Used as Uniform distribution.
% Not used in this work.
p = 1/n_classes*ones(n_classes,1);
dict = huffmandict(symbols,p);


% https://www.mathworks.com/help/stats/dbscan-clustering.html
minpts = 100;
epsilon = 0.80;


kD = pdist2(Trainingset, Trainingset,'euc','Smallest',minpts);
plot(sort(kD(end,:)),'LineWidth', 2);
title('DBSCAN k-distance graph')
xlabel('Points sorted with 200th nearest distances')
ylabel('200th nearest distances')
set(gca,'FontSize',16)

%legend(gca,'off');
grid

pause


idx = dbscan(Trainingset,epsilon,minpts);






% writematrix([Testset_orig, idx'],'Output.csv') 


colors = [[1,0,0],
[0,0.9,0],
[1,0,1],
[1,0.8,0],
[0,0,1],
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

% gscatter (Testset_orig(:,1),Testset_orig(:,2),idx, colors)
gscatter (Trainingset_orig(:,1),Trainingset_orig(:,2),idx, colors)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',16)
title ('DBSCAN')


