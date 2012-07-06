function [J K sumed]=vqmain(I, Codesize)

%  I=imread('cameraman.tif');

% Codesize=32; %Codebook size
% [r col]=size(I);
% I=im2col(I,[16 16],'distinct');
% figure, imshow(I); title('Rearranged');
[m, p, DistHist]=vqsplit(I,Codesize);
% m=uint8(m);
% I=uint8(I);
[row column]=size(m)
[r col]=size(I);


%THE ENCODING PROCESS

J=[];
I=double(I);
for i=1:col
    dmin=99999999999999999;
    index=0;
    for j=1:column
        sum1=0;
        B=I(:,i);
        D=(m(:,j));
        C=B-D;
        C=C.^2;
        sum1=sum(C);
        
        
        %for k=1:row
        %    
         % temp=((I(k,i)-m(k,j)))%*(I(k,i)-m(k,j)))
         %   sum1=sum1+temp
        %end
        if(sum1<dmin)
            dmin=sum1;
            index=j;
        end
    end
    J=[J index];
end

J;


% DECODING

K=[];
for i=1:col
    temp=m(:,J(i));
    K=[K temp];
end
K;


% % % figure,imshow(I);
% % % images=uint8(K);
% % % figure, imshow(images);
% % 
% % %---------------ERROR CODEBOOK----------------%
% % %loop start
% % 
%------ LOGIC OUTLINE--------%
%{
Instead of running straight vector quantization on error codebook
let us select those columns in the error codebook which when added
to most of the colums in the reconstructed image bring us closer
to the original image.

The other way is we generate such columns that when added to the
reconstructed image take us closer to the original image
%}

% if(Codesize>=32)
%     Codesize=32;
% end

% for loop=1:1
%     Errors=int8(I-K);
% 
% %     without_quant=K+double(Errors);
% %     figure, imshow(uint8(without_quant));
% 
% %     [E_row E_column]=size(Errors);
% %     for inside=1:E_row
% %         for insider=1:E_column
% %             if Errors(inside,insider)>20 && Errors(inside,insider)<-20
% %                 Errors(inside,insider)=0;
% %             end
% %         end
% %     end
% %     
%     %     Errors1=Errors>20;
% %     Errors2=Errors<-20;
% %     Errors=Errors1+Errors2;
% %     figure, imshow(uint8(Errors)); title('Errors');
%     [E_m, E_p, E_DistHist]=vqsplit(Errors,Codesize);
% 
%     [E_row E_column]=size(E_m);
%     [E_r E_col]=size(Errors);
% 
% %     str=['Max error value=',int8(max(E_m)),' Min value=',int8(min(E_m))];
% %     disp(str);
% %THE ENCODING PROCESS
% 
%     E_J=[];
%     Errors=double(Errors);
%     for i=1:E_col
%         dmin=99999999999999999;
%         index=0;
%         for j=1:E_column
%             sum1=0;
%             B=Errors(:,i);
%             D=(E_m(:,j));
%             C=B-D;
%             C=C.^2;
%             sum1=sum(C);
%         
%         
%         %for k=1:row
%         %    
%          % temp=((I(k,i)-m(k,j)))%*(I(k,i)-m(k,j)))
%          %   sum1=sum1+temp
%         %end
%             if(sum1<dmin)
%                 dmin=sum1;
%                 index=j;
%             end
%         end
%         E_J=[E_J index];
%     end
%     
%     E_K=[];
%     for i=1:col
%         temp=E_m(:,E_J(i));
%         E_K=[E_K temp];
%     end
%     
%     
% % E_K=int8(E_K);
% %     figure,imshow(E_K); title('Quantized error image');
% 
% % K=K+double(Errors);
%     K=K+E_K;
%     %K=mod(K,255);
%     images=(K/255);
% %   figure, imshow(images); title('Errors+reconstruscted');
%  end
% %/loop end

% counter=zeros(1,Codesize);
% length=size(J,2);
% for i=1:length
%     a=J(1,i);
%     J(i);
%     counter(J(i))=counter(J(i))+1;
% end
% 
% sum(counter)
% 
% probs=zeros(1,Codesize);
% length2=size(counter,2);
% for i=1:length2
%     probs(i)=counter(i)/length;
% end
% 
%     
% a=sort(probs, 'descend');
% a=a';
% 
% symbols=[1:Codesize];
% [dict,avglen] = huffmandict(symbols,probs); % Create dictionary.
% comp = huffmanenco(J',dict); % Encode the data.

comp=hamming(J,Codesize);
% comp2=hamming(E_J,Codesize);
% a=size(comp,1)
% size(comp,2)
sumed=size(comp,1);%+size(comp2,1);



% 
% 
% K=im2col(K,[16 16],'distinct');
% I=im2col(I,[16 16],'distinct');
% figure, imshow(uint8(K)); title('Does it work?')
% figure, imshow(uint8(I)); title('Original work')





%Calculating bit size of indices

bit_size=0;
i=Codesize;
while i>1
    bit_size=bit_size+1;
    i=i/2;
end
bit_size
%{
numbers=size(J,2);
numbers
summer=0;
for i=1:numbers
    if (J(i)<2)
        summer=summer+1;
    elseif (J(i)<4)
        summer=summer+2;
    elseif (J(i)<8)
        summer=summer+3;
    elseif (J(i)<16)
        summer=summer+4;
    elseif (J(i)<32)
        summer=summer+5;
    elseif (J(i)<64)
        summer=summer+6;
    elseif (J(i)<128)
        summer=summer+7;
    elseif (J(i)<256)
        summer=summer+8;
        
    end
end
%}

summer=bit_size*col*2
% [row col]=size(m);
total=row*column*8*2
bpl2=(sumed+total)/(r*col)
Dist=double(K)-I;

Dist=Dist.^2;
distsum=sum(sum(Dist));
MeanError=(distsum)/(r*col)

%PSNR
PSNR=10*log10((255*255)/MeanError);
PSNR

p;

