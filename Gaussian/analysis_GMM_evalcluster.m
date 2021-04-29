rng('default');  % For reproducibility

%https://www.mathworks.com/help/stats/evalclusters.html
% Reading the dataset
Data = readtable('../DATASETS/Soria_T_H.csv');

% Normalizing the Dataset
Data_normalized = normalize (Data);

% Convert from table to numbers
X = table2array(Data_normalized);

DataSetSize = size(X)

% Create Training and test sets
Trainingset =(X(1:DataSetSize(1)/2,1:2))
Testset =(X(DataSetSize(1)/2+1:DataSetSize(1),1:2))

gmmoptions = statset('MaxIter',1000);

clust = zeros(size(Trainingset,1),20);
for i=1:20  
 
GMModel = fitgmdist(Trainingset, i, 'Replicates', 5, 'Options', gmmoptions);

clust(:,i) = cluster ( GMModel, Testset);


end

eva_CH = evalclusters(Testset,clust,'CalinskiHarabasz')

eva_DB = evalclusters(Testset,clust,'DaviesBouldin')

eva_Sil = evalclusters(Testset,clust,'Silhouette')

K = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];

evacritdiv_CB = eva_CH.CriterionValues/10000

plot (K, eva_CH.CriterionValues/10000,  '-.o', K, eva_DB.CriterionValues,':+', K, eva_Sil.CriterionValues,'-x','LineWidth', 2)
legend ('CH', 'DB', 'Silouette')

plot (K, evacritdiv_CB, ':o', K, evacritdiv,'-x','LineWidth', 2)
xlabel('Number of Clusters K')
ylabel('Calinski Harabasz Distances (x 10^4)')
legend ('City Block Distance', 'Euclidean Distance')
set(gca,'FontSize',14)