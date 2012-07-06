
            % *************************************************
            % ****          Compress                        ***
            % *************************************************
clc;
clear;
%function Compress

    %I=64;                       % Number of nerons in Input and output layer
    %H=16;                       % Number of nerons in hidden layer
    [Image,I,H]=ReadParams ;          % Read Parameters     
    
    %file=input('Input and target file(s):','s');
   
    Image=imread('cameraman.tif');
    [M,N]=size(Image);
    No=M*N/I;                           % Number of input blocks
    
    [v,w,v_b,w_b]=ReadWeights(I,H);     % Return weights of network 64_16_64

    mrg=zeros(M/2,N/2);                 % Compressed image  
    disp('Start compressing ...');
    for u=1:No
        [x]=NextPattern(Image,I,u);     % Read next block of image(x vector) that the block size=64
        x=double(x)/256;                % Normalize to [0,1]
        
        h_in=(x'*v)'+v_b;                  % Input of hidden layer
        h=f1(h_in);                     % Output of hidden layer
        % h is the compressed data
        
        k=1;
        for i=1: fix(sqrt(H))
            for j=1:fix(sqrt(H))
                tmp(i,j)=h(k);
                k=k+1;
            end
        end
                
        mrg=AddPattern(mrg,tmp,M/2,N/2,u);
        
       % y_in=w'*h+w_b;                  % Input of output layer
       % y=f1(y_in);                     % Output of output layer
    end
 
    disp('Compressing completed.');
    
    subplot(2,1,1);
    imshow(Image);
    title('Original image');
    subplot(2,1,2);
    imshow(uint8(fix(256*mrg)));
    title('Compressed image')
    
    %file='Compressed.fig';
    %fid = fopen(file,'w');
    %if fid==-1
    %    disp('Error! cannot create the output file');
    %end
    str=['------------------------------------------'];
    disp(str);
    save Compressed.fig mrg -ASCII;
    disp('Saved compressed image in Compressed.fig');
    %fclose(fid);
    
    