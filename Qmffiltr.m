function [y]=qmffiltr(h,x)
% QMF Filter
% This uses conventional filter, but creates mirror images out the outside
% which results in good values in the center section
[nx,ny]=size(x);
[nhx,nhy]=size(h);
 temp1=zeros(1,floor(nhy/2));
 temp2=zeros(1,floor(nhy/2));
 for i=1:floor(nhy/2)
    temp1(i)=x(ny-floor(nhy/2)+i);
    temp2(i)=x(i);
 end
% temp=[temp1,x,temp2];
%temp1=zeros(1,nhy);
%temp2=zeros(1,nhy);
% for i=1:nhy
%    temp1(i)=x(ny-nhy+i);
%    temp2(i)=x(i);
% end
 temp=[temp1,x,temp2];
% [ntx,nty]=size(temp)
% temp=filter(h,1,temp);
% y=temp(floor(nhy/2)+1:floor(nhy/2)+ny);
% [nyx,nyy]=size(y)
% pause
%[ntx,nty]=size(temp)
temp=conv(h,temp);
%[ntx,nty]=size(temp)
%y=temp(14:269);
y=temp(9:264);
% [nyx,nyy]=size(y)
% pause