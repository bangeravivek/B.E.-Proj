function [bpl MSE PSNR Dist]=attributes(enc_image, original_image, codesize, bitsum) 

enc_image=double(enc_image);
original_image=double(original_image);
[row column]=size(original_image);

%codebooksize= total_codevectors * size_of_each_codevector * 8 (size of
%each element of codevector) * no_of_codebooks

level_3_main=codesize*2*row/8*8;



level_3_rem=codesize*row/8*8*7;

level_2=codesize/2*row/4*8*3*2;

level_1=codesize/2*row/2*8*3*2;

encoded_size=(level_1+level_2+level_3_main+level_3_rem)+bitsum;

bpl=encoded_size/(row*column);
bpl2=bitsum/(row*column)

Dist=enc_image-original_image;
Dist=Dist.^2;

distsum=sum(sum(Dist));

MSE=(distsum)/(row*column);

%PSNR
PSNR=10*log10((255*255)/MSE);
