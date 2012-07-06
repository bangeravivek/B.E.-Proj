% o=f1(x):
%   Active function for Hidden layer nerons (sigmoid)

% veisi@ce.sharif.edu, March 2004

function o=f1(x)
    tmp1=1+exp(x.*-1);    
    o=(tmp1.^(-1));
    
