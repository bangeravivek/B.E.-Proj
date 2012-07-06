function K=vqdecode(J, m)

[row col]=size(m);
K=[];
for i=1:col
    temp=m(:,J(i));
    K=[K temp];
end
K