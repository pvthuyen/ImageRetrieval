createParams;

% Load codebook
data = hdf5read(params.codebookFile, '/clusters');

% Create kdtree
kdtreeFile = fullfile(params.dataPath, 'flann_kdtree.bin');
kdsearchFile = fullfile(params.dataPath, 'flann_kdtree_search.mat');

if exist(kdtreeFile, 'file')
    fprintf('Loading kdtree ...\n');
    kdtree = flann_load_index(kdtreeFile, data);
    load(kdsearchFile);
else
    fprintf('Building kdtree ...\n');
    [kdtree, searchParams] = flann_build_index(data, params.quantStruct.buildParams);
    flann_save_index(kdtree, kdtreeFile);
    save(kdsearchFile, 'searchParams');
end

% Quantize and build BoW data
fprintf('Quantize all data images\n');
quantizeAllImages(fullfile(params.dataPath, 'feature'), fullfile(params.dataPath, 'quantize'), searchParams, params.quantStruct.knn);
fprintf('Make BoW vectors for all data images\n');
makeAllBoW(fullfile(params.dataPath, 'quantize'), fullfile(params.dataPath, 'bow'), params.histLen);

% Quantize and build BoW queries
fprintf('Quantize all query images\n');
quantizeAllImages(fullfile(params.queryPath, 'feature'), fullfile(params.queryPath, 'quantize'), searchParams, params.quantStruct.knn);
fprintf('Make BoW vectors for all query images\n');
makeAllBoW(fullfile(params.queryPath, 'quantize'), fullfile(params.queryPath, 'bow'), params.histLen);

clear;