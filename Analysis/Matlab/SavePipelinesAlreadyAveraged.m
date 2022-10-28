
getname = @(x) inputname(1);

%% No normalization

writetable(PipelineZ, fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineZ), '.csv']));
writetable(PipelineY,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineY), '.csv']));
writetable(PipelineX,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineX), '.csv']));


%% Baseline division

writetable(PipelineZ1,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineZ1), '.csv']));
writetable(PipelineY1,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineY1), '.csv']));
writetable(PipelineX1,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineX1), '.csv']));


%% Baseline substraction

writetable(PipelineZ2,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineZ2), '.csv']));
writetable(PipelineY2,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineY2), '.csv']));
writetable(PipelineZ2,fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineX2), '.csv']));


%% Zscoring for muscles of participants
[out] = Zscoring({PipelineZ,PipelineY,PipelineX},1);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ3.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY3.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX3.csv']));
clear out


%% Zscoring for participant
[out] = Zscoring({PipelineZ,PipelineY,PipelineX},'all');

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ4.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY4.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX4.csv']));
clear out


%% Baseline division, Zscoring for muscleso of participant
[out] = Zscoring({PipelineZ1,PipelineY1,PipelineX1},1);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ5.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY5.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX5.csv']));
clear out


%% Baseline substraction, Zscoring for muscleso of participant
[out] = Zscoring({PipelineZ2,PipelineY2,PipelineX2},1);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ6.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY6.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX6.csv']));
clear out


%% Baseline division, Zscoring  participant
[out] = Zscoring({PipelineZ1,PipelineY1,PipelineX1},'all');

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ7.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY7.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX7.csv']));
clear out


%% Baseline substraction, Zscoring  participant
[out] = Zscoring({PipelineZ2,PipelineY2,PipelineX2},'all');

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ8.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY8.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX8.csv']));
clear out


%% Baseline division, Zscoring for muscles of participant and participant
[out] = Zscoring({PipelineZ1,PipelineY1,PipelineX1},1);
[out] = Zscoring({out{1},out{2},out{3}},'all');

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ9.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY9.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX9.csv']));
clear out


%% Baseline substraction, Zscoring for muscles of participant and participant
[out] = Zscoring({PipelineZ2,PipelineY2,PipelineX2},1);
[out] = Zscoring({out{1},out{2},out{3}},'all');

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineZ10.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineY10.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineX10.csv']));
clear out









