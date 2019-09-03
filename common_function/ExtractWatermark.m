%   ExtractWatermark extracts a watermark bit out of a 16x16 uint8 block of an
%   image
%	[bitvalue, svalue] = ExtractWatermark(block,quant) extracts out of block a bit with value
%	'0' or '1' (bitvalue). qunat is the used embedding strength 
%	
%	block    --> 16x16 uint8 block of an image
%   quant    --> used quantization strength
%
%   bitvalue --> extracted bitvalue (int)
%   svalue   --> extracted value s (double 0..1) which is used to decide between bitvalue
%                '0' or '1'
%
%   [bitvalue, svalue] = ExtractWatermark(watermarkedblock,16)

function [bitvalue, svalue] = ExtractWatermark(block,quant)

    zm_vek = block_vek(block);
    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    svalue = zm;
    bitvalue = round(zm);
    
%function delivers the vector for the Normed Centre of Gravity
function [vek] = block_vek(block)

    blocksize      = size(block);
    winkelvek_x = (pi/blocksize(1):2*pi/blocksize(1):(2*pi)-(pi/blocksize(1)));
    winkelvek_y = (pi/blocksize(1):2*pi/blocksize(1):(2*pi)-(pi/blocksize(1)));

    vert_m = mean(double(block)); 
    vek(1,1) = sum(cos(winkelvek_x).*vert_m); 
    vek(1,2) = sum(sin(winkelvek_x).*vert_m); 

    hor_m = mean(double(block),2); 
    vek(2,1) = sum(cos(winkelvek_y).*hor_m'); 
    vek(2,2) = sum(sin(winkelvek_y).*hor_m'); 

%sub-function the compute the s value
function [erg1, erg2] = compf(l1,l2,ef)

    if l1 < l2
        erg1 = x(l1,l2,ef)*l1/(l1+l2);
        erg2 = 1-erg1;
    else
        erg2 = x(l2,l1,ef)*l2/(l1+l2);
        erg1 = 1-erg2;
    end

%sub-function the compute the s value
function erg = x(l1,l2,ef)

    if ef ~= 0
        erg1 = (exp(ef*l1/1200))/(exp(ef));
        erg = erg1/(1+(1-abs((l1-l2)/1200))*(erg1-1));
    else
        erg = 1;
    end

%sub-function the compute the s value
function erg = dreieck(x,n)

    Breite = 16/n; 
    Breite_h = Breite/2;
    pos = mod(x,Breite);
    if pos <= Breite_h
        erg = pos*n/16; 
    else
        erg = (pos*(-n/8)+2)/2;
    end
    erg = 2*erg; 


%sub-function the compute the NCG
function ergw = vek2wink(x,y)

    if x ~= 0
        ergw = atan(abs(y/x));
    else
        ergw = pi/2;
    end

    if x < 0 & y > 0
        ergw = pi - ergw;
    elseif x < 0 & y < 0
        ergw = ergw + pi;
    elseif x > 0 & y < 0
        ergw = 2*pi - ergw;
    end