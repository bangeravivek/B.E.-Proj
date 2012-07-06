function [mrg Dmrg]=SOFM(image)
% veisi@ce.sharif.edu, March 2004

            % *************************************************
            % ****          Compress/Decompress             ***
            % *************************************************
% clc;
% clear all;
% close all;
%function Codec

    [Image,I,H]=ReadParams ;          % Read Parameters            

%    I=64;                      % Number of nerons in Input and output layer
%    H=16;                      % Number of nerons in hidden layer
    Sqrt_H=fix(sqrt(H));        % Input and Output Block size:  Sqrt_H* Sqrt_H        
    Sqrt_I=fix(sqrt(I));        % Compressed Block size:  Sqrt_I* Sqrt_I

    Time = clock;        % Start execution clock
    
%     file=input('Image for compress/decompress: ','s');
%     if strcmp(file,'')
%         file='lena.bmp';
%         disp('        ++ Default: lena.bmp');
%     end
    Image=image;
    [M,N]=size(Image);
    
    No=M*N/I;                           % Number of input blocks
    
    [v,w,v_b,w_b]=ReadWeights(I,H);     % Return weights of network 64_16_64

    mrg=zeros(M/2,N/2);                 % Compressed image  
    Dmrg=zeros(M,N);                    % Decompressed image  
    
    disp('Start compressing/Decompressing ...');
    for u=1:No
        [x]=NextPattern(Image,I,u);     % Read next block of image(x vector) that the block size=64
%         x=double(x)/256;                % Normalize to [0,1]
        
        h_in=(x'*v)'+v_b;               % Input of hidden layer
        h=f1(h_in);                     % Output of hidden layer
        % h is the compressed data
        
        k=1;
        for i=1:  Sqrt_H
            for j=1: Sqrt_H
                tmp(i,j)=h(k);
                k=k+1;
            end
        end
                
        mrg=AddPattern(mrg,tmp,M/2,N/2,u);
        
        y_in=w_b+(h'*w)';                  % Input of output layer
        y=f1(y_in);                     % Output of output layer
        % y is decompressed data
        k=1;
        for i=1: Sqrt_I
            for j=1: Sqrt_I
                tmp(i,j)=y(k);
                k=k+1;
            end
        end
        Dmrg=AddPattern(Dmrg,tmp,M,N,u);
        clear tmp;
    end
        
    disp('Codec completed.');
     Dmrg=Dmrg*256;
     mrg=mrg*256;
    
    % *************************************************
    % ****             Outputs                      ***
    % *************************************************
   % Compute the PSNR
    Psnr=PSNR(Image,Dmrg);
    snr=SNR(Image,Dmrg);
    nmse=NMSE(Image,Dmrg);

    
    % Computing Bit rate
%    BitRate(BlockSize,NoOfBlocks,NoOfHiddenNeroun,NoOfBitsOut,NoOfBitsWeight)
    NoOfBitsOut=8;
    NoOfBitsWeight=8;
    Bitrate=BitRate(I,No,H,NoOfBitsOut,NoOfBitsWeight);
    
    str=['------------------------------------------'];
    disp(str);
    str=['    + PSNR= ',num2str(Psnr),' dB'];
    disp(str);
    str=['    + SNR= ',num2str(snr),' dB'];
    disp(str);
    str=['    + NMSE= ',num2str(nmse)];
    disp(str);
    str=['    + Bit rate(all)= ',num2str(Bitrate),' bpp'];
    disp(str);
    str=['    + Bit rate(CR)= ',num2str(H/I),' bpp'];
    disp(str);
    disp(' ')
     
%    subplot(3,1,1);
    figure, imshow(Image), title('Original image');
 %   subplot(3,1,2);
    figure, imshow(uint8(fix(mrg))), title('Compressed image');
 %   subplot(3,1,3);
    figure, imshow(uint8(fix(Dmrg))), title('1/4 Decompressed image');
    
%     Dmrg=uint8(fix(Dmrg));
    
    Ttime= etime(clock,Time);           % All time in Sec.
    Thour=fix(Ttime/3600);
    Tmp=round(rem(Ttime,3600));
    Tmin=fix(Tmp/60);
    Tsec=round(rem(Tmp,60));
            % elapsed time
    str=['    + Time: ',int2str(Thour),':',int2str(Tmin),''':',int2str(Tsec),''''''];
    disp(str);
    str=['------------------------------------------'];
    disp(str);

    
