function extractAllImages(inPath, outPath)
    convertAllImages(inPath);
    files = dir(fullfile(inPath, '*.png'));
    files = {files.name};
    
    if strfind(params.os, 'win') % Window
        exeFile = fullfile('lib', 'feature_detector', 'compute_descriptors.exe');
    else
        if strfind(params.os, '64')
            exeFile = fullfile('lib', 'feature_detector', 'compute_descriptors_64bit.ln');
        else
            exeFile = fullfile('lib', 'feature_detector', 'compute_descriptors_32bit.ln');
        end
    end
    
    params.extract = @(fi, fo, args)params.cmd([exeFile, ' ', args, ' -i ', fi, ' -o1 ', fo]);
    args = strrep(params.featureArgs, '-rootsift', '-sift');
    
    for i = 1:numel(files)
        inFile = fullfile(inPath, files{i});
        tempFile = fullfile(params.tempPath, strrep(files{i}, '.png', ''));
        outFile = fullfile(outPath, strrep(files{i}, '.png', '.mat'));
        
        if ~exist(outFile, 'file')
            params.extract(inFile, tempFile, args);
            if ~exist(tempFile, 'file')
                imageKp = zeros(params.kpLen, 0);
                imageDesc = zeros(params.descLen, 0);
            else
                [imageKp, imageDesc] = vl_ubcread(tempFile, 'format', 'oxford');
                if strfind(params.featureArgs, '-rootsift')
                    sift = double(imageDesc);
                    imageDesc = single(sqrt(sift ./ repmat(sum(sift), params.descLen, 1)));
                end
            end
            
            save(outFile, 'imageKp', 'imageDesc');
            
        end
        
        fprintf('Finished %d/%d images \n', i, numel(files));
    end
end