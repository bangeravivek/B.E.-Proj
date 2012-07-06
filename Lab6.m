
clc;
clear all;
close all;
% [filen,pathnamen]=uigetfile('*.tif','Original Image',50,50);
% [newsubtiffile, newsubpath] = ...
%   uiputfile('*.tif', 'Save Subband Image As');
% [newtiffile, newpath] = ...
%   uiputfile('*.tif', 'Save Reconstructed Subband Image As');

% Load original image.
[X,map]=imread('goldhill.png');
X = double(X);
sX=size(X);
% X contains the loaded image and
% map contains the loaded colormap.
row = sX(1);
col = sX(2);

% Image coding
%nbcol = size(map,1);
% hard code the nbcol to 255
nbcol = 255;
cod_X = wcodemat(X,nbcol);

% Perform one step decomposition
% of X using haar.
[ca1,chd1,cvd1,cdd1] = dwt2(X,'haar');

[row_img_1 col_img_1]=size(ca1);
% Images coding.
cod_ca1 = wcodemat(ca1,nbcol);
cod_chd1 = wcodemat(chd1,nbcol);
cod_cvd1 = wcodemat(cvd1,nbcol);
cod_cdd1 = wcodemat(cdd1,nbcol);
dec2d = [...
      cod_ca1, cod_chd1;...
      cod_cvd1, cod_cdd1 ...
];

img1=[...
      ca1, chd1;...
      cvd1, cdd1 ...
];

figure,imshow(img1);

% Visualize the coefficients fo the decomposition
% at level 1.
figure,imshow(X/max(max(X)))
%figure,imshow(dec2d/max(max(dec2d)))
figure,imshow(dec2d/255)

% imwrite(dec2d/(max(max(dec2d))),[newsubpath,newsubtiffile],'tif');

% Perform second step decomposition;
% decompose approx. cfs of level 1.
[ca2,chd2,cvd2,cdd2] = dwt2(ca1,'haar');

[row_img_2 col_img_2]=size(ca2);
% Invert directly decomposition of X
% using coefficients at level 1.
a0 = idwt2(ca1,chd1,cvd1,cdd1,'haar',sX);

figure,imshow(a0/max(max(a0)));

% Perform decompositon at level 2
% of X using haar.
[c,s] = wavedec2(X,2,'haar');
subchip = [...
      ca2, chd2;...
      cvd2,cdd2...
   ];
heirchip = [...
      subchip, cod_chd1;...
      cod_cvd1, cod_cdd1 ...
];
%figure,imshow(heirchip/max(max(heirchip)))
figure,imshow(heirchip/255)

ca2new = (ca2/max(max(ca2)))*255;
% chd2new = chd2+128;
% cvd2new = cvd2+128;
% cdd2new = cdd2+128;
chd2new = chd2;
cvd2new = cvd2;
cdd2new = cdd2;
subchip = [...
      ca2new,chd2new;...
      cvd2new,cdd2new ...
];
cod_chd1new = cod_chd1+128;
cod_cvd1new = cod_cvd1+128;
cod_cdd1new = cod_cdd1+128;
heirchip = [...
      subchip,cod_chd1new;...
      cod_cvd1new, cod_cdd1new ...
   ];
% figure,imshow(heirchip/max(max(heirchip)))
figure,imshow(heirchip/255)

cod_ca2 = wcodemat(ca2,nbcol);
cod_chd2 = wcodemat(chd2,nbcol);
cod_cvd2 = wcodemat(cvd2,nbcol);
cod_cdd2 = wcodemat(cdd2,nbcol);

% Performing decomposition at level 3
[ca3,chd3,cvd3,cdd3] = dwt2(ca2,'haar');

 [row_img_3 col_img_3]=size(ca3);

ca3new = (ca3/max(max(ca3)))*255;
chd3new = chd3+128;
cvd3new = cvd3+128;
cdd3new = cdd3+128;
subchip1 = [...
      ca3new,chd3new;...
      cvd3new,cdd3new ...
];
cod_chd2new = cod_chd2+128;
cod_cvd2new = cod_cvd2+128;
cod_cdd2new = cod_cdd2+128;
heirchip1 = [...
      subchip1,cod_chd2new;...
      cod_cvd2new, cod_cdd2new ...
   ];

heirchip2 = [...
      heirchip1,cod_chd1new;...
      cod_cvd1new, cod_cdd1new ...
   ];
% figure,imshow(heirchip/max(max(heirchip)))
figure,imshow(heirchip2/255);

subchip2 = [...
      ca3,chd3;...
      cvd3,cdd3 ...
];

heirchip12 = [...
      subchip2,chd2;...
      cvd2, cdd2 ...
   ];

heirchip22 = [...
      heirchip12,chd1;...
      cvd1, cdd1 ...
   ];

figure, imshow(uint8(heirchip22)); title('To be quantized');

%Enter Vector Quantization here




ca4=idwt2(ca3, chd3, cvd3, cdd3, 'haar');

figure, imshow(ca4/255);



%------------------Separate codebook for all sub bands--------------------
% codesize=16;
% 
% [img_enc_3_1 img_dec_3_1 hamming1]=vqmain(ca3,codesize*2);
% [img_enc_3_2 img_dec_3_2 hamming2]=vqmain(chd3,codesize);
% [img_enc_3_3 img_dec_3_3 hamming3]=vqmain(cvd3,codesize);
% [img_enc_3_4 img_dec_3_4 hamming4]=vqmain(cdd3,codesize);
% [img_enc_2_2 img_dec_2_2 hamming5]=vqmain(chd2,codesize/2);
% [img_enc_2_3 img_dec_2_3 hamming6]=vqmain(cvd2,codesize/2);
% [img_enc_2_4 img_dec_2_4 hamming7]=vqmain(cdd2,codesize/2);
% [img_enc_1_2 img_dec_1_2 hamming8]=vqmain(chd1,codesize/2);
% [img_enc_1_3 img_dec_1_3 hamming9]=vqmain(cvd1,codesize/2);
% [img_enc_1_4 img_dec_1_4 hamming10]=vqmain(cdd1,codesize/2);
% 
% sum_of_bits=hamming1+hamming2+hamming3+hamming4+hamming5+hamming6+hamming7+hamming8+hamming9+hamming10
% % ------ For SOFM-------%
% 
% % [img_enc_3_1 img_dec_3_1]=SOFM(uint8(ca3));
% % [img_enc_3_2 img_dec_3_2]=SOFM(uint8(chd3));
% % [img_enc_3_3 img_dec_3_3]=SOFM(uint8(cvd3));
% % [img_enc_3_4 img_dec_3_4]=SOFM(uint8(cdd3));
% % [img_enc_2_2 img_dec_2_2]=SOFM(uint8(chd2));
% % [img_enc_2_3 img_dec_2_3]=SOFM(uint8(cvd2));
% % [img_enc_2_4 img_dec_2_4]=SOFM(uint8(cdd2));
% % [img_enc_1_2 img_dec_1_2]=SOFM(uint8(chd1));
% % [img_enc_1_3 img_dec_1_3]=SOFM(uint8(cvd1));
% % [img_enc_1_4 img_dec_1_4]=SOFM(uint8(cdd1));
% 
% % encoded image
% % 
% % e_subchip22 = [...
% %       img_enc_3_1,img_enc_3_2;...
% %       img_enc_3_3,img_enc_3_4 ...
% % ];
% % 
% % e_heirchip212 = [...
% %       e_subchip22,img_enc_2_2;...
% %       img_enc_2_3, img_enc_2_4 ...
% %    ];
% % 
% % img_enc = [...
% %       e_heirchip212,img_enc_1_2;...
% %       img_enc_1_3, img_enc_1_4 ...
% %    ];
% % 
% % figure, imshow(img_enc);
% 
% subchip22 = [...
%       img_dec_3_1,img_dec_3_2;...
%       img_dec_3_3,img_dec_3_4 ...
% ];
% 
% heirchip212 = [...
%       subchip22,img_dec_2_2;...
%       img_dec_2_3, img_dec_2_4 ...
%    ];
% 
% img_dec = [...
%       heirchip212,img_dec_1_2;...
%       img_dec_1_3, img_dec_1_4 ...
%    ];
% % img_dec=img_dec-64;
% 
% %level 3 images
% 
% ca_3_1=img_dec(1:row_img_3, 1:col_img_3);
% ch_3_1=img_dec(1:row_img_3, col_img_3+1:col_img_3+col_img_3);
% cv_3_1=img_dec(row_img_3+1:row_img_3+row_img_3, 1:col_img_3);
% cd_3_1=img_dec(row_img_3+1:row_img_3+row_img_3, col_img_3+1:col_img_3+col_img_3 );
% 
% figure, imshow(ca_3_1/255);
% 
% % level 2 images
% 
% ca_2_1=idwt2(ca_3_1,ch_3_1,cv_3_1,cd_3_1, 'haar');
% ch_2_1=img_dec(1:row_img_2, col_img_2+1:col_img_2+col_img_2);
% cv_2_1=img_dec(row_img_2+1:row_img_2+row_img_2, 1:col_img_2);
% cd_2_1=img_dec(row_img_2+1:row_img_2+row_img_2, col_img_2+1:col_img_2+col_img_2 );
% 
% figure, imshow(ca_2_1/255);
% 
% % level 1 images
% 
% ca_1_1=idwt2(ca_2_1,ch_2_1,cv_2_1,cd_2_1, 'haar');
% ch_1_1=img_dec(1:row_img_1, col_img_1+1:col_img_1+col_img_1);
% cv_1_1=img_dec(row_img_1+1:row_img_1+row_img_1:1:col_img_1);
% cd_1_1=img_dec(row_img_1+1:row_img_1+row_img_1,col_img_1+1:col_img_1+col_img_1);
% 
% 
% figure, imshow(ca_1_1/255);
% 
% % final image
% 
% final_image=idwt2(ca_1_1, ch_1_1, cv_1_1, cd_1_1, 'haar');
% final_image=uint8(final_image);
% figure, imshow(final_image); title('Final image');
% 
% 
% [bpl MSE PSNR rdist]=attributes(X, final_image, codesize, sum_of_bits);
% 
% bpl
% MSE 
% PSNR
% 
%  Dist=double(final_image)-double(X);
%  Dist=Dist.^2;
%  MSE=mean(mean(Dist));
%  distsum=sum(sum(Dist));
%  disp(distsum);
%  MSE=(distsum)/(row*col)
% 
% PSNR=10*log10((255*255)/MSE)
% 
% % checking=uint16(rdist)-uint16(Dist);
% 



% -----------------One code book for all sub bands-------------------


Codesize=32; %Codebook size

[row_img_3 col_img_3]=size(ca3);


% Encoding entire img as one
[img_enc img_dec hammingx]=vqmain(heirchip22, Codesize);

figure, imshow(img_dec);

img_1=img_dec(1:row_img_3,1:col_img_3);
img_2=img_dec(1:row, col_img_3:col);
img_3=img_dec(row_img_3:row, 1:col_img_3);


figure, imshow(img_1);
figure, imshow(img_2);
figure, imshow(img_3);

%level 3 images

ca_3_1=img_dec(1:row_img_3, 1:col_img_3);
ch_3_1=img_dec(1:row_img_3, col_img_3+1:col_img_3+col_img_3);
cv_3_1=img_dec(row_img_3+1:row_img_3+row_img_3, 1:col_img_3);
cd_3_1=img_dec(row_img_3+1:row_img_3+row_img_3, col_img_3+1:col_img_3+col_img_3 );

figure, imshow(ca_3_1);title('Level 3');
figure, imshow(ch_3_1);title('Level 3');
figure, imshow(cv_3_1);title('Level 3');
figure, imshow(cd_3_1);title('Level 3');

% level 2 images

ca_2_1=idwt2(ca_3_1,ch_3_1,cv_3_1,cd_3_1, 'haar');
ch_2_1=img_dec(1:row_img_2, col_img_2+1:col_img_2+col_img_2);
cv_2_1=img_dec(row_img_2+1:row_img_2+row_img_2, 1:col_img_2);
cd_2_1=img_dec(row_img_2+1:row_img_2+row_img_2, col_img_2+1:col_img_2+col_img_2 );

figure, imshow(ca_2_1);

% level 1 images

ca_1_1=idwt2(ca_2_1,ch_2_1,cv_2_1,cd_2_1, 'haar');
ch_1_1=img_dec(1:row_img_1, col_img_1+1:col_img_1+col_img_1);
cv_1_1=img_dec(row_img_1+1:row_img_1+row_img_1:1:col_img_1);
cd_1_1=img_dec(row_img_1+1:row_img_1+row_img_1,col_img_1+1:col_img_1+col_img_1);


figure, imshow(ca_1_1);

% final image

final_image=idwt2(ca_1_1, ch_1_1, cv_1_1, cd_1_1, 'haar');

figure, imshow(final_image/255); title('Final image');

row
Codesize*row*8
hammingx
var1=Codesize*8*row*2+hammingx;
bpl=var1/(row*col)
MSE=sum(sum((X-final_image).^2))/(row*col);
PSNR=10*log10((255*255)/MSE)



%----------------------------------------dividing image into 3 parts and
%having a go----------------------------

% 
% img_2_1=heirchip22(1:row_img_3,1:col_img_3);
% img_2_2=heirchip22(1:row, col_img_3+1:col);
% img_2_3=heirchip22(row_img_3+1:row, 1:col_img_3);
% 
% figure, imshow(img_2_1/255);
% figure, imshow(img_2_2/255);
% figure, imshow(img_2_3/255);
% 
% codesize1=32;
% codesize2=8;
% codesize3=16;
% 
% [img_enc_1 img_dec_1 hamming1]=vqmain(img_2_1,codesize1);
% [img_enc_2 img_dec_2 hamming2]=vqmain(img_2_2,codesize2);
% [img_enc_3 img_dec_3 hamming3]=vqmain(img_2_3,codesize3);
% 
% hammingz=hamming1+hamming2+hamming3;
% 
% %stiching the image as one
% 
% img_dec_final=[img_dec_1;img_dec_3];
% img_dec_final=[img_dec_final img_dec_2];
% 
% figure, imshow(img_dec_final/255); title('rebuliding before inverse');
% 
% 
% %level 3 images
% 
% ca_3_1=img_dec_1;
% ch_3_1=img_dec_final(1:row_img_3, col_img_3+1:col_img_3+col_img_3);
% cv_3_1=img_dec_final(row_img_3+1:row_img_3+row_img_3, 1:col_img_3);
% cd_3_1=img_dec_final(row_img_3+1:row_img_3+row_img_3, col_img_3+1:col_img_3+col_img_3 );
% 
% 
% %level 2 images
% 
% ca_2_1=idwt2(ca_3_1,ch_3_1,cv_3_1,cd_3_1, 'haar');
% ch_2_1=img_dec_final(1:row_img_2, col_img_2+1:col_img_2+col_img_2);
% cv_2_1=img_dec_final(row_img_2+1:row_img_2+row_img_2, 1:col_img_2);
% cd_2_1=img_dec_final(row_img_2+1:row_img_2+row_img_2, col_img_2+1:col_img_2+col_img_2 );
% 
% figure, imshow(ca_2_1/255);
% 
% %level 1 images
% 
% ca_1_1=idwt2(ca_2_1,ch_2_1,cv_2_1,cd_2_1, 'haar');
% ch_1_1=img_dec_final(1:row_img_1, col_img_1+1:col_img_1+col_img_1);
% cv_1_1=img_dec_final(row_img_1+1:row_img_1+row_img_1:1:col_img_1);
% cd_1_1=img_dec_final(row_img_1+1:row_img_1+row_img_1,col_img_1+1:col_img_1+col_img_1);
% 
% 
% figure, imshow(ca_1_1/255);
% 
% %final image
% 
% final_image=idwt2(ca_1_1, ch_1_1, cv_1_1, cd_1_1, 'haar');
% % final_image=uint8(final_image);
% figure, imshow(final_image/255); title('Final image');
% 
% bpl2=((codesize1*row/8*8+codesize2*(row-row/8)*8+codesize3*row*8)+hammingz)/(row*col)
% 
% 
% Dist=double(final_image)-double(X);
% Dist=Dist.^2;
% % MSE=mean(mean(Dist))
% distsum=sum(sum(Dist));
% MSE2=(distsum)/(row*col)
% 
% % MSE=sum(sum(((double(final_image)-X).^2)))/(row*col)
% 
% PSNR2=10*log10((255*255)/MSE2)


% [m, p, DistHist]=vqsplit(ca2,Codesize);
% 
% [row column]=size(m);
% [r col]=size(ca2);
% 
% J=[];
% ca2=double(ca2);
% for i=1:col
%     dmin=99999999999999999;
%     index=0;
%     for j=1:column
%         sum1=0;
%         B=ca2(:,i);
%         D=(m(:,j));
%         C=B-D;
%         C=C.^2;
%         sum1=sum(C);
%         
%         
%         %for k=1:row
%         %    
%          % temp=((I(k,i)-m(k,j)))%*(I(k,i)-m(k,j)))
%          %   sum1=sum1+temp
%         %end
%         if(sum1<dmin)
%             dmin=sum1;
%             index=j;
%         end
%     end
%     J=[J index];
% end
% 
% 
% K=[];
% for i=1:col
%     temp=m(:,J(i));
%     K=[K temp];
% end
% K
% 
% ca2=uint8(K);



















% % Extract approximation coefficients
% % at level 2, from wavelet decomposition
% % structure [c,s]
% ca2 = appcoef2(c,s,'haar',2);
% 
% % Extract details coefficients at level 2
% % from wavelet decomposition
% % structure [c,s]
% chd2 = detcoef2('h',c,s,2);
% cvd2 = detcoef2('v',c,s,2);
% cdd2 = detcoef2('d',c,s,2);
% 
% % Extract approximation and details coefficients
% % at level 1, from wavelet decomposition
% % structure [c,s]
% ca1 = appcoef2(c,s,'haar',1);
% chd1 = detcoef2('h',c,s,1);
% cvd1 = detcoef2('v',c,s,1);
% cdd1 = detcoef2('d',c,s,1);
% 
% % Reconstruct approximation at level 2,
% % from the wavelet decomposition
% % structure [c,s]
% a2 = wrcoef2('a',c,s,'haar',2);
% 
% % Reconstruct details at level 2,
% % from the wavelet decomposition
% % structure [c,s].
% hd2 = wrcoef2('h',c,s,'haar',2);
% vd2 = wrcoef2('v',c,s,'haar',2);
% dd2 = wrcoef2('d',c,s,'haar',2);
% 
% % One step reconstruction of wavelet
% % decomposition structure [c,s].
% sc = size(c)
% 
% [c,s]=upwlev2(c,s,'haar');sc=size(c);
% 
% % Reconstruct approximation and details
% % at level 1, from coefficients.
% %
% % step 1: extract coefficients
% % decomposition structure [c,s].
% %
% % step 2: reconstruct.
% 
% siz = s(size(s,1),:);
% ca1 = appcoef2(c,s,'haar',1);
% a1 = upcoef2('a',ca1,'haar',1,siz);
% clear ca1
% 
% chd1 = detcoef2('h',c,s,1);
% hd1 = upcoef2('h',chd1,'haar',1,siz);
% clear chd1
% 
% cvd1 = detcoef2('v',c,s,1);
% vd1 = upcoef2('v',cvd1,'haar',1,siz);
% clear cvd1
% 
% cdd1 = detcoef2('d',c,s,1);
% dd1 = upcoef2('d',cdd1,'haar',1,siz);
% clear cdd1
% 
% % Reconstruct X from the wavelet
% % decomposition structure [c,s].
% a0 = waverec2(c,s,'haar');
% figure,imshow(a0/max(max(a0)))

% imwrite(a0/(max(max(a0))),[newpath,newtiffile],'tif');
