rng('default');  % For reproducibility

% Reading the dataset
Data = readtable('../DATASETS/Soria_T_H.csv');

AllData = table2array(Data);

DataSetSize = size(Data);

number_of_samples = DataSetSize(1);

% Create Training and test sets
Trainingset_orig = table2array(Data(1:number_of_samples/2,1:2));
Testset_orig = table2array(Data(fix(number_of_samples/2)+1:number_of_samples,1:2));

% https://www.mathworks.com/help/stats/dbscan-clustering.html
minpts = 100;
epsilon = 1;


kD = pdist2(AllData, AllData,'euc','Smallest',minpts);
plot(sort(kD(end,:)),'LineWidth', 2);
title('DBSCAN k-distance graph')
xlabel('Points sorted with 100th nearest distances')
ylabel('100th nearest distances')
set(gca,'FontSize',16)

%legend(gca,'off');
grid

pause


idx = dbscan(Testset_orig,epsilon,minpts);






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

gscatter (Testset_orig(:,1),Testset_orig(:,2),idx, colors)
xlabel('Temperature (Centigrades)')
ylabel('Humidity (%)')
set(gca,'FontSize',16)
title ('DBSCAN')


