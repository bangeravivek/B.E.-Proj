
% [In,n,h,m,nop,err,file_I2H,file_I2H_B,file_H2O,file_H2O_B]=ReadParams
%    Read input parametere from a file
%    return In=image matrix and
%        n=number of input nerons,  h=number of hidden nerons
%        m=number of output nerons, nop=number of input training patterns
%        err= error tolerance for terminatig network training
%        file...= files that contain weights of network

% veisi@ce.sharif.edu, Dec. 2003

function [In,n,h,m,nop,err,file_I2H,file_I2H_B,file_H2O,file_H2O_B]=ReadParams
    %file=input('Parameters file:');
    %im=input('Input image file:');
    
    In=imread('cameraman.tif');
    %n=input('Input block size :');
    %h=input('compressed block size :');
    n=64;
    m=n;
    h=16;
    [p,q]=size(In);
    nop=p*q/n;
    err=1.0e-40;              % Error tolerance

    file_I2H='I2H.wgt';        % Input2Hidden weight
    file_H2O='H2O.wgt';        % Hidden2Output weight
    file_I2H_B='I2H_B.wgt';    % Input2Hidden bias weight vector
    file_H2O_B='H2O_B.wgt';
