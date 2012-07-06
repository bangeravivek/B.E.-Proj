function val=BitRate(BlockSize,NoOfBlocks,NoOfHiddenNeroun,NoOfBitsOut,NoOfBitsWeight)

% val=BitRate(BlockSize,NoOfBlocks,NoOfHiddenNeroun,NoOfBitsOut,NoOfBitsWeight)
% Return the value val of bit rate that is necessary for coding outputs of hidden
%        layer and weights from hidden to output layer,
%
% Parameters:
%   BlockSize= size of each block in pixel, i.e. 8*8=(64) 
%   NoOfBlocks= number of blocks of image=(all pixels of image)/BlockSize,
%   NoOfHiddenNeroun= number of neurons in hidden layer i.e. (16),
%   NoOfBitsOut= number of bits that require for coding hidden layer outputs i.e.integer(16)
%   NoOfBitsWeight= number of bits that require for coding hidden to output layer weights i.e.float(32)

% Hadi veisi,  March 2004

val= ((NoOfBlocks*NoOfHiddenNeroun*NoOfBitsOut)+(BlockSize*NoOfHiddenNeroun*NoOfBitsWeight))/(BlockSize*NoOfBlocks);