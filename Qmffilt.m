function qmffilt
% ------------------------------------------------------------------- */
%  qmf_filter : This routine setup the coefficients of the QMF.       */
%                                                                     */
%               h0[] : low-pass filter                                */
%               h1[] : high-pass filter                               */
%                                                                     */
%  Obs: h0 and h1 are 9-tap filter                                    */
%                                                                     */
%   REF : "Orthogonal pyramid transforms for image coding", E. H.     */
%   Adelson and E. Simoncelli, Proc. SPIE, Visual Communications      */
%   and Image Proc. II.                                               */
%                                                                     */
%  Diego Garrido                                                      */
% --------------------------------------------------------------------*/
NTAPS = 9;

global h0;
global h1;
buffer=zeros(9);
buffer(1)= 0.01995;
buffer(2)=  -0.04271;
buffer(3)=  -0.05224;
buffer(4)=  0.29271;
buffer(5)=  0.56458; 
buffer(6)=  0.29271;
buffer(7)=  -0.05224;
buffer(8)=  -0.04271;
buffer(9)=  0.01995;
    shift=1.0;    
    for i = 1:  NTAPS
        h0(i) = buffer(i);
        h1(i) = shift .* h0(i);
        shift = (-1.) .* shift;     
     end     
