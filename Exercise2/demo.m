% Add path common function
addpath('../common_function');
    
%example for a grayscale image: 
%Read a grayscale image
image = imread('barbara.pgm'); 
imagesize = size(image);
%Creating a random morphield
morphfield = 8*imresize(rand(5,5,2)-0.5,imagesize,'bilinear');
%Morph the original image
MorphedImage = morphimage(image,morphfield);
%Show original image
figure(1); imagesc(image,[0 255]); colormap gray;
%Show morphed image
	figure(2); imagesc(MorphedImage,[0 255]); colormap gray;
%Show morphing matrix for x-coordinates
	figure(3); imagesc(morphfield(:,:,1)); colorbar;
%Show morphing matrix for y-coordinates
	figure(4); imagesc(morphfield(:,:,2)); colorbar;