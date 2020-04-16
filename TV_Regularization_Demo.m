% Implementation of TV regularization as Blind Deconvolution Technique
% Digital Image Processing Term Project - Auburn University
% John Ragland
clear
close all
clc

addpath('H:\Documents\0 School Work\OverGrad\MATLAB_functions');
dbstop if error
addpath('H:\Documents\0 School Work\OverGrad\Coursework\0 Digital Image Processing\Term Project - Deblurring\Pictures');

camera = im2double(imread('camera.tif'));
ker = fspecial('disk',3.5);
%ker = [zeros(5,11); ker; zeros(5,11) ];

%Blur with circular convolution to avoid dealing with boundaries
% no noise added at this time
cam_blur = imfilter(camera,ker,'conv');

figure(1)
imshow(cam_blur)

%% Set Up Paremeters
beta = 1e-5;
gamma = 1e-1;

alpha1 =5e-6;
alpha2 = 1e-4

iterations = 50000;


%% Call TVdeblur Function
[un, kn] = TVdeblur(cam_blur,alpha1,alpha2,gamma,beta,iterations);

%% Generate Figure
figure(2)
subplot(1,2,1)
surf(ker)
subplot(1,2,2)
surf(kn)

figure(3)
subplot(1,2,1)
imagesc(cam_blur)
title('Blurry Image')

subplot(1,2,2)
imagesc(un)
title('Rectified Image')
colormap(gray)

%% Figures for Report
figure(3)
imagesc(un)
set(gca,'xticklabels','')
set(gca,'yticklabels','')
colormap(gray)
truesize()

figure(2)
imagesc(cam_blur)
set(gca,'xticklabels','')
set(gca,'yticklabels','')
colormap(gray)
truesize()

figure(5)
subplot(1,2,1)
mesh(padarray(ker,[6 6]),'edgecolor','k','LineWidth',1.2)
subplot(1,2,2)
mesh(padarray(kn,[6 6]),'EdgeColor','k','LineWidth',1.2)