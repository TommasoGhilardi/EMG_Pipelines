
getname = @(x) inputname(1);

%% No normalization
[out] = {PipelineA,PipelineB,PipelineC};

% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineA) '.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineB) '.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineC) '.csv'])
clear out


%% Baseline division
[out] = {PipelineA1,PipelineB1,PipelineC1};

% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineA1) '.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineB1) '.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineC1) '.csv'])
clear out


%% Baseline substraction
[out] = {PipelineA2,PipelineB2,PipelineC2};

% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineA2) '.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineB2) '.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing getname(PipelineC2) '.csv'])
clear out


%% Zscoring for muscles of participants
[out] = Zscoring({PipelineA,PipelineB,PipelineC},1);


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA3.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB3.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC3.csv'])
clear out


%% Zscoring for participant
[out] = Zscoring({PipelineA,PipelineB,PipelineC},'all');


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA4.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB4.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC4.csv'])
clear out


%% Baseline division, Zscoring for muscleso of participant
[out] = Zscoring({PipelineA1,PipelineB1,PipelineC1},1);


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA5.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB5.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC5.csv'])
clear out


%% Baseline substraction, Zscoring for muscleso of participant
[out] = Zscoring({PipelineA2,PipelineB2,PipelineC2},1);


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA6.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB6.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC6.csv'])
clear out


%% Baseline division, Zscoring  participant
[out] = Zscoring({PipelineA1,PipelineB1,PipelineC1},'all');


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA7.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB7.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC7.csv'])
clear out


%% Baseline substraction, Zscoring  participant
[out] = Zscoring({PipelineA2,PipelineB2,PipelineC2},'all');


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA8.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB8.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC8.csv'])
clear out


%% Baseline division, Zscoring for muscles of participant and participant
[out] = Zscoring({PipelineA1,PipelineB1,PipelineC1},1);
[out] = Zscoring({out{1},out{2},out{3}},'all');


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA9.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB9.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC9.csv'])
clear out


%% Baseline substraction, Zscoring for muscles of participant and participant
[out] = Zscoring({PipelineA2,PipelineB2,PipelineC2},1);
[out] = Zscoring({out{1},out{2},out{3}},'all');


% Save table
writetable(out{1},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineA10.csv'])
writetable(out{2},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineB10.csv'])
writetable(out{3},[outputdir '\PipelinesSingle\' Preprocessing 'PipelineC10.csv'])
clear out









