function [y]=downsame(x,flag)
% 2:1 Downsample function
% if flag =0, then x downsample will select left point
% if flag =1, then x downsample will select right point
[nx,ny]=size(x);
y=zeros(nx,ny/2);
if flag ==0
 for j=0:2:ny-1
   y(1,j/2+1)=x(1,j+1);
 end
end
if flag ==1
 for j=1:2:ny-1
   y(1,(j-1)/2+1)=x(1,j+1);
 end
end
  