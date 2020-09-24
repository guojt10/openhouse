% 标题：自动白平衡算法
% 作者：买醉装疯
% 日期：2020年9月
% 内容：对任意非纯色图片，基本可以准确还原图像颜色,不需要挑选白点
% 邮箱: 1554895045@qq.com

close all; clear; clc;

bit = 8; % bit = 8,10,12,... 
k = 1;   % 0<k<=1
n = 3;   % n>=2

im = imread('14.png');
figure(1),imshow(im),title('origin image');

% get raw data
% row = 1280;
% col = 960;
% fid = fopen('left1.raw','r');
% raw = fread(fid,[row,col],'uint8')';
% im = demosaic(uint8(raw),'grbg');
% figure(1),imshow(im);

% bit是图像数据位宽
im = double(im)/(2^bit-1);
% im1的分辨率有320*240,算法就可以正常工作
% 根据im的大小，适当调整k,可以提高代码的运行速度
im1 = imresize(im,k); 
r = reshape(im1(:,:,1),[],1);
g = reshape(im1(:,:,2),[],1);
b = reshape(im1(:,:,3),[],1);
kr = polyfit(r,g,n);
kb = polyfit(b,g,n);
im2 = zeros(size(im));
im2(:,:,2) = im(:,:,2);
for i = 1:n
    im2(:,:,1) = im2(:,:,1) + im(:,:,1).^(n+1-i)*kr(i);
    im2(:,:,3) = im2(:,:,3) + im(:,:,3).^(n+1-i)*kb(i);
end
im2(:,:,1) = im2(:,:,1) + kr(n+1);
im2(:,:,3) = im2(:,:,3) + kb(n+1);
figure(2),imshow(im2);
