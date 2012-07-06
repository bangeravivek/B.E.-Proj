% subband coder
% Lab 6 Image Compression and Packet Video
% Dr. Nicholas Beser
% Subband coder is based on Chapter from Rabbani and Jones
% page 174-177. It is based on a paper by:
% Adelson, Simoncelli and Hingorani, "Orthogonal Pyramid
% Transforms for image coding" in Proc. SPIE Visual 
% Communications and Image Processing II, 845, 50-58, (1987).
% Start with reading a TIFF file
[filen,pathnamen]=uigetfile('*.tif','Reference Image',50,50);
[newsubtiffile, newsubpath] = ...
  uiputfile('*.tif', 'Save Subband Image As');
[newtiffile, newpath] = ...
  uiputfile('*.tif', 'Save Reconstructed Subband Image As');
[X,MAP] = tiffread([pathnamen,filen]);

%
% The QMF filter is described in the SPIE paper
% Classic FIR filter (coefficients from paper)
NTAPS = 9;
[nx,ny]=size(X);
global h0;
global h1;
% Function qmffilt defines the h0 and h1 vectors for FIR filter
qmffilt;
% Use blkproc to speed up FIR filter
% Perform low pass and high pass filter on the rows first
% Transpose the image 
% X=X';
h1x=blkproc(X,[1 nx],'qmffiltr(P1,x)',h0);
h2x=blkproc(X,[1 nx],'qmffiltr(P1,x)',h1);
% pause % here for diagnostic purposes
fprintf('Vertical Filter Done, Starting Vertical Downsample\n');
h1xd=blkproc(h1x,[1 nx],'downsame(x,0)');
clear h1x;
h2xd=blkproc(h2x,[1 nx],'downsame(x,1)');
clear h2x;
h1xd=h1xd';
h2xd=h2xd';
y11h0=blkproc(h1xd,[1 ny],'qmffiltr(P1,x)',h0);
y12h1=blkproc(h1xd,[1 ny],'qmffiltr(P1,x)',h1);
clear h1xd;
y11=blkproc(y11h0,[1 ny],'downsame(x,0)');
% Correct for offset
y11=y11-1;
clear y11h0;
fprintf('y11 is Done\n');
y12=blkproc(y12h1,[1 ny],'downsame(x,1)');
clear y12h1;
fprintf('y12 is Done\n');
y21h0=blkproc(h2xd,[1 ny],'qmffiltr(P1,x)',h0);
y22h1=blkproc(h2xd,[1 ny],'qmffiltr(P1,x)',h1);
clear h2xd;
y21=blkproc(y21h0,[1 ny],'downsame(x,0)');
clear y21h0;
fprintf('y21 is Done\n');
y22=blkproc(y22h1,[1 ny],'downsame(x,1)');
clear y22h1;
fprintf('y22 is Done\n');
fprintf('2-D Four Band Analysis Bank Complete\n');
fprintf('Setup output of subband image\n');
% Create a scaled composite image that shows the sub bands. 
% you should note that y11, y12, y21, and y22 have the real subband
% data.
b=zeros(nx,ny);
baux1=round(y11);
baux2=round(4.*y12)+128;
baux3=round(4.*y21)+128;
baux4=round(4.*y22)+128;
for i=1:128
 for j=1:128
  if baux1(i,j)>255
      baux1(i,j)=255;
  end
  if baux1(i,j)<0
      baux1(i,j)=0;
  end
  b(i,j)=baux1(i,j);
  if baux2(i,j)>255
      baux2(i,j)=255;
  end
  if baux2(i,j)<0
      baux2(i,j)=0;
  end
  b(i+128,j)=baux2(i,j);
  if baux3(i,j)>255
      baux3(i,j)=255;
  end
  if baux3(i,j)<0
      baux3(i,j)=0;
  end
  b(i,j+128)=baux3(i,j);
  if baux4(i,j)>255
      baux4(i,j)=255;
  end
  if baux4(i,j)<0
      baux4(i,j)=0;
  end
  b(i+128,j+128)=baux4(i,j);
 end
end

% Transpose the b array so that the transpose effect (done for filtering)
% is removed
b=b';
tiffwrite(b,gray(256),[newsubpath newsubtiffile]);
% imshow(b,gray(256));
% title('Sub Band Output (2-D Four-Band Analysis Bank)');
subplot(2,2,1),imshow(baux1',gray(256)),title('Low/Low Pass');
subplot(2,2,2),imshow(baux2',gray(256)),title('Low/High Pass');
subplot(2,2,3),imshow(baux3',gray(256)),title('High/Low Pass');
subplot(2,2,4),imshow(baux4',gray(256)),title('High/High Pass');
fprintf('Press space bar to continue\n');
pause

clear baux1;
clear baux2;
clear baux3;
clear baux4;
% Now Lets try to reconstruct the data (synthesis bank)
% The first stage is to upsample the various outputs from the
% analysis stage so that along the filter direction, the length
% is doubled. We will reuse arrays here for space savings.
% First scale the low and high pass coefficients
% This is taken from Rabbani and Jones page 173
 for i=0:NTAPS-1
  h0(i+1)=2. * h0(i+1);
  h1(i+1)=2. * h1(i+1);
 end
fprintf('Upsample the four outputs from the synthesis bank\n');
y11h1=upsample(y11',0);
y12h2=upsample(y12',1);
y21h1=upsample(y21',2);
y22h2=upsample(y22',3);
clear y11;
clear y12;
clear y21;
clear y22;
% At this point we need to filter with our modified low pass and 
% high pass filters
fprintf('Filter y11 (upsampled)\n');
h1r=blkproc(y11h1,[1 ny],'qmffiltr(P1,x)',h0);
clear y11h1;
h1r=h1r';
htemp=blkproc(h1r,[1 nx],'qmffiltr(P1,x)',h0);
fprintf('Filter y12 (upsampled)\n');
h1r=blkproc(y12h2,[1 ny],'qmffiltr(P1,x)',h0);
clear y12h2;
h1r=h1r';
% Filter and Sum the results together
htemp=blkproc(h1r,[1 nx],'qmffiltr(P1,x)',h1)+htemp;
fprintf('Sum output of Low/Low and Low/High filters together\n');
% Do the same for the other outputs
fprintf('Filter y21 (upsampled)\n');
h1r=blkproc(y21h1,[1 ny],'qmffiltr(P1,x)',h1);
clear y21h1;

h1r=h1r';
% Filter and Sum the results together
htemp=blkproc(h1r,[1 nx],'qmffiltr(P1,x)',h0)+htemp;
fprintf('Filter y22 (upsampled)\n');
h1r=blkproc(y22h2,[1 ny],'qmffiltr(P1,x)',h1);

clear y22h2;
h1r=h1r';
% Filter and Sum the results together
X=blkproc(h1r,[1 nx],'qmffiltr(P1,x)',h1)+htemp;
X=X';
clear htemp;
clear h1r;
% Sum the results together
fprintf('Sum output of High/Low and High/High filters together\n');
fprintf('Clip if outside 8 bit gray scale\n');
maxpixel=0;
minpixel=10000;
for i=1:nx
 for j=1:ny
  if X(i,j)>maxpixel
      maxpixel=X(i,j);
  end
  if X(i,j)<minpixel
      minpixel=X(i,j);
  end
  if X(i,j)>255
      X(i,j)=255;
  end
  if X(i,j)<0
      X(i,j)=0;
  end
 end
end
fprintf('Minimum Pixel is %f, Maximum Pixel is %f\n',minpixel,maxpixel);

tiffwrite(X,gray(256),[newpath newtiffile]);
subplot(1,1,1),imshow(X,gray(256));
title('Reconstructed Sub Band (2-D Four-Band Analysis Bank)');