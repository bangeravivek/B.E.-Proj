% o=f1_p(x):
%    Derivative of Active function for Hidden layer nerons

% veisi@ce.sharif.edu, Dec. 2003

function o=f1_p(x)
    o=f1(x).*(1-f1(x));
    
