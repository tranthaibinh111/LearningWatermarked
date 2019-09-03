function [B8,B7,B6,B5,B4,B3,B2,B1] = bitplane (pic)
    B1 = bitget(pic,1)*2^0 ;
    B2 = bitget(pic,2)*2^1 ;
    B3 = bitget(pic,3)*2^2 ;
    B4 = bitget(pic,4)*2^3 ;
    B5 = bitget(pic,5)*2^4 ;
    B6 = bitget(pic,6)*2^5 ;
    B7 = bitget(pic,7)*2^6 ;
    B8 = bitget(pic,8)*2^7 ;
end 