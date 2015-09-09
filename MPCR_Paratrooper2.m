%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------%
%
% Machine Perception and Cognitive Robotics Laboratory
%
%     Center for Complex Systems and Brain Sciences
%
%              Florida Atlantic University
%
%------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------%
% William Hahn & Elan Barenholtz
% Neural Networks for Reinforcement Learning
% 3/5/15
%
% Paratrooper
% https://en.wikipedia.org/wiki/Paratrooper_(video_game)
%
% Boxer/DosBox
% http://boxerapp.com/
% http://www.dosbox.com/
%------------------------------------------------------%
function MPCR_Paratrooper2
clear all
close all
clc

beep off

% rng(123) % set seed for random number generator

format short



import java.awt.Robot;

import java.awt.event.*;

robot=Robot();



x=0;
y=48;
w=960;
h=720;

reduce=16;

digits11=zeros(31,25,11);

load('00.mat')

digits11(:,:,11)=onesplace;

load('0.mat')

digits11(:,:,10)=onesplace;

for i=1:9
    
    load([ num2str(i) '.mat' ])
    
    digits11(:,:,i)=onesplace;
    
end


image1 = robot.createScreenCapture(java.awt.Rectangle(x,y,w,h));

data=image1.getData();
pix=data.getPixels(0,0,w,h,[]);
tmp=reshape(pix(:),3,w,h);

for i=1:3
    outputImage(:,:,i)=squeeze(tmp(i,:,:))';
end

pattern=outputImage/255;

pattern0=rgb2gray(pattern);

pattern=pattern0(1:660,:);

pattern(597:end,433:528)=0;

pattern(568:596,466:495)=0;

pattern=im2uint8(imresize(pattern,[size(pattern,1)/reduce size(pattern,2)/reduce]));

s1=size(pattern);

score=pattern0(688:718,138:287);

onesplace=score(1:31,125:149);

tensplace=score(1:31,101:125);

onesdigit=zeros(1,11);

tensdigit=zeros(1,11);

for i=1:11
    
    onesdigit(i)=sum(sum(onesplace==digits11(:,:,i)))/length(onesplace(:));
    tensdigit(i)=sum(sum(tensplace==digits11(:,:,i)))/length(tensplace(:));
    
end

onesdigit=find(HahnWTA(onesdigit));

tensdigit=find(HahnWTA(tensdigit));

onesdigit=onesdigit*(onesdigit<10);

tensdigit=tensdigit*(tensdigit<10);

gamescore=10*tensdigit+onesdigit








pattern=im2double(pattern(:))';




bias=ones(size(pattern,1),1);
pattern = [pattern bias];

n1 = size(pattern,2);   %Set the Number of Input Nodes Equal to Number of Pixels in the Input image
n2 = 26;   %n2-1        %Number of Hidden Nodes (Free Parameter)
n3 = 4;%size(category,2);  %Set the Number of Output Nodes Equal to the Number of Distinct Categories {left,forward,right}


w1 = 0.5*(1-2*rand(n1,n2-1)); %Randomly Initialize Hidden Weights
w2 = 0.5*(1-2*rand(n2,n3));   %Randomly Initialize Output Weights

dw1 = zeros(size(w1));          %Set Initial Hidden Weight Changes to Zero
dw2 = zeros(size(w2));          %Set Initial Output Changes to Zero

L = 0.25;          % Learning    %Avoid Overshooting Minima
M = 0.8;           % Momentum    %Smooths out the learning landscape



c=100;


choice={'left', 'fire', 'right', 'noop', 'auto'};






while true
    
    
    
    
    image1 = robot.createScreenCapture(java.awt.Rectangle(x,y,w,h));
    
    data=image1.getData();
    pix=data.getPixels(0,0,w,h,[]);
    tmp=reshape(pix(:),3,w,h);
    
    for i=1:3
        outputImage(:,:,i)=squeeze(tmp(i,:,:))';
    end
    
    pattern=outputImage/255;
    
    pattern0=rgb2gray(pattern);
    
    pattern=pattern0(1:660,:);
    
    pattern(597:end,433:528)=0;
    
    pattern=im2uint8(imresize(pattern,[size(pattern,1)/reduce size(pattern,2)/reduce]));
    
    figure(2)
    imagesc(pattern)
    
    
    pattern=im2double(pattern(:))';
    
    
    
    pattern = pattern(ones(1,c),:);
    
    
    pattern = pattern + 0.01*randn(size(pattern));
    
    
    
    
    
    %     for i=1:size(pattern,1)
    %
    %         figure(4)
    %         imagesc(reshape(pattern(i,:),s1(1),s1(2)))
    %         pause
    %
    %     end
    %     return
    %
    
    
    
    
    bias=ones(size(pattern,1),1);
    
    
    pattern = [pattern bias];
    
    
    
    
    act1 = [af(0.1*pattern * w1) bias];
    
    
    
    act2 = af(act1 * w2);
    
    
    
    act22=HahnWTA(act2);
    
    
    [uA,~,uIdx] = unique(act22,'rows');
    act2mode = uA(mode(uIdx),:);
    
    
    
    
    %     motor = input(['Enter 1 for left, 2 for fire, 3 for right, 4 for noop , 5 for network(' choice{find(act2mode)} ')-->']);
    
    
    
    motor=2;
    
    choice{find(act2mode)}
    switch motor
        
        case 1
            
            category=[1 0 0 0];
            category=category(ones(1,c),:);
            
            motor1=1;
            
            
            
        case 2
            
            category=[0 1 0 0];
            category=category(ones(1,c),:);
            motor1=2;
            
        case 3
            
            category=[0 0 1 0];
            category=category(ones(1,c),:);
            motor1=3;
            
        case 4
            
            category=[0 0 0 1];
            category=category(ones(1,c),:);
            motor1=4;
            
            
            
            
        case 5
            
            category=act2;
            
            motor1=find(act2mode);
            
            
            
            
    end
    
    
    
    delay1=200;
    
    
    switch motor1
        
        case 1
            
            robot.mouseMove(200,40)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
            
            
            robot.keyPress(KeyEvent.VK_LEFT);
            robot.keyRelease(KeyEvent.VK_LEFT);
            
            robot.delay(delay1);
            
            robot.mouseMove(200,1350)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
            
            
        case 2
            
            robot.mouseMove(200,40)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
            
            robot.keyPress(KeyEvent.VK_UP);
            robot.keyRelease(KeyEvent.VK_UP);
            
            robot.delay(delay1);
            
            robot.mouseMove(200,1350)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
            
        case 3
            
            
            robot.mouseMove(200,40)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
            robot.keyPress(KeyEvent.VK_RIGHT);
            robot.keyRelease(KeyEvent.VK_RIGHT);
            
            robot.delay(delay1);
            
            robot.mouseMove(200,1350)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
        case 4
            
            
            robot.mouseMove(200,40)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            robot.delay(delay1);
            
            robot.mouseMove(200,1350)
            robot.mousePress(InputEvent.BUTTON1_MASK);
            robot.mouseRelease(InputEvent.BUTTON1_MASK);
            
            
            
            
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    error = category - act2;  %Calculate Error
    
    
    
    delta_w2 = error .* act2 .* (1-act2); %Backpropagate Errors
    delta_w1 = delta_w2*w2' .* act1 .* (1-act1);
    
    
    delta_w1(:,size(delta_w1,2)) = []; %Remove Bias
    
    
    dw1 = L * pattern' * delta_w1 + M * dw1; %Calculate Hidden Weight Changes
    dw2 = L * act1' * delta_w2 + M * dw2;    %Calculate Output Weight Changes
    
    
    
    w1 = w1 + dw1; %Adjust Hidden Weights
    w2 = w2 + dw2; %Adjust Output Weights
    
    
    
    %     w1 = w1 + 0.001*rand(size(w1)); %Adjust Hidden Weights
    %     w2 = w2 + 0.001*rand(size(w2)); %Adjust Output Weights
    
    
    
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Visualize Input Weights as Receptive Fields
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(1)
    
    Wp=w1;
    Wp = ((Wp - min(min(Wp)))/(max(max(Wp)) - min(min(Wp))));
    
    for i =1:n2-1
        subplot(sqrt(n2-1),sqrt(n2-1),i)
        imagesc(reshape(Wp(1:n1-1,i),s1(1),s1(2)))
        axis off
    end
    drawnow()
    
    
    
    drawnow()
    
    
    
    
    
    
    
    
    
    image1 = robot.createScreenCapture(java.awt.Rectangle(x,y,w,h));
    
    data=image1.getData();
    pix=data.getPixels(0,0,w,h,[]);
    tmp=reshape(pix(:),3,w,h);
    
    for i=1:3
        outputImage(:,:,i)=squeeze(tmp(i,:,:))';
    end

    pattern0=outputImage/255;
    
    pattern0=rgb2gray(pattern0);
        
    score=pattern0(688:718,138:287);
    
    onesplace=score(1:31,125:149);
    
    tensplace=score(1:31,101:125);
    
    onesdigit=zeros(1,11);
    
    tensdigit=zeros(1,11);
    
    for i=1:11
        
        onesdigit(i)=sum(sum(onesplace==digits11(:,:,i)))/length(onesplace(:));
        tensdigit(i)=sum(sum(tensplace==digits11(:,:,i)))/length(tensplace(:));
        
    end
    
    onesdigit=find(HahnWTA(onesdigit));
    
    tensdigit=find(HahnWTA(tensdigit));
    
    onesdigit=onesdigit*(onesdigit<10);
    
    tensdigit=tensdigit*(tensdigit<10);
    
    gamescore=10*tensdigit+onesdigit
    
    
    
    
    
end %end while loop






end %end function













%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------%
%--------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function action = af (weighted_sum)


action = 1./(1+exp(-weighted_sum));  		


end







function x = HahnWTA(x)



for i=1:size(x,1)
    
    [a,b]=max(x(i,:));
    
    x(i,:)=1:size(x,2)==b;
    
    
end



end




