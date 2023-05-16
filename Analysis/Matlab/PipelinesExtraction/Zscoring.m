function [PipOut] = Zscoring(PipIn,over)
% Zscoring
%   Fucntion for zscoring over muscle or participants
%   For each data in PipIn the function find groups of participants
%   and zscore usign the grouping
%   - passing 1 zscores over the columns (the muscles);
%   - passing 'all' use all the values passed


functn = @(x1){zscore(x1,0,over)};
for X =  1:numel(PipIn)
    
    [Z] = findgroups(PipIn(X).data(:,1));
    norm = splitapply(functn, [PipIn(X).data.Corr,PipIn(X).data.Zyg], Z);
    
    out = cell2mat(norm);

    PipOut(X) = PipIn(X);
    PipOut(X).data.Corr = out(:,1);
    PipOut(X).data.Zyg = out(:,2);

    clear out
end

end
