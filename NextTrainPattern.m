% Input=NextTrainPattern(P_Counter);
%   Return the next training pattern

% 
function Input=NextTrainPattern(P_Counter)
    
    tmp=mod(P_Counter,22);
    file='';
    file=['TrainingSet\train (',int2str(tmp),').bmp'];
    Input=imread(file);