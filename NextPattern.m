% [x]=NextPattern(Input,N,No):
%   [x]=NextPattern(Input,N,No)
%   Read next ith block of image Input by each block size=N
%   return x=input vector = t=target vector           
%
%   Assumed that Image(Input) is power of 2 in both dimentions.

% % veisi@ce.sharif.edu, Dec. 2003


function [x]=NextPattern(Input,N,No)
    tmp=sqrt(N);
    [i,j]=size(Input);
    i=i/tmp;
    j=j/tmp;
    in=fix((No-1)/i)*tmp;
    jn=(mod(No-1,i))*tmp;
    k=1;
    for i=in+1:in+tmp
        for j=jn+1:jn+tmp
            %x(i-in,j-jn)=Input(i,j); 
            x(k,1)=Input(i,j);  %(i-1)*tmp+j
            k=k+1;
        end
    end
      