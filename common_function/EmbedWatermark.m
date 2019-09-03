%   EmbedWatermark embeds a watermark bit into a 16x16 uint8 block of an
%   image
%	EmbedWatermark(block,bitvalue,quant) embeds into a block a bit with value
%	'0' or '1' (bitvalue) and an embedding strength quant
%	
%	block    --> 16x16 uint8 block of an image
%   bitvalue --> bitvalue (int) 0 or 1
%   quant    --> embedding strength, only even values > 2, commend is 16,
%                a higher value quant yields lower quality degradations, a
%                lower value quant yields a more robust watermark bit
%
%   watermarkedblock --> watermarked block
%   wx               --> resulting warping  strength in x direction
%   wy               --> resulting warping  strength in y direction
%
%   [watermarkedblock, wx, wy] = EmbedWatermark(block,1,16)

function [newblock, wx, wy] =  EmbedWatermark(block,bitvalue,quant)

    % Chinh sua cho chay cac block 4X4 8x8 32x32 64x64
    % bsize = 16
    [bsize, ~] = size(block); %Block size 

    vek = block_vek(block); %Compute the vectors for the normed centre of gravity

%STEP ONE: CRUDE GLOBAL SEARCH OF SUITABLE WARPING DIRECTIONS

    steps = 10; %resoultion 

    zm_max = [];

    % NCG-coordinates of the original block
    x = 8*vek2wink(vek(1,1),vek(1,2))/pi;
    y = 8*vek2wink(vek(2,1),vek(2,2))/pi;

    %global search for  warping
    maxcnt = 1;
    for cnt3 = 1:2*steps+1
        for cnt4 = 1:2*steps+1
            %warp original blocks in different directions
            zm_vek = block_vek(warp_block(block,bsize,x,y,(cnt3-steps-1)/steps,(cnt4-steps-1)/steps));
            %compute svalue (zm)
            zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
            zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
            zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
            zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
            [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
            zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
            %adapt zm to the wanted bitvalue
            zm = abs(zm -(1-bitvalue));
            merker(cnt3,cnt4) = zm;
            %remember warping directions with good (zm near 1) results 
             if (zm > 0.9)
                 zm_max(maxcnt) = zm; % remember zm-value
                 zm_wx(maxcnt) = (cnt3-steps-1)/steps; % remember warping in x direction
                 zm_wy(maxcnt) = (cnt4-steps-1)/steps; % remember warping in y direction
                 maxcnt = maxcnt+1;
             end
        end
    end
    %reducing some of the selected warping directions which are close
    %together to reduce the computational complexity for the next steps
    if length(zm_max ) >= 1
        posvek = ones(length(zm_max),1);
        for cnt1 = 1:1:length(zm_max)
            if posvek(cnt1) == 1
                for cnt2 = cnt1+1:1:length(zm_max)
                    if ((zm_wx(cnt1)-zm_wx(cnt2))^2+(zm_wy(cnt1)-zm_wy(cnt2))^2)^0.5 < 0.25
                        if zm_max(cnt2) <= zm_max(cnt1)
                            posvek(cnt2) = 0;
                        else
                            posvek(cnt1) = 0;
                        end
                    end
                end
            end
        end
        zm_max2 = zm_max(find(posvek==1));                
        zm_wy2 = zm_wy(find(posvek==1));
        zm_wx2 = zm_wx(find(posvek==1));
    else
        pos = find(merker(:) == max(merker(:)));
        pos = pos(1);
        [xp, yp] = ind2sub([steps*2+1,steps*2+1],pos);
        zm_max2 = merker(11,11);
        zm_wy2 = (yp-steps-1)/steps;
        zm_wx2 = (xp-steps-1)/steps;
    end
    
%STEP TWO: FINE SEARCH, THE SELECTED CRUDE WARPING DIRECTIONS ARE USED AS STARTING POINTS 

    for cnt1 = 1:1:length(zm_max2)
      increment = 1/(2*steps);
        zm_max = zm_max2(cnt1);                
        zm_wy = zm_wy2(cnt1);
        zm_wx = zm_wx2(cnt1);

         % neue Schrittweite

        i = 0;

        % Verschiebung des Blockes in 8 Richtungen und Test auf
        % Maximum
        [zmax, zmax_wx, zmax_wy] = warp_spider(block,bsize,quant,x,y,zm_max,zm_wx,zm_wy,increment,bitvalue);                
        merker2(i+1,cnt1) = zmax;
        while (zmax ~= 0.5) && (i < 15)

            i = i + 1;

            % Sichern des aktuellen BESTEN Ergebnisses
            zm_max = zmax;
            zm_wx = zmax_wx;
            zm_wy = zmax_wy;

            % Halbieren der zu verwendenden Schrittweite
            increment = increment/2;                    

            % Verschieben um den aktuellen BESTEN Z-Wert
            [zmax, zmax_wx, zmax_wy] = warp_spider(block,bsize,quant,x,y,zm_max,zm_wx,zm_wy,increment,bitvalue);
            merker2(i+1,cnt1) = zmax;
        end
        zm_maxe(cnt1) = zm_max;                
        zm_wye(cnt1) = zmax_wy;
        zm_wxe(cnt1) = zmax_wx;
    end
%STEP THREE: CHOSE THE BEST RESULT OUT OF THE LOCATED MAXIMA
    Dist = (zm_wye.^2+zm_wxe.^2).^0.5;%compute the warping strength
    Qual = 0.99*(zm_maxe/0.5) +  0.01*(1-(Dist/(2^0.5)));%compute the quality of the result
    pos = find(Qual == max(Qual));%find the best quality
    pos = pos(1);
    %compute the watermakred block
    newblock = warp_block(block,bsize,x,y,zm_wxe(pos),zm_wye(pos));
    wx = zm_wxe(pos);
    wy = zm_wye(pos);
    


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


%sub-function which warps a block in 8 different directions to find the
%best warping direction
function [zmax, zmax_wx, zmax_wy] = warp_spider(block,bsize,quant,x,y,z,wx,wy,increment,bitvalue)

    zmax = z;
    zmax_wx = wx;
    zmax_wy = wy;

    % warping up
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx+increment,wy));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));
    
    if (zm > zmax)
        zmaxmax = zm;
        zmax_wx = wx+increment;
        zmax_wy = wy;
    end

    % warping up rigth
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx+increment,wy+increment));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx+increment;
        zmax_wy = wy+increment;
    end

    % warping rigth
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx+increment,wy));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx+increment;
        zmax_wy = wy;
    end

    % warping down rigth
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx+increment,wy-increment));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx+increment;
        zmax_wy = wy-increment;
    end

    % warping down
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx,wy-increment));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx;
        zmax_wy = wy-increment;
    end

    % warping down left
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx-increment,wy-increment));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx-increment;
        zmax_wy = wy-increment;
    end

    % warping left
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx-increment,wy));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx-increment;
        zmax_wy = wy;
    end

    % warping up left
    zm_vek = block_vek(warp_block(block,bsize,x,y,wx-increment,wy+increment));

    zm_x = 8*vek2wink(zm_vek(1,1),zm_vek(1,2))/pi;
    zm_y = 8*vek2wink(zm_vek(2,1),zm_vek(2,2))/pi;
    zm_lx = (zm_vek(1,1)^2+zm_vek(1,2)^2)^0.5;
    zm_ly = (zm_vek(2,1)^2+zm_vek(2,2)^2)^0.5;
    [zm_l1,zm_l2] = compf(zm_lx,zm_ly,1.8);
    zm = ((dreieck(zm_x,quant)*zm_l1)+(dreieck(zm_y,quant)*zm_l2));
    zm = abs(zm -(1-bitvalue));

    if (zm > zmax)
        zmax = zm;
        zmax_wx = wx-increment;
        zmax_wy = wy+increment;
    end

%sub-function to warp a block 
function output = warp_block(input,bsize,x,y,wx,wy)
   
    morphingfield = ones(bsize,bsize,2);
    morphingfield(:,:,1) = morphingfield(:,:,1)*-wx;
    morphingfield(:,:,2) = morphingfield(:,:,2)*wy;
    output = uint8(morphimage(uint8(input),morphingfield));
