
% Save_w(v,w,Name1,Name2)
% Save the trained weights:
%       v=encoder weights(input to hidden layer)
%       w=decoder weights(hidden to output layer)
%
function Save_w(v,w,Name1,Name2)
%    file=input('Output file name for encoding weights:');
%    save file 'v' -ASCII;
    file=Name1;
    file=[file,'.wgt'];
    fid = fopen(file,'w');
    if fid==-1
        disp('Error! cannot create the output file');
        return;
    end
    [M,N]=size(v);
    %str=['The input to hidden layer [',int2str(M),'*',int2str(N),'] :\n\n'];
    %fprintf(fid,str);
    for i=1:M
        for j=1:N
            fprintf(fid,'%10.6f    ',v(i,j));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
    
    %******************************************************************    
    file=Name2;
    file=[file,'.wgt'];
    fid = fopen(file,'w');
    
    if fid==-1
        disp('Error! cannot create the output file');
        return;
    end
    
    [M,N]=size(w);
    %str=['The hidden to output layer [',int2str(M),'*',int2str(N),'] :\n\n'];
    %fprintf(fid,str);
    for i=1:M
        for j=1:N
            fprintf(fid,'%10.6f    ',w(i,j));
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
