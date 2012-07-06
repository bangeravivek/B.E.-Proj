% val=SNR(Im,Im_hat)
%   Return the value val of Signal-to-Noise-Ratio(SNR)in dB 
%        for image Im and it's compressed vertion Im_hat.

%  Hadi veiis, March 2004

function val=SNR(Im,Im_hat)

tmp=NMSE(Im,Im_hat);
val=-10*log10(tmp);