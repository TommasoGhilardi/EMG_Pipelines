
% Run standardizaition for both Raw and Average data

data_types =  fieldnames(Pipelines);
for typeN = 1:2

    % Run standardization for each index type
    indexes = fieldnames(Pipelines.(data_types{typeN}));
    for indexN  = 1:3

        copy = Pipelines.(data_types{typeN}).(indexes{indexN});  
        
        % z-score within mucle
        out{1}  = Zscoring(copy,1);
        [out{1}.MuscleStandadization] = deal('M','M','M');

        % z-score within subject
        out{2} = Zscoring(copy,'all');
        [out{2}.SubjectStandadization] = deal('S','S','S');

        % z-score with muscle and subject
        out{3} = Zscoring(copy,1);
        out{3} = Zscoring(out{3},'all');
        [out{3}.MuscleStandadization] = deal('M','M','M');
        [out{3}.SubjectStandadization] = deal('S','S','S');

        % add to structure
        Pipelines.(data_types{typeN}).(indexes{indexN}) = [Pipelines.(data_types{typeN}).(indexes{indexN}), out{1},out{2},out{3}];
        clear out copy
    end

end


%% Save the pipelines to single files

% For each data type
data_types =  fieldnames(Pipelines);
for typeN = 1:2

    % For each index 
    indexes = fieldnames(Pipelines.(data_types{typeN}));
    for indexN  = 1:3
        
        % Save each pipeline
        for pip = 1:length(Pipelines.(data_types{typeN}).(indexes{indexN}))
                        
            name = [ data_types{typeN}(1),'_',indexes{indexN} ,'_'...
                Pipelines.(data_types{typeN}).(indexes{indexN})(pip).BaselineCorrection,...
                Pipelines.(data_types{typeN}).(indexes{indexN})(pip).MuscleStandadization,...
                Pipelines.(data_types{typeN}).(indexes{indexN})(pip).SubjectStandadization,...
                '.csv'];
            
            % Extract average from pipelins in which the index was
            % calculcate on each trial
            if data_types{typeN} == "Raw"
                data_out =  extractAVG(Pipelines.(data_types{typeN}).(indexes{indexN})(pip).data);
            elseif data_types{typeN} == "Average"
                data_out = Pipelines.(data_types{typeN}).(indexes{indexN})(pip).data;   
            end
            
            writetable(data_out, fullfile(outputdir,'Pipelines', name))
            
            clear name data_out
        end
        
    end

end



