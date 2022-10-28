%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preprocessing 1

Preprocessing = '1_';
interactive = false;

%% Settipng paths
% data and result folder are in the same lcoation as script folder
Script_path = matlab.desktop.editor.getActiveFilename;
cd(Script_path( 1: strfind(Script_path,'Matlab')+6));
bidsdir   = [Script_path( 1: strfind(Script_path,'scripts')-1), 'bids'];
outputdir = [Script_path( 1: strfind(Script_path,'scripts')-1), 'result'];

%% 

% Happy	Neutral	Sad
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

%% Single subject basic processing

for subjindx = 1:100

  % [13 64 65 42 60 36 9 80 2 17 55 11 50 38 56 26 30 25 5 66 23 76 39 74 3 61 37 40 53 19 24 72 86 47 95 33 62 77]
  % [49 92 52 18 35 54 41 21 84 10 85 1 70 83 46 45 87 88 34 94 7 71 29 98 59 28 100 32 99 78 91 69 67 ]
  % [75 68 73 14 82 79 51 90 20 93 15 89 63 6 31 16 27 97 48 43 22 4 81 96 57 44 58 12 8 ]
  
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
  
  if interactive == true
      cfg = [];
      artf = ft_databrowser(cfg, data);
  end
  
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

  %% ARtifact Rejection
  
  % Set directory 
  resultdir = fullfile(outputdir, sprintf('sub-P%04d', subjindx));
  filename  = fullfile(resultdir, 'artifact.mat');
  
  % Load the previously identified artifacts from file if exist
  if exist(filename, 'file')    
    load(filename, 'artifact')
  else
    % Creating trials of 1 seconds 
    cfg = [];
    cfg.length  = 1;
    cfg.overlap = 0;
    data_seg    = ft_redefinetrial(cfg, data);
    data_seg.time(2:end) = data_seg.time(1); % HACK (giving the same time to all the segment)
    
    % Reject artifact
    % the data_clean variable is actually not even so interesting, but it also contains
    % the specification of the artifacts (begin- and endsample)
    cfg = [];
    cfg.method      = 'summary';
    cfg.keepchannel = 'yes';
    data_clean = ft_rejectvisual(cfg, data_seg);
    
    % Save artifact specification to file    
    artifact = data_clean.cfg.artfctdef.summary.artifact;
    mkdir(resultdir); % create subject folder
    save(filename, 'artifact')
  end
  
  
  %% Segment and clean data
  
  % Triggers selections
  numericvalue = [happy, neutral, sad];
  stringvalue = cell(size(numericvalue));
  for i=1:numel(numericvalue)
    stringvalue{i} = sprintf('R%3d', numericvalue(i));
  end
  
  data.trial{:} =  abs(data.trial{:}); % Rectification of signal
  
  % Cut trials
  cfg = [];
  cfg.dataset = dataset;
  cfg.trialdef.prestim = 0.5;
  cfg.trialdef.poststim = 1.5;
  cfg.trialdef.eventtype = 'Response';
  cfg.trialdef.eventvalue = stringvalue;
  cfg = ft_definetrial(cfg);
  data_trl = ft_redefinetrial(cfg, data);
  
  % Remove artifacts
  cfg = [];
  cfg.artfctdef.summary.artifact = artifact;
  cfg.artfctdef.reject = 'complete';
  data_trl_clean = ft_rejectartifact(cfg, data_trl);
  
  if interactive == true
      % Plot the data
      cfg = [];
      cfg.viewmode = 'vertical';
      cfg.event = event;
      cfg.continuous = 'yes';
      ft_databrowser(cfg, data_trl_clean);
      title('Epoched data with events')
  end
  
  
  %% Launching step2
  
  % wait to close the plot before launching step 2
  disp('======================= Close Plots to continue =======================');
  while ~isempty(get(groot, 'Children'))
    pause(0.2);
  end
    clc;
  disp('======================= Starting Step 2 =======================');
  
  step2_pipeline_A;
  step2_pipeline_B;
  step2_pipeline_C;
  

  step2_pipeline_Z;
  step2_pipeline_Y;
  step2_pipeline_X;
    
  clear artifact
  
end % for subjindx

SavePipelinesToAverage;
SavePipelinesAlreadyAveraged;



