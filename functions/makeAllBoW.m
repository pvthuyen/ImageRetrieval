function makeAllBoW(inPath, outPath, histLen)
    files = dir(inPath, '*.mat');
    files = {files.name};
    
    for i = 1:numel(files)
        quantizeFile = fullfile(inPath, files{i});
        bowFile = fullfile(outPath, files{i});
        
        if ~exist(bowFile)
            load(quantizeFile);
            
            imageBoW = zeros(histLen, 1);
            imageFreq = zeros(histLen, 1);
            bins = reshape(bins(:), 1, []);
            
            weights = exp(-sqrDists./(2 * params.quantStruct.deltaSqr));
            weights = weights./repmat(sum(weights, 1), size(weights, 1), 1);
            weights = reshape(weights, 1, []);
            
            imageFreq = vl_binsum(imageFreq, ones(size(bins)), bins);
            imageBoW = vl_binsum(imageBoW, weights, bins);
            
            imageBoW = sqrt(imageBoW) ./ sqrt(imageFreq);
            
            imageBoW = sparse(imageBoW);
            imageFreq = sparse(imageFreq);
            save(bowFile, 'imageBoW', 'imageFreq');
        end
        
        fprintf('Finished %d/%d files\n', i, numel(files));
    end
end