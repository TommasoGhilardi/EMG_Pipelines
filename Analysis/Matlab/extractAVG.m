function [PipOut] = extractAVG(PipIn)
% extractAVG
%   Fucntion for averaging over participants
%   For each data in PipIn the function find groups of participants
%   and zscore usign the grouping


for X =  1:numel(PipIn)

    [OneGr , t] = findgroups(PipIn{X}(:,1:2));
    OneVal      = splitapply(@mean, [PipIn{X}.Corr, PipIn{X}.Zyg], OneGr);
    t.Corr = OneVal(:,1);
    t.Zyg  = OneVal(:,2);
    PipOut{X} = t;
end

end


