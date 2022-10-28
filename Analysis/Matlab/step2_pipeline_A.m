
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PIPELINE A
% Root Mean Square calcualted on baseline[-0.5 0] and trial[0 1.5]s
% Values of RMS exported or
% Values of RMS are normalized dividing trial by baseline or
% Values of RMS are normalized subtracting baseline from trial
% Values exctracted for corrugator zygomaticus and ratio of the 2

Pipeline_name = 'A';
rms = @(x) sqrt(mean(x.^2)); % root mean square formula

% Select baseline and data
for i=1:numel(data_trl_clean.trial)
  begsample = nearest(data_trl_clean.time{i}, 0);   % find sample closest to 0
  endsample = nearest(data_trl_clean.time{i}, inf); % find sample closest to inf
  baseline_corr(i)  = rms(data_trl_clean.trial{i}(1,1:begsample-1));
  baseline_zyg(i)   = rms(data_trl_clean.trial{i}(2,1:begsample-1));
  active_corr(i)    = rms(data_trl_clean.trial{i}(1,begsample:endsample));
  active_zyg(i)     = rms(data_trl_clean.trial{i}(2,begsample:endsample));
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


%% Plot EMG 
% if interactive is true show a plot for each subject

if interactive == true
    clf;
    figure('WindowState', 'maximized'); % make figure fullscreen

    if  contains(path,'gramm') % fancy plot

        % corrugator and zygomaticus
        xlabel = {'happy', 'neutral', 'sad'};
        clabel = {'corr', 'zyg'};
        x = [condition_export; condition_export];
        y = [emg_corr; emg_zyg];
        c = [ones(size(emg_corr)); 2*ones(size(emg_zyg))];  
        g(1,1) = gramm('x',xlabel(x),'y',y,'color',clabel(c));
        g(1,1).stat_violin('fill','transparent');
        g(1,1).set_names('x','Emotion');
        g(1,1).set_title('Distribution zygomaticus and corrugator');

        % ratio
        xlabel = {'happy', 'neutral', 'sad'};
        x = [condition_export];
        y = [emg_ratio];
        g(1,2) = gramm('x',xlabel(x),'y',y);
        g(1,2).stat_violin('fill','transparent');
        g(1,2).set_title('Distribution ratio');
        g(1,2).set_names('x','Emotion');
        g(1,2).set_color_options('map','matlab','lightness',8);
        g.draw()
        clear *label
        clear g x y c
     
    else    % simple plot
        p1 = subplot(2,1,1); hold on
        plot(condition_export+0.2, emg_corr, 'r.')
        plot(condition_export+0.3, emg_zyg, 'b.')
        set(gca,'XTick',1.25:3.25,'XTickLabel', {'Happy','Neutral','Sad'})
        legend({'corr', 'zyg'})
        p1.XLabel.String = 'Emotion';

        p2 = subplot(2,1,2);
        plot(condition_export+0.25, emg_ratio, 'm.')
        set(gca  ,'XTick',1.25:3.25,'XTickLabel', {'Happy','Neutral','Sad'})
        p2.XLabel.String = 'Emotion';
        clear p1 p2
    end
    
    % wait to close the plot
    disp('======================= Close Plots to continue =======================');
    while ~isempty(get(groot, 'Children'))
        pause(0.2)
    end
    clc;
    disp('======================= Next =======================');
end


%% Save single subject results 

id_export = repmat(subjindx,length(condition_export),1);

% NotCorrected
data_export_not_corrected = table(id_export, condition_export, active_corr(:),active_zyg(:));
data_export_not_corrected.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

% Save table
writetable(data_export_not_corrected,[outputdir '\' sprintf('sub-P%04d', subjindx) '\' Preprocessing Pipeline_name '.csv'])

if exist('PipelineA', 'var')
    PipelineA  = [ PipelineA; data_export_not_corrected ];
else
    PipelineA = data_export_not_corrected;
end


% BaselineCorrected Division
d_data_export = table(id_export, condition_export, d_emg_corr(:), d_emg_zyg(:));
d_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

if exist('PipelineA1', 'var')
    PipelineA1  = [ PipelineA1; d_data_export ];
else
    PipelineA1 = d_data_export;
end


% BaselineCorrected Substraction
s_data_export = table(id_export, condition_export, s_emg_corr(:), s_emg_zyg(:));
s_data_export.Properties.VariableNames = {'Id' 'Emotion' 'Corr' 'Zyg'};

if exist('PipelineA2', 'var')
    PipelineA2  = [ PipelineA2; s_data_export ];
else
    PipelineA2 = s_data_export;
end


clear *_corr
clear *_zyg
clear *_ratio
clear *export*
clear *sample Pipeline_name