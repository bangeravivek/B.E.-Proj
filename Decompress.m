            % *************************************************
            % ****          Decompress                      ***
            % *************************************************
            
%function  [Dmrg]=Decompress(FileName,Rows,Cols)
    clc;
    clear;
    
    %I=64;               % No. of nerouns in hidden layer
    %H=16;               % No. of nerouns in hidden layer
    [Image,I,H]=ReadParams ;          % Read Parameters     
    [M,N]=size(Image);
    M=M/2;
    N=N/2;
    %file=input('Input and target file(s):','s');
    file=input('Image for decompress: ','s');
    if file==''
        file='Compressed.fig';
        disp('        ++ Default: Compressed.fig');
    end
    fid=fopen(file,'r');
    Img=fscanf(fid,'%f');
    k=1;
    Image=0;
    for i=1:M
        for j=1:N
            Image(i,j)=Img(k);
            k=k+1;
        end
    end
            
    %Image=imread(FileName);
    %[M,N]=size(Image);
  
    No=M*N/H;                           % Number of input blocks
    
    w=ReadFromFile('H2O.wgt',H,I);            % Return weights of network; from hidden to output 
    w_b=ReadFromFile('H2O_B.wgt',I,1);        % Return weights of network; from hidden to output: Bias 

    Dmrg=zeros(2*M,2*N);                 % Decompressed image  

    Time = clock;        % Start execution clock
    disp('Start Decompressing ...');
    for u=1:No
        [x]=NextPattern(Image,H,u);     % Read next block of image(x vector) that the block size=16
        %x=double(x)/256;                % Normalize to [0,1]
        
        y_in=(x'*w)'+w_b;               % Input of output layer
        y=f1(y_in);                     % Output of output layer
        % y is the decompressed data
        
        k=1;
        for i=1: fix(sqrt(I))
            for j=1:fix(sqrt(I))
                tmp(i,j)=y(k);
                k=k+1;
            end
        end
                
        Dmrg=AddPattern(Dmrg,tmp,2*M,2*N,u);
       
    end  %for
 
    disp('Decompressing completed.');
    
    subplot(2,1,1);
    imshow(Image);
    title('Compressed image');
    subplot(2,1,2);
    imshow(uint8(fix(256*Dmrg)));
    title('Decompressed image');
    
    Ttime= etime(clock,Time);           % All time in Sec.
    Thour=fix(Ttime/3600);
    Tmp=round(rem(Ttime,3600));
    Tmin=fix(Tmp/60);
    Tsec=round(rem(Tmp,60));
            % elapsed time
    str=['------------------------------------------'];
    disp(str);
    str=['    +Time: ',int2str(Thour),':',int2str(Tmin),''':',int2str(Tsec),''''''];
    disp(str);