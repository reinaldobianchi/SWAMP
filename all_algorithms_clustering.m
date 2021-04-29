rng('default');  % For reproducibility

%Number of classes
n_classes = 20

% DEFINING CONSTANTS FOR ANALYSIS
data_file = './DATASETS/Soria_T_H.csv';

fileID = fopen(strcat('RESULTS-',num2str(n_classes),'.txt'), 'w');
fileID_tex = fopen(strcat('RESULTS-rle-k-',num2str(n_classes),'.tex.txt'), 'w');
fileID_tex_huff = fopen(strcat('RESULTS-huff-k-',num2str(n_classes),'.tex.txt'), 'w');

size_training_set = 20 * 24 * 60    % 20 days of samples for training 
size_test_set = 60*24               % samples for a day, 1 minute sampling rate
number_of_test_sets = 10            % 10 days for test

n_replications = 50

prediction_time = zeros (10,1);

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
Trainingset_orig = table2array(Data(1:size_training_set,1:DataSetSize(2)));
Testset_orig = table2array(Data(size_training_set+1:size_training_set + size_test_set * number_of_test_sets,1:DataSetSize(2)));

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


% K-MEANS CLASSIFIER

% Creating the classifier
% https://www.mathworks.com/help/stats/kmeans.html 
%[idx,C,sumdist3] = kmeans(Trainingset,n_classes,'Distance','cityblock','Display','final','Replicates',n_replications);
[idx,C,sumdist] = kmeans(Trainingset,n_classes,'Distance','sqeuclidean','Display','final','Replicates',n_replications);

% Computing the class for the test dataset
tStart = tic; 
[~,idx_test] = pdist2(C,Testset,'euclidean','Smallest',1);
prediction_time(1) = toc(tStart);

% Write classification to file
writematrix([Trainingset_orig, idx],strcat('Output-train-kmeans-',num2str(n_classes),'.csv'));
writematrix([Testset_orig, idx_test'],strcat('Output-kmeans-',num2str(n_classes),'.csv')); 

%Create a Huffman dictionary based on the symbols and their probabilities.
p = hist(idx,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('K-means', idx_test, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)



% GAUSSIAN MODEL
% https://www.mathworks.com/help/stats/fitgmdist.html
gmmoptions = statset('MaxIter',1000);
GMModel = fitgmdist(Trainingset, n_classes, 'Replicates', n_replications, 'Options', gmmoptions);

% https://stackoverflow.com/questions/26261555/labelling-new-data-using-trained-gaussian-mixture-mode
idx = cluster ( GMModel, Trainingset);

tStart = tic; 
idx_test = cluster ( GMModel, Testset);
prediction_time(2) = toc(tStart);

% Write classification to file
writematrix([Trainingset_orig, idx],strcat('Output-train-GMM-',num2str(n_classes),'.csv'));
writematrix([Testset_orig, idx_test],strcat('Output-GMM-',num2str(n_classes),'.csv')); 


%Create a Huffman dictionary based on the symbols and their probabilities.\
p = hist(idx,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('GMM', idx_test, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict);



% HIERARCHICAL TREE

% The classified training set using Hierachical Tree
% https://www.mathworks.com/help/stats/clusterdata.html
idx = clusterdata(Trainingset,'Linkage','ward','SaveMemory','on','Maxclust',n_classes);


writematrix([Trainingset_orig, idx],strcat('Output-train-Hierarch-',num2str(n_classes),'.csv'));


% Using KNN Classifier to predict test dataset

% First we fit a supervised classifier KNN, using the trained data
% https://www.mathworks.com/help/stats/fitcknn.html
Mdl = fitcknn(Trainingset, idx,'NumNeighbors',1,'Distance','seuclidean','Standardize',1)

% this below gets the best supervised classifier
% it can be used to decide the parameters of the KNN classifier, but not
% during usage in the field.
% 
% Mdl = fitcknn(Trainingset,idx,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',...
%     struct('AcquisitionFunctionName','expected-improvement-plus'))

% then we use the trained knn classifier to classify the test data
% https://www.mathworks.com/help/stats/classificationknn.predict.html
tStart = tic; 
idx_test = predict(Mdl,Testset);
prediction_time(3) = toc(tStart);

% Write classification to file
writematrix([Testset_orig, idx_test],strcat('Output-Hierarc_Knn-',num2str(n_classes),'.csv')); 

%Create a Huffman dictionary based on the symbols and their probabilities.
p = hist(idx,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('Tree+KNN', idx_test, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)

% Using Tree Classifier to predict test dataset
% First we fit a supervised classifier Tree, using the trained data
% https://www.mathworks.com/help/stats/decision-trees.
% https://www.mathworks.com/help/stats/fitctree.html

Mdl = fitctree(Trainingset, idx);

% then we use the trained classifier to classify the test data
% https://www.mathworks.com/help/stats/classificationknn.predict.html
tStart = tic; 
idx_test = predict(Mdl,Testset);
prediction_time(4) = toc(tStart);

% Write classification to file
writematrix([Testset_orig, idx_test],strcat('Output-Hierarc_Tree-',num2str(n_classes),'.csv')); 

%Create a Huffman dictionary based on the symbols and their probabilities.
p = hist(idx,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('Tree+Tree', idx_test, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)


% SPECTRAL CLUSTERING
% https://www.mathworks.com/help/stats/partition-data-using-spectral-clustering.html
[idx,V,D] = spectralcluster(Trainingset,n_classes);

writematrix([Trainingset_orig, idx],strcat('Output-train-Spectral-',num2str(n_classes),'.csv'));

% using KNN Classifier to predict test dataset

% First we fit a supervised classifier to a knn, using the trained data
% https://www.mathworks.com/help/stats/fitcknn.html
Mdl = fitcknn(Trainingset, idx,'NumNeighbors',1,'Distance','seuclidean','Standardize',1)

 
% this below gets the best supervised classifier
% 
% Mdl = fitcknn(Trainingset,idx,'OptimizeHyperparameters','auto',...
%    'HyperparameterOptimizationOptions',...
%    struct('AcquisitionFunctionName','expected-improvement-plus'))

% then we use the trained knn classifier to classify the test data
% https://www.mathworks.com/help/stats/classificationknn.predict.html
tStart = tic; 
idx_test = predict(Mdl,Testset);
prediction_time(5) = toc(tStart);

% Write classification to file
writematrix([Testset_orig, idx_test],strcat('Output-Spectral_Knn-',num2str(n_classes),'.csv')); 

%Create a Huffman dictionary based on the symbols and their probabilities.
p = hist(idx,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('Spectral+KNN', idx_test, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)


% Using Tree Classifier to predict test dataset
% First we fit a supervised classifier Tree, using the trained data
% https://www.mathworks.com/help/stats/decision-trees.
% https://www.mathworks.com/help/stats/fitctree.html

Mdl = fitctree(Trainingset, idx);

% then we use the trained classifier to classify the test data
% https://www.mathworks.com/help/stats/classificationknn.predict.html
tStart = tic; 
idx_test = predict(Mdl,Testset);
prediction_time(6) = toc(tStart);

% Write classification to file
writematrix([Testset_orig, idx_test],strcat('Output-Spectral_Tree-',num2str(n_classes),'.csv')); 


%Create a Huffman dictionary based on the symbols and their probabilities.
p = hist(idx,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('Spectral+Tree', idx_test, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)



%DBSCAN
% https://www.mathworks.com/help/stats/dbscan-clustering.html
minpts = 200;
epsilon = 0.1;
idx = dbscan(Trainingset,epsilon,minpts);

writematrix([Trainingset_orig, idx],strcat('Output-train-DBSCAN-',num2str(n_classes),'.csv'));


% using KNN Classifier to predict test dataset

% First we fit a supervised classifier to a knn, using the trained data
% https://www.mathworks.com/help/stats/fitcknn.html
Mdl = fitcknn(Trainingset, idx,'NumNeighbors',2,'Distance','seuclidean','Standardize',1)

 
% this below gets the best supervised classifier
% 
%Mdl = fitcknn(Trainingset,idx,'OptimizeHyperparameters','auto',...
 %   'HyperparameterOptimizationOptions',...
 %   struct('AcquisitionFunctionName','expected-improvement-plus'))

% then we use the trained knn classifier to classify the test data
% https://www.mathworks.com/help/stats/classificationknn.predict.html
tStart = tic; 
idx_test = predict(Mdl,Testset);
prediction_time(7) = toc(tStart);

% Write classification to file
writematrix([Testset_orig, idx_test],strcat('Output-DBSCAN_Knn-',num2str(n_classes),'.csv')); 

%Create a Huffman dictionary based on the symbols and their probabilities.
symbols = 0:max(idx+1);
p = hist(idx+1,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('DBSCAN+KNN', idx_test+1, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)


% Using Tree Classifier to predict test dataset
% First we fit a supervised classifier Tree, using the trained data
% https://www.mathworks.com/help/stats/decision-trees.
% https://www.mathworks.com/help/stats/fitctree.html

Mdl = fitctree(Trainingset, idx);

% then we use the trained classifier to classify the test data
% https://www.mathworks.com/help/stats/classificationknn.predict.html
tStart = tic; 
idx_test = predict(Mdl,Testset);
prediction_time(8) = toc(tStart);

% Write classification to file
writematrix([Testset_orig, idx_test],strcat('Output-DBSCAN_Tree-',num2str(n_classes),'.csv')); 

%Create a Huffman dictionary based on the symbols and their probabilities.
%For DBSCAN only:
symbols = 0:max(idx+2); 
p = hist(idx+1,symbols)/size_training_set
dict = huffmandict(symbols,p);

% Create and write statistics
make_statistics ('DBSCAN+Tree', idx_test+1, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)


% Finishing everything

% print prediction times
prediction_time


% Close output files
fclose(fileID);
fclose (fileID_tex);
fclose (fileID_tex_huff);


function data = rle(x)
% data = rle(x) (de)compresses the data with the RLE-Algorithm
%   Compression:
%      if x is a numbervector data{1} contains the values
%      and data{2} contains the run lenths
%
%   Decompression:
%      if x is a cell array, data contains the uncompressed values
%
%      Version 1.0 by Stefan Eireiner (<a href="mailto:stefan-e@web.de?subject=rle">stefan-e@web.de</a>)
%      based on Code by Peter J. Acklam
%      last change 14.05.2004

    if iscell(x) % decoding
        i = cumsum([ 1 x{2} ]);
        j = zeros(1, i(end)-1);
        j(i(1:end-1)) = 1;
        data = x{1}(cumsum(j));
    else % encoding
        if size(x,1) > size(x,2), x = x'; end % if x is a column vector, tronspose
        i = [ find(x(1:end-1) ~= x(2:end)) length(x) ];
        data{2} = diff([ 0 i ]);
        data{1} = x(i);
    end
end

function make_statistics(classifier, idx_2, fileID, fileID_tex, fileID_tex_huff, size_test_set, number_of_test_sets, n_classes, dict)
% Dividing the test dataset into groups for statistics
% each groups = data package
% sabed results in bits

% https://www.mathworks.com/help/comm/ref/huffmanenco.html

% from workspace

% To count size of codings
size_vector = zeros(number_of_test_sets,1);
size_vector_huff = zeros(number_of_test_sets,1);

Z = reshape (idx_2, size_test_set, number_of_test_sets);

for i = 1:number_of_test_sets
    % Here we get the RLE data in a 2 cell format - see function at the end
    % of script
    rle_data = rle(Z(:,i));
    % Here we find the size of ther REL encoding
    size_cells = size (rle_data{1});
    size_vector(i) = size_cells(2);
    
    % Encode the classification results symbols with Huffman.
    huff_data = huffmanenco(Z(:,i),dict);
    
    % Here we find the size of the Huffman encoding
    size_cells = size (huff_data);
    size_vector_huff(i) = size_cells (1);
      
end

mean_rle  = 100* (16 * 2 * mean (size_vector))/ (size_test_set * 2 * 32);
std_rle   = 100* (16 * 2 * std(size_vector))/ (size_test_set*2*32);
mean_huff = 100* mean (size_vector_huff) / (size_test_set*2*32);
std_huff  = 100* std(size_vector_huff) / (size_test_set*2*32);

[h, p] = ttest2(size_vector, size_vector_huff);

fprintf ('%s: %d classes:\tRLE mean %.1f std %.2f HUFFMAN mean %.1f std %.2f Student T Test %d p-value %f.\n', classifier, n_classes, mean_rle, std_rle, mean_huff, std_huff, h, p);
fprintf (fileID, '%s: %d classes:\tRLE mean %.1f std %.2f HUFFMAN mean %.1f std %.2f Student T Test %d p-value %f.\n', classifier, n_classes, mean_rle, std_rle, mean_huff, std_huff, h, p);
fprintf (fileID_tex, '& $(%.1f \\pm %.2f)$\\\\\n',  mean_rle, std_rle);
fprintf (fileID_tex_huff, '$(%.1f \\pm %.2f)$\\\\\n', mean_huff, std_huff);
end
