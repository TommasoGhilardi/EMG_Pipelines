function [PipOut] = extractAVG(PipIn)
% extractAVG
%   Fucntion for averaging over participants
%   Thee function find groups muscle and participants and average over the
%   unique combos

[OneGr , t] = findgroups(PipIn(:,1:2));
OneVal      = splitapply(@mean, [PipIn.Corr, PipIn.Zyg], OneGr);
t.Corr = OneVal(:,1);
t.Zyg  = OneVal(:,2);
PipOut = t;

end


