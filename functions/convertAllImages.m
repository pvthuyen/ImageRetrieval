function convertAllImages(inPath)
    files = dir(inPath, '*.jpg');
    files = {files.name};
    for i = 1:numel(files)
        im = imread(fullfile(inPath, files{i}));
        imwrite(im, fullfile(inPath, strrep(files{i}, '.jpg', '.png')));
    end
end