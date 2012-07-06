% [v,w,v_b,w_b]=ReadWeights(I,H):
%    Read weights of trained network with I nerons in Input and output layer
%                                      H nerons in hidden layer 
%    Return input2hidden layer weight matrix(v) and bias vector of hidden layer(v_b)
%        hidden2output layer weight matrix(w) and bias vector of output layer(w_b)

% veisi@ce.sharif.edu, Dec. 2003

function [v,w,v_b,w_b]=ReadWeights(I,H)

    file_I2H='I2H.wgt';        % Input2Hidden weight
    file_H2O='H2O.wgt';        % Hidden2Output weight
    file_I2H_B='I2H_B.wgt';    % Input2Hidden bias weight vector
    file_H2O_B='H2O_B.wgt';


    v=ReadFromFile(file_I2H,I,H);
    w=ReadFromFile(file_H2O,H,I);

    fid = fopen(file_I2H_B,'r+');
    v_b=fscanf(fid,'%f');
    fclose(fid);
    
    fid = fopen(file_H2O_B,'r+');
    w_b=fscanf(fid,'%f');
    fclose(fid);