createParams;

%% Execute

% Compute precision
files = dir(fullfile(params.rankListPath, '*.txt'));
files = {files.name};
exeFile = fullfile(params.groundtruthPath, 'compute_ap.exe');

for i = 1:numel(files)
    file = files{i};
    fprintf('%s\n', file);
    
    output = fullfile(params.apPath, files{i});
    dos([exeFile, ' ', fullfile(params.groundtruthPath, files{i}(1:end - 10)), ...
        ' ', fullfile(params.rankListPath, files{i}), ' >', output]);
end
fprintf('Computed precision!\n');

% Compute average precision
files = dir(fullfile(params.apPath, '*.txt'));
files = {files.name};
p = zeros(numel(files), 1);

for i = 1:numel(files)
    file = files{i};
    fid = fopen(fullfile(params.apPath, file), 'r');
    p(i) = fscanf(fid, '%f');
    fclose(fid);
end

fprintf('MAP = %f%%\n', mean(p) * 100);