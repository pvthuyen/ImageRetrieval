createParams;

%% Build All Data Kp File
files = dir(fullfile(params.dataPath, 'quantize', '*.mat'));
files = {files.name};
numImages = numel(files);

file = params.allDataKpFile;
if ~exist(file, 'file')
    allDataKp = cell(numImages, 1);
    
    for i = 1:numImages
        load(fullfile(params.dataPath, 'quantize', files{i}));
        allDataKp{i} = imageKp;
    end
    
    save(file, 'allDataKp');
else
    load(file);
end

%% Build All Data Bin file
files = dir(fullfile(params.dataPath, 'quantize', '*.mat'));
files = {files.name};

file = params.allDataBinsFile;
if ~exist(file, 'file')
    allDataBins = cell(numImages, 1);
    for i = 1:numImages
        load(fullfile(params.dataPath, 'quantize', files{i}));
        allDataBins{i} = bins;
        clear bins;
    end
    
    save(file, 'allDataBins');
else
    load(file);
end

%% Build All Data BoW file
files = dir(fullfile(params.dataPath, 'bow', '*.mat'));
files = {files.name};

file = params.allDataBoWFile;
if ~exist(file, 'file')
    allDataBoW = sparse(numel(files), params.histLen);
    for i = 1:numImages
        load(fullfile(params.dataPath, 'bow', files{i}));
        allDataBoW(i, :) = frameBoW;
    end
    save(file, 'allDataBoW', '-v7.3');
else
    load(file);
end
fprintf('Builded all data BoW file!\n');

%% Build IDF file
file = params.idfFile;
if ~exist(file, 'file')
    idfWeight = zeros(params.histLen, 1);
    for i = 1:numImages
        index = find(allDataBoW(i, :));
        for j = 1:length(index)
            idfWeight(index(j)) = idfWeight(index(j)) + 1;
        end
    end
    
    for i = 1:params.histLen
        if idfWeight(i) > 0
            idfWeight(i) = log(numImages / idfWeight(i));
        end
    end
    save(file, 'idfWeight');
else
    load(file);
end
fprintf('Builded IDF file!\n');

%% Query
queryBoWPath = fullfile(params.queryPath, 'bow');
queryBinPath = fullfile(params.queryPath, 'quantize');
queryKpPath = fullfile(params.queryPath, 'feature');
queryFiles = dir(fullfile(queryBoWPath, '*.mat'));
queryFiles = {queryFiles.name};

for i = 1:numel(queryFiles)
    file = queryFiles{i};
    fprintf('%s\n', file);
    load(fullfile(queryBoWPath, file));
    load(fullfile(queryBinPath, file));
    load(fullfile(queryKpPath, file));
    queryBoW = imageBoW;
    queryBin = bins;
    queryKp = imageKp;
    clear 'imageBoW', 'bins', 'imageKp';
    
    % Dot product
    distance = allDataBoW * (queryBoW .* idfWeight);
    
    [~, sortedIndex] = sort(distace, 'descend');
    
    % Query Expansion based on Geometric Verification
    queryBoW = sparse(numImages, 1);
    nVerified = 0;
    
    for j = 1:params.topK
        matchedWords = matchWords(queryBin(1, :), allDataBins{sortedIndex(j)}(1, :));
        matchedWords = [matchedWords matchWords(queryBin(2, :), allDataBins{sortedIndex(j)}(2, :))];
        matchedWords = [matchedWords matchWords(queryBin(3, :), allDataBins{sortedIndex(j)}(3, :))];
        
        % Sampling 1000 matchedWords increases speed without affecting
        % much on the performance
        if (size(matchedWords, 2) > 1000)
            matchedWords = matchedWords(:, randperm(size(matchedWords, 2), 1000));
        end
        
        inliers = geometricVerification(queryKp, allDataKp{sortedIndex(j)}, matchedWords);
        
        if (numel(inlers) > 20)
            temp = reshape(allDataBins{sortedIndex(j)}(:, matchedWords(2, inliers)), 1, []);
            temp = sparse(temp, ones(numel(temp), 1), ones(numel(temp), 1), params.histLen, 1) > 0;
            nVerified = nVerified + 1;
            queryBoW = queryBoW + allDataBoW(sortedIndex(j), :)' .* temp;
        end
    end
    
    query_bow = query_bow ./ cntVerified;
    
    distance = all_data_subbow * query_bow;
    [~, sorted_index] = sort(distance, 'descend');
    
    fid = fopen(fullfile(params.rankListPath, changeExt(file, 'txt')), 'w');
    for j = 1:numImages
        fprintf(fid, '%s\n', files{sortedIndex(j)}(1:end - 4));
    end
    fclose(fid);
end

clear;
