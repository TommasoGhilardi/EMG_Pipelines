
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PIPELINE X
% Trials are averaged 
% Average calcualted on baseline[-0.5 0] and trial[0 1.5]s
% Values exctracted for corrugator zygomaticus

Pipeline_name = 'X';

%% Average over repetition
cfg = [];
cfg.avgoverrpt =  'yes';

cfg.trials = ismember(data_trl_clean.trialinfo, happy);
Avg(1) =  ft_selectdata(cfg, data_trl_clean);

cfg.trials = ismember(data_trl_clean.trialinfo, neutral);
Avg(2) =  ft_selectdata(cfg, data_trl_clean);

cfg.trials = ismember(data_trl_clean.trialinfo, sad);
Avg(3) =  ft_selectdata(cfg, data_trl_clean);


%% Exrtact data

for Emo =  1:numel(Avg)
   
    begsample = nearest(Avg(Emo).time{:}, 0);   % find sample closest to 0
    endsample = nearest(Avg(Emo).time{:}, inf); % find sample closest to inf

    baseline_corr = mean(Avg(Emo).trial{:}(1, 1:begsample-1,:));
    active_corr = mean(Avg(Emo).trial{:}(1 ,begsample:endsample));

    baseline_zyg = mean(Avg(Emo).trial{:}(2, 1:begsample-1,:));
    active_zyg = mean(Avg(Emo).trial{:}(2 ,begsample:endsample));

    emg_corr(Emo) = active_corr;
    emg_zyg(Emo) = active_zyg;
    
    % Divide by baseline
    d_emg_corr(Emo) = active_corr/baseline_corr;
    d_emg_zyg(Emo)  = active_zyg/baseline_zyg;

    % Substract baseline
    s_emg_corr(Emo) = active_corr-baseline_corr;
    s_emg_zyg(Emo)  = active_zyg-baseline_zyg;    

end


%% Save single subject results 

id_export = repmat(subjindx,length(Avg),1);
condition_export = 1:3;

% NotCorrected
data_export_not_corrected = table(id_export, condition_export(:), emg_corr(:),emg_zyg(:));
data_export_not_corrected.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

if exist('PipelineX', 'var')
    PipelineX  = [ PipelineX; data_export_not_corrected ];
else
    PipelineX = data_export_not_corrected;
end


% BaselineCorrected Division
d_data_export = table(id_export, condition_export(:), d_emg_corr(:), d_emg_zyg(:));
d_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

if exist('PipelineX1', 'var')
    PipelineX1  = [ PipelineX1; d_data_export ];
else
    PipelineX1 = d_data_export;
end


% BaselineCorrected Substraction
s_data_export = table(id_export, condition_export(:), s_emg_corr(:), s_emg_zyg(:));
s_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

if exist('PipelineX2', 'var')
    PipelineX2  = [ PipelineX2; s_data_export ];
else
    PipelineX2 = s_data_export;
end


clear *_corr
clear *_zyg
clear *_ratio
clear *export*
clear *sample Pipeline_name Avg






