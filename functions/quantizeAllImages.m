function quantizeAllImages(inPath, outPath, searchParams, knn)
    files = dir(inPath, '*.mat');
    files = {files.name};
    
    for i=1:numel(filles)
        featureFile = fullfile(inPath, files{i});
        quantizeFile = fullfile(outPath, files{i});
        load(featureFile, 'imageDesc');
        
        if ~exist(quantizeFile, 'file')
            [bins, sqrDists] = flann_search(kdtree, single(clip_desc), knn, searchParams);
            save(quantizeFile, 'bins','sqrdists');
        end
        fprintf('Finished %d/%d files\n', i, numel(files));
    end
end