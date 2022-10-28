
% Fucntion to get the name of a passed variable
getname = @(x) inputname(1);

%% No normalization
[out] = extractAVG({PipelineA,PipelineB,PipelineC});

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineA), '.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineB), '.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineC), '.csv']));
clear out


%% Baseline division
[out] = extractAVG({PipelineA1,PipelineB1,PipelineC1});

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineA1), '.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineB1), '.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineC1), '.csv']));
clear out


%% Baseline substraction
[out] = extractAVG({PipelineA2,PipelineB2,PipelineC2});

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineA2), '.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineB2), '.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, getname(PipelineC2), '.csv']));
clear out


%% Zscoring for muscles of participants
[out] = Zscoring({PipelineA,PipelineB,PipelineC},1);
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA3.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB3.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC3.csv']));
clear out


%% Zscoring for participant
[out] = Zscoring({PipelineA,PipelineB,PipelineC},'all');
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA4.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB4.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC4.csv']));
clear out


%% Baseline division, Zscoring for muscleso of participant
[out] = Zscoring({PipelineA1,PipelineB1,PipelineC1},1);
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA5.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB5.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC5.csv']));
clear out


%% Baseline substraction, Zscoring for muscleso of participant
[out] = Zscoring({PipelineA2,PipelineB2,PipelineC2},1);
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA6.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB6.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC6.csv']));
clear out


%% Baseline division, Zscoring  participant
[out] = Zscoring({PipelineA1,PipelineB1,PipelineC1},'all');
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA7.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB7.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC7.csv']));
clear out


%% Baseline substraction, Zscoring  participant
[out] = Zscoring({PipelineA2,PipelineB2,PipelineC2},'all');
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA8.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB8.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC8.csv']));
clear out


%% Baseline division, Zscoring for muscles of participant and participant
[out] = Zscoring({PipelineA1,PipelineB1,PipelineC1},1);
[out] = Zscoring({out{1},out{2},out{3}},'all');
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA9.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB9.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC9.csv']));
clear out


%% Baseline substraction, Zscoring for muscles of participant and participant
[out] = Zscoring({PipelineA2,PipelineB2,PipelineC2},1);
[out] = Zscoring({out{1},out{2},out{3}},'all');
[out] = extractAVG(out);

% Save table
writetable(out{1},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineA10.csv']));
writetable(out{2},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineB10.csv']));
writetable(out{3},fullfile(outputdir, 'Pipelines', [Preprocessing, 'PipelineC10.csv']));
clear out









