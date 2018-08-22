
%Matlab File Exchange
%https://www.mathworks.com/matlabcentral/fileexchange/48811-image-isophotes

function [ I, theta ] = isophote( L, alpha )
    theta=zeros(size(L));  
    L = double(L)/255;  
    [Lx,Ly] = gradient(L);
    I = sqrt(Lx.^2+Ly.^2);
    I = I./max(max(I));
    T = I>=alpha;
    theta(T) = atan(Ly(T)./Lx(T));
    I(I<alpha)=0;
end