% Save_res(Vec,Fname):
%   Save the trained weights:
%       Vec=  Data
%       Fname=Output file name
%
% veisi@ce.sharif.edu, Dec. 2003

function Save_res(Vec,Fname)

    No=length(Vec);
    if No~=length(Fname)
        disp('Error! Number of data and output file name should be same.');
        return;
    end
    
    for i=1:No
        Data=Vec(i);
        file=Fname(i);
        file=[file,'.wgt'];
        fid = fopen(file,'w');
        if fid==-1
            disp('Error! cannot create the output file');
            return;
        end
        [M,N]=size(Data);
        
        %fprintf(fid,'The input to hidden layer:\n\n    ');
        for i=1:M
            for j=1:N
                fprintf(fid,'%6.2f    ',Data(i,j));
            end
            fprintf(fid,'\n');
        end
    
        fclose(fid);
    
    end %for
