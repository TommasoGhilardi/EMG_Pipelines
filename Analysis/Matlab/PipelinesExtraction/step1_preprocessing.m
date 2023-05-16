%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preprocessing 1

interactive = false;

%% Setting paths
% data and result folder are in the same lcoation as script folder

cd C:\Users\krav\Desktop\BabyBrain\Projects\EMG\  % project dir
bidsdir   = '.\Data\Bids';
outputdir = '.\Processing';

% add all the scripts to the path
Script_path = matlab.desktop.editor.getActiveFilename;
addpath(Script_path( 1: strfind(Script_path,'\step1_preprocessing')));


%% Happy	Neutral	Sad
response = [
  3	  6	  9
  12	15	18
  21	24	27
  30	33	36
  39	42	45
  48	51	54
  57	60	63
  66	69	72
  75	78	81
  84	87	90
  93	96	99
  102	105	108
  111	114	117
  120	123	126
  129	132	135
  138	141	144
  147	150	153
  156	159	162
  165	168	171
  ];

happy   = response(:,1);
neutral = response(:,2);
sad     = response(:,3);
emotions = ["happy";"neutral";"sad"];


%% Fix Bipolar channels
% this is to combine two channels with a common reference into a singel bipolar channel
% the same is done for corr and zyg

montage = [];
montage.labelold = {
  'corr1'
  'corr2'
  'zyg1'
  'zyg2'
  };    % old labels

montage.labelnew = {  
  'corr'
  'zyg'
  };    % new labels

montage.tra = [
  1 -1 0 0
  0 0 1 -1
  ];    % channel matrix


%% Prepare data to fill

% Rejection summary
Rejection_Summary = NaN(100,4); 

% Prepare pipeline struct
Pipelines.Raw = [];
Pipelines.Average = [];

for subjindx = 1:100

    dataset = sprintf('%s/sub-P%04d/beh/sub-P%04d_task-observation_emg.vhdr', bidsdir, subjindx, subjindx);

    %% Reading and filtering data

    cfg = [];
    cfg.bpfilter  = 'yes';
    cfg.bpfreq    = [20 500]; % bandpass fileter between 20 and 500
    cfg.bpfiltord = 4;
    cfg.bpfiltdir = 'twopass';
    cfg.dataset   = dataset;
    cfg.montage   = montage;
    data = ft_preprocessing(cfg);

    data.trial{:} =  abs(data.trial{:}); % Rectification of signal


    %% Reading events

    event = ft_read_event(dataset, 'type', 'Response', 'readbids', false);

    % removing letter from event value
    for i=1:numel(event)
    event(i).value = str2double(event(i).value(2:end));
    end
    event(~ismember([event.value], response)) = []; % removing unnecessarey events


    %% Plot continuos data with events
    if interactive == true
      cfg = [];
      cfg.viewmode  = 'vertical';
      cfg.event     = event;
      ft_databrowser(cfg, data);
      title('Continuos data with events')
    end


    %% Artifact rejection based on 3sd

    % Set directory 
    filename  = fullfile(outputdir, 'Artifacts', [sprintf('sub-P%04d', subjindx) '.mat']);

    % Creating trials of 1 seconds 
    cfg = [];
    cfg.length  = 1;
    cfg.overlap = 0;
    data_seg    = ft_redefinetrial(cfg, data);

    % Mean and standard deviation rejection
    Me = mean(data.trial{:},2);
    Sd = std(data.trial{:},0,2);

    M_seg = cell2mat(cellfun(@(x) mean(x, 2), data_seg.trial,'UniformOutput', false));

    Rejection = M_seg(1,:) > (Me(1)+3*Sd(1)) | M_seg(2,:) > (Me(2)+3*Sd(2));
    Artifacts = data_seg.sampleinfo(find(Rejection),:);

    % Print details
    Rej_N = length(Rejection(Rejection == 1));
    Total_N = length(Rejection);

    % Save artifact specification to file    
    save(filename, 'Artifacts')


  
    %% Segment and clean data

    % Triggers selections
    numericvalue = [happy, neutral, sad];
    stringvalue = cell(size(numericvalue));
    for i=1:numel(numericvalue)
        stringvalue{i} = sprintf('R%3d', numericvalue(i));
    end

    % Segment into trials
    cfg = [];
    cfg.dataset = dataset;
    cfg.trialdef.prestim = 0.5;
    cfg.trialdef.poststim = 2;
    cfg.trialdef.eventtype = 'Response';
    cfg.trialdef.eventvalue = stringvalue;
    cfg = ft_definetrial(cfg);
    data_trl = ft_redefinetrial(cfg, data);

    % Remove artifacts
    cfg = [];
    cfg.artfctdef.summary.artifact = Artifacts;
    cfg.artfctdef.reject = 'complete';
    data_trl_clean = ft_rejectartifact(cfg, data_trl);

    % Save to summary
    clc;
    disp(['Subject ' num2str(subjindx) ':'...
      newline...
      '     ' num2str(100*Rej_N/Total_N) '% of rejected 1s trials'...
      newline...
      '     ' num2str(length(data_trl.trial)-length(data_trl_clean.trial)) ' trials were rejected'])
    Rejection_Summary(subjindx,:) = [Rej_N, 100*Rej_N/Total_N,...
      length(data_trl.trial)-length(data_trl_clean.trial), (length(data_trl.trial)-length(data_trl_clean.trial))*100/length(data_trl.trial) ];


    %% Launching step2

    % wait to close the plot before launching step 2
    disp('======================= Close Plots to continue =======================');
    while ~isempty(get(groot, 'Children'))
    pause(0.2);
    end
    clc;
    disp('======================= Starting Step 2 =======================');
      
    % Calculate idexes on all trials
    step2_pipeline_RMSs;
    step2_pipeline_AUCs;
    step2_pipeline_MAVs;

    % Calculate idexes on average of trials
    step2_pipeline_RMSa;
    step2_pipeline_AUCa;
    step2_pipeline_MAVa;

    clear Artifacts
end

% Save and display total artifact rejection
clc;
save(fullfile(outputdir,'Artifacts', 'Rejection_summary.mat'), 'Rejection_Summary')
disp(['Mean trial rejection = ' num2str(mean(Rejection_Summary(:,3)))])
disp(['Mean % rejection = ' num2str(mean(Rejection_Summary(:,4)))])

clearvars -except Pipelines *dir


%% Standardize all pipelines and save them to single files

Standardization;


  