% val=PSNR(Im,Im_hat):
%   Return the value val of Peak-Signal-to-Noise-Ratio(PSNR) in dB for 
%        the image Im and it's compressed version Im_hat,

% Hadi veisi, March 2004

function val=PSNR(Im,Im_hat)

[M,N]=size(Im);
tmp=0;
for i=1:M
    for j=1:N
        tmp=tmp+(double(Im(i,j))-double(Im_hat(i,j)))^2;
    end
end
tmp=tmp/(M*N);
val=10*log10(256^2/tmp);