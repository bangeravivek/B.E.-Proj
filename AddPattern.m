% Res=AddPattern(Mrg,Add,M,N,I):
%    Merg the blocks of image and return the result
%   adding the Ith block Add to Merg, M*N is the size of final image

% veisi@ce.sharif.edu, Dec. 2003

function Res=AddPattern(Mrg,Add,M,N,I)
    
    t=zeros(M,N);
    [M2,N2]=size(Add);  
       
    in=fix((I-1)*N2/N)*M2;
    jn=(mod((I-1)*N2,N));
   
    for i=in+1:in+N2
        for j=jn+1:jn+N2
            Mrg(i,j)=Add(i-in,j-jn);  
        end
    end 
    Res=Mrg;
