clc;
clear all;
close all;

image=imread('cameraman.tif');
[ca1 ch1 cv1 cd1]=dwt2(image,'haar');
[ca2 ch2 cv2 cd2]=dwt2(ca1,'haar');
[ca3 ch3 cv3 cd3]=dwt2(ca2,'haar');

inv_1=idwt2(ca1,ch1,cv1,cd1,'haar');
inv_2=idwt2(ca2,ch2,cv2,cd2,'haar');
inv_3=idwt2(ca3,ch3,cv3,cd3,'haar');

figure, imshow(uint8(inv_1));
figure, imshow(uint8(inv_2));
figure, imshow(uint8(inv_3));

figure, imshow(ca1);
figure, imshow(ca2);
figure, imshow(ca3);

[cre3_a rec3_a]=SOFM(ca3);
[cre3_h rec3_h]=SOFM(ch3);
[cre3_v rec3_v]=SOFM(cv3);
[cre3_d rec3_d]=SOFM(cd3);
[cre2_h rec2_h]=SOFM(ch2);
[cre2_v rec2_v]=SOFM(cv2);
[cre2_d rec2_d]=SOFM(cd2);
[cre1_h rec1_h]=SOFM(ch2);
[cre1_v rec1_v]=SOFM(cv1);
[cre1_d rec1_d]=SOFM(cd1);

level_2=uint16(idwt2(rec3_a,rec3_h,rec3_v,rec3_d,'haar'));
figure, imshow(level_2);