
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PIPELINE B
% Area under the curve calcualted on baseline[-0.5 0] and trial[0 1.5]s
% Values of AUC exported or
% Values of AUC are normalized dividing trial by baseline
% Values exctracted for corrugator zygomaticus and ratio of the 2

Data_type = 'Raw';
Index = 'AUC';

% Select baseline and data
for i=1:numel(data_trl_clean.trial)
  begsample = nearest(data_trl_clean.time{i}, 0);   % find sample closest to 0
  endsample = nearest(data_trl_clean.time{i}, inf); % find sample closest to inf
  
  baseline_corr(i)  = trapz(data_trl_clean.trial{i}(1,1:begsample-1));
  baseline_zyg(i)   = trapz(data_trl_clean.trial{i}(2,1:begsample-1));
  active_corr(i)    = trapz(data_trl_clean.trial{i}(1,begsample:endsample));
  active_zyg(i)     = trapz(data_trl_clean.trial{i}(2,begsample:endsample));
end

% Divide by baseline
d_emg_corr = active_corr./baseline_corr;
d_emg_zyg  = active_zyg./baseline_zyg;

% Substract baseline
s_emg_corr = active_corr-baseline_corr;
s_emg_zyg  = active_zyg-baseline_zyg;


% map the trials onto condition codes
condition_export = nan(size(data_trl_clean.trialinfo));
condition_export(ismember(data_trl_clean.trialinfo, happy))    = 1;
condition_export(ismember(data_trl_clean.trialinfo, neutral))  = 2;
condition_export(ismember(data_trl_clean.trialinfo, sad))      = 3;


%% Save single subject results 

id_export = repmat(subjindx,length(condition_export),1);

% NotCorrected
data_export_not_corrected = table(id_export, condition_export, active_corr(:),active_zyg(:));
data_export_not_corrected.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

% BaselineCorrected Division
d_data_export = table(id_export, condition_export, d_emg_corr(:), d_emg_zyg(:));
d_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

% BaselineCorrected Substraction
s_data_export = table(id_export, condition_export, s_emg_corr(:), s_emg_zyg(:));
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
clear *sample Data_type