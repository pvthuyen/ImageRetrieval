createParams;

%% Extract features for data

fprintf('Extract features of data images\n');
extractAllImages(fullfile(params.dataPath, 'image'), fullfile(params.dataPath, 'feature'));

%% Extract features for queries
fprintf('Extract features of query images\n');
extractAllImages(fullfile(params.queryPath, 'image'), fullfile(params.queryPath, 'feature'));


clear;