%  3 layer Error BackPropagation (EBP) neural network
%  Train EBP network to compressing image,

%  Hadi veisi
%  14 Dec. 2003

%function Train
clc;
clear;
close all;

            % *************************************************
            % ****          Parameters                      ***
            % *************************************************

format long g            
Time = clock;        % Start execution clock            
%N=64;                % No of Input nerons
%M=N;                 % No of Output nerons
%H=N/2;               % No of Hidden nerons
%NoPatterns=5;        % Number of trainig patterns
[Input,N,H,M,NoPatterns,Err]=ReadParams ;          % Read Parameters            

x(1:N)=0;            % Input trainig vector
t(1:M)=0;            % Output trainig vector
x=x';
t=t';

v=zeros(N,H);        % Input to Hidden weights
w=zeros(H,M);        % Hidden to Output weights

Delta_v=zeros(N,H);
Delta_w=zeros(H,M);

Gamma_k(1:M)=0;       % Error correction weights for Output, Adjacement foe W - Same size with Output size
Gamma_j(1:H)=0;       % Error correction weights for Hidden, Adjacement foe V - Same size with Hidden size
Gamma_k=Gamma_k';
Gamma_j=Gamma_j';

Alpha=0.9;             % Learning rate
v_o(1:H)=0;          % Bias on Hidden
w_o(1:M)=0;          % Bias on Output
v_o=v_o';
w_o=w_o';

Delta_vo(1:H)=0;
Delta_wo(1:M)=0;
Delta_vo=Delta_vo';
Delta_wo=Delta_wo';

z_in(1:H)=0;         % Input of Hidden nerons = v_o+SUM(x*v)
z(1:H)=0;            % Output of Hidden layer = f(z_in)
y_in(1:M)=0;         % Input of Output nerons = w_o+SUM(z*w)
y(1:M)=0;            % Output = f(y_in)
z_in=z_in';
z=z';
y_in=y_in';
y=y';

            % *************************************************
            % ****          Initialization                  ***
            % *************************************************
v=rand(N,H)/10;      % Initial to random small value
w=rand(H,M)/10;        
v_o=v(1,:)';   
w_o=w(1,:)';

% f1 and f1_p are defined as separate functions
Counter=0;
STOP=0;             % Stoping condition flag


            % *************************************************
            % ****          Start training                  ***
            % *************************************************
            
%[v,w,v_b,w_b]=ReadWeights(N,H);      
disp('Satarting training...');

while (STOP~=1)
    Counter=Counter+1
    Input=NextTrainPattern(Counter);   % Learn next image
    for i=1:NoPatterns
        [x]=NextPattern(Input,N,i);    % Read Input(x vector) that is same as appropriate target(t vector)
        x=double(x)/256;               % Normalize to [0,1]
        t=x;                           % Target is same as input
        
                % *************************************************
                % ****          Forward                         ***
                % *************************************************
        z_in=v_o+(x'*v)';     %$$$
        z=f1(z_in);
        
        y_in=w_o+(z'*w)';       %$$$
        y=f1(y_in);
        
                % *************************************************
                % ****          BackPropagatiing error          ***
                % *************************************************
        Gamma_k=(t-y).*f1_p(y_in);          % M*1
        Delta_w=Alpha*z*Gamma_k';           % H*M
        Delta_w0=Alpha*Gamma_k;             % M*1
    
        Gamma_in=w*Gamma_k;                 % H*1
        Gamma_j=Gamma_in.*f1_p(z_in);       % H*1
        Delta_v=Alpha*x*Gamma_j';           % N*H
        Delta_vo=Alpha*Gamma_j;             % H*1
    
                % *************************************************
                % ****           Updating weights               ***
                % *************************************************
        tmp1=max(max(abs(Delta_w)));
        tmp2=max(max(abs(Delta_v)));
        %str=['Delta1= ',int2str(tmp1),'      Delta2= ',int2str(tmp2)];
        %disp(str);
        if  tmp1 < Err
            if tmp2 < Err 
                    STOP=1;
            end
        end
       
         w=w+Delta_w;
         v=v+Delta_v;
        
    end    %for
    
    if (mod(Counter,2000) == 0)
        % Updating learning rate
        if Alpha>0.1
            Alpha=Alpha-0.05;
        end
        
        clc;
        tmp1
        tmp2
        beep on;
        beep;
        beep off;
        Save_w(v,w,'I2H','H2O');
        Save_w(v_o,w_o,'I2H_B','H2O_B');
        
                % *************************************************
                % ****          Time calculations               ***
                % *************************************************

        Ttime= etime(clock,Time);           % All time in Sec.
        Thour=fix(Ttime/3600);
        Tmp=round(rem(Ttime,3600));
        Tmin=fix(Tmp/60);
        Tsec=round(rem(Tmp,60));
        file='Statistics.wgt';
        fid = fopen(file,'w');
        if fid==-1
            disp('Error! cannot create the output file (Statistics.wgt)');
        end
                % Save time
        str=['Trainig time for ',int2str(N),'-',int2str(H),'-',int2str(M),' network and ',int2str(NoPatterns),' input patterns:\n'];
        fprintf(fid,str);
        str=['\t-',int2str(Thour),' hours   \n\t-',int2str(Tmin),' miniutes   \n\t-',int2str(Tsec),' seconds\n'];
        fprintf(fid,str);
                % Save more statistics
        str=['\n>>Number of itrations:  ',int2str(Counter),'\n>>Error rate:  ',num2str(Err)];
        fprintf(fid,str);
        fclose(fid);


        let=input('\nDo you want to contonue (Y/N) ? ','s');
        switch let
        case {'n','N'} 
                beep on;
                beep;
                beep;
                beep;
                disp('Forced to stop training!');
                STOP=1;
                beep off;
            case {'y','Y'} 
                beep on;
                beep;
                beep off;
            otherwise
                disp('Any thing??!');      
            end
    end %if
    
end     %while

disp('Training completed!');   
beep on;
beep;
beep;
beep;
beep;
beep;
beep;
beep off;


Save_w(v,w,'I2H','H2O');
Save_w(v_o,w_o,'I2H_B','H2O_B');

                % *************************************************
                % ****          Time calculations               ***
                % *************************************************

Ttime= etime(clock,Time);           % All time in Sec.
Thour=fix(Ttime/3600);
Tmp=round(rem(Ttime,3600));
Tmin=fix(Tmp/60);
Tsec=round(rem(Tmp,60));
file='Statistics.wgt';
fid = fopen(file,'w');
if fid==-1
    disp('Error! cannot create the output file (Statistics.wgt)');
end
        % Save time
str=['Trainig time for ',int2str(N),'-',int2str(H),'-',int2str(M),' network and ',int2str(NoPatterns),' input patterns:\n'];
fprintf(fid,str);
str=['\t-',int2str(Thour),' hours   \n\t-',int2str(Tmin),' miniutes   \n\t-',int2str(Tsec),' seconds\n'];
fprintf(fid,str);
        % Save more statistics
str=['\n>>Number of itrations:  ',int2str(Counter),'\n>>Error rate:  ',num2str(Err)];
fprintf(fid,str);
fclose(fid);




