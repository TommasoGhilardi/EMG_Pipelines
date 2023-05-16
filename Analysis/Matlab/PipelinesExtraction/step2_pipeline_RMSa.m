
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PIPELINE Z
% Averaged 
% Root Mean Square calcualted on baseline[-0.5 0] and trial[0 1.5]s
% Values of RMS exported or
% Values of RMS are normalized dividing trial by baseline or
% Values of RMS are normalized subtracting baseline from trial
% Values exctracted for corrugator zygomaticus and ratio of the 2

Data_type = 'Average';
Index = 'RMS';

rms = @(x) sqrt(mean(x.^2,2)); % root mean square formula


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

    baseline_corr = rms(Avg(Emo).trial{:}(1, 1:begsample-1,:));
    active_corr = rms(Avg(Emo).trial{:}(1 ,begsample:endsample));

    baseline_zyg = rms(Avg(Emo).trial{:}(2, 1:begsample-1,:));
    active_zyg = rms(Avg(Emo).trial{:}(2 ,begsample:endsample));

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

% BaselineCorrected Division
d_data_export = table(id_export, condition_export(:), d_emg_corr(:), d_emg_zyg(:));
d_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

% BaselineCorrected Substraction
s_data_export = table(id_export, condition_export(:), s_emg_corr(:), s_emg_zyg(:));
s_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

% Add to structure
if isfield( Pipelines.(Data_type), Index)    
    
    Pipelines.(Data_type).(Index)(1).data = [Pipelines.(Data_type).(Index)(1).data; data_export_not_corrected];
    Pipelines.(Data_type).(Index)(2).data = [Pipelines.(Data_type).(Index)(2).data; d_data_export];
    Pipelines.(Data_type).(Index)(3).data = [Pipelines.(Data_type).(Index)(3).data; s_data_export];
  
else
        
    Pipelines.(Data_type).(Index)(1).data = data_export_not_corrected;
    Pipelines.(Data_type).(Index)(1).BaselineCorrection = '0';

    Pipelines.(Data_type).(Index)(2).data = d_data_export;
    Pipelines.(Data_type).(Index)(2).BaselineCorrection = 'D';

    Pipelines.(Data_type).(Index)(3).data = s_data_export;
    Pipelines.(Data_type).(Index)(3).BaselineCorrection = 'S';
    
    [Pipelines.(Data_type).(Index).MuscleStandadization] = deal('0','0','0');
    [Pipelines.(Data_type).(Index).SubjectStandadization] = deal('0','0','0');

end


clear *_corr
clear *_zyg
clear *_ratio
clear *export*
clear *sample Pipeline_name Avg






