% [Out]=ReadFromFile(FileName,Rows,Cols):
%   Read Rows*Cols data from FileName and return in Out,

% veisi@ce.sharif.edu, Dec. 2003

function [Out]=ReadFromFile(FileName,Rows,Cols)
    fid = fopen(FileName,'r+');
    Out=fscanf(fid,'%f');
    fclose(fid);

    tmp=zeros(Rows,Cols);
    k=1;
    for i=1:Rows
        for j=1:Cols
            tmp(i,j)=Out(k);
            k=k+1;
        end
    end
    Out=tmp;
    