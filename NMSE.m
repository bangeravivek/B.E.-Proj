% val=NMSE(Im,Im_hat):
%   Return the value val of Normalized-Mean-Square-Error (NMSE)
%        for image Im and it's compressed vertion Im_hat.

%  Hadi veiis, March 2004

function val=NMSE(Im,Im_hat)

[M,N]=size(Im);
tmp1=0;
tmp2=0;
for i=1:M
    for j=1:N
        tmp1=tmp1+(double(Im(i,j))-double(Im_hat(i,j)))^2;
        tmp2=tmp2+double(Im(i,j))^2;
    end
end
val=tmp1/tmp2;