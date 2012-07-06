function [y]=upsample(x,flag)
% This is a general upsample function that will double the
% size in both directions 
% depending on the flag, the zeros are offset by one column
% flag = 0 no offset
% flag = 1 offset in x column
% flag = 2 offset in y column
% flag = 3 offset in both x and y 
[nx,ny]=size(x);
y=zeros(nx*2,ny*2);
for i=1:nx
  for j=1:ny
   if flag==0
    y(i*2-1,j*2-1)=x(i,j);
   end
   if flag ==1
    y(i*2,j*2-1)=x(i,j);
   end
   if flag==2
    y(i*2-1,j*2)=x(i,j);
   end
   if flag==3
    y(i*2,j*2)=x(i,j);
   end
  end
end
	
