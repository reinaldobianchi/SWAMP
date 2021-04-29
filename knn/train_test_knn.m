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


% Creating the classifier
% https://www.mathworks.com/help/stats/classification-using-nearest-neighbors.html
% https://www.mathworks.com/help/stats/kdtreesearcher.html

Mdl = KDTreeSearcher(Trainingset, 'Distance', 'cityblock', 'BucketSize', 1000);
% Mdl = createns(Trainingset) %, 'Distance', 'cityblock', 'BucketSize', 1000);


%https://www.mathworks.com/help/stats/exhaustivesearcher.knnsearch.html
idx_test = knnsearch(Mdl,Testset)



%pause

%writematrix([Testset_orig, idx_test'],'Output.csv') 


gscatter (Testset_orig(:,1),Testset_orig(:,2),idx_test)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
legend('hide')
set(gca,'FontSize',14)
