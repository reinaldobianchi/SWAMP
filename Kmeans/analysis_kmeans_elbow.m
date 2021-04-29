rng('default');  % For reproducibility

% Reading the dataset
Data = readtable('../DATASETS/Soria_T_H.csv');

% Normalizing the Dataset
Data_normalized = normalize (Data);

% Convert from table to numbers
X = table2array(Data_normalized);

% Create Training and test sets
DataSetSize = size(X)
Trainingset =(X(1:DataSetSize(1)/2,1:2))
Testset =(X(DataSetSize(1)/2+1:DataSetSize(1),1:2))

Result_City = zeros (30,2)
Result_Euclides = zeros (30,2)

for i=1:30
    
    [idx3,C,sumdist3] = kmeans(Trainingset,i,'Distance','cityblock','Display','final','Replicates',50);
    Result_City(i,:) = [i,sum(sumdist3)];
    [idx3,C,sumdist3] = kmeans(Trainingset,i,'Distance','sqeuclidean','Display','final','Replicates',50);
    Result_Euclides(i,:) = [i,sum(sumdist3)];
end

plot (Result_City(:,1), Result_City(:,2), '-.o', Result_Euclides(:,1), Result_Euclides(:,2),'-x','LineWidth', 2)
legend ('City Block Distance', 'Euclidean Distance')
xlabel('Number of Clusters K')
ylabel('Sum of Within-Cluster Distances')
set(gca,'FontSize',14)



% plot (K, Distances);

% [silh3,h] = silhouette(X,idx3,'cityblock');
% xlabel('Silhouette Value')
% ylabel('Cluster')

%gscatter (Trainingset(:,1),Trainingset(:,2),idx3)

%[~,idx_test] = pdist2(C,table2array([Xt, Yt]),'euclidean','Smallest',1);