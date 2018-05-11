%-------------------------------------------------------------------------%
%--------------------Building a Dartboard in MATLAB-----------------------%
%-------------------------------------------------------------------------%
% In this script, we will construct a rough approximation of a standard
% English dartboard using a 512X512 matrix whose coordinates can be used to
% return the point values represented by each place on the board


clc;
close all;
clear all;

%-------------------------------------------------------------------------%

% Define the cartesian plane which we will use to project our dartboard
% (512 equally-spaced points will be plotted, ranging from -1 to +1)
xa = linspace(-1,1,512);
ya = linspace(-1,1,512);

%-------------------------------------------------------------------------
%-----------------   Define the rings of the board   ----------------------
%-------------------------------------------------------------------------

%Array of radius ratios for dartboard rings
R=[1 3 31 124 143 304 343 ]./512;
% We use meshgrid to define a coordinate plane
[Y,X] = meshgrid(ya,xa);

% Diameters of the different rings of the board
D0 = X.^2 + Y.^2<=R(1); %(inner bullseye)
D1 = X.^2 + Y.^2<=R(2); %(outer bullseye)
D2 = X.^2 + Y.^2<=R(3);
D3 = X.^2 + Y.^2<=R(4);
D4 = X.^2 + Y.^2<=R(5);
D5 = X.^2 + Y.^2<=R(6);
D6 = X.^2 + Y.^2<=R(7);
inBounds = D6;          %(playable area of the board)


%--Build the 10 dark-shaded wedges with values alternating 1's and 0's and arrange them
% in their correct locations on the board (starting from bottom center wedge)
% (We're building a logical coordinate matrix with each wedge comprised of all 1's)

A=pi/20; % Ratio needed since there are twenty wedges

wedge3=((atan2(Y,X)<=A)+(-A<=atan2(Y,X)))-1;
wedge2=((atan2(Y,X)<=5*A)+(3*A<=atan2(Y,X)))-1;
wedge10=((atan2(Y,X)<=9*A)+(7*A<=atan2(Y,X)))-1;
wedge13=((atan2(Y,X)<=13*A)+(11*A<=atan2(Y,X)))-1;
wedge18=((atan2(Y,X)<=17*A)+(15*A<=atan2(Y,X)))-1;
wedge20=flipud(wedge3);
wedge12=rot90(wedge2,2);
wedge14=rot90(wedge10,2);
wedge8=rot90(wedge13,2);
wedge7=rot90(wedge18,2);


%--Build the 10 light-shaded wedges with values alternating 1's and 0's and arrange them
% in their correct locations on the board

wedge1=rot90(wedge10);
wedge5=rot90(wedge13);
wedge9=rot90(wedge18);
wedge11=rot90(wedge20);
wedge16=rot90(wedge12);
wedge19=rot90(wedge14);
wedge17=rot90(wedge8);
wedge15=rot90(wedge7);
wedge6=rot90(wedge3);
wedge4=rot90(wedge2);


%--------------------------------------------------------------------------
% Mask each wedge to only include the radius which is 'on the board' and
% also subtract the outer bullseye ring (we will add these values later), then
% scale each wedge to its correct point value
%
wedge20=((wedge20) & (inBounds) & (~D1)) *20;
wedge19=((wedge19) & (inBounds) & (~D1)) *19;
wedge18=((wedge18) & (inBounds) & (~D1)) *18;
wedge17=((wedge17) & (inBounds) & (~D1)) *17;
wedge16=((wedge16) & (inBounds) & (~D1)) *16;
wedge15=((wedge15) & (inBounds) & (~D1)) *15;
wedge14=((wedge14) & (inBounds) & (~D1)) *14;
wedge13=((wedge13) & (inBounds) & (~D1)) *13;
wedge12=((wedge12) & (inBounds) & (~D1)) *12;
wedge11=((wedge11) & (inBounds) & (~D1)) *11;
wedge10=((wedge10) & (inBounds) & (~D1)) *10;
wedge9=((wedge9) & (inBounds) & (~D1)) *9;
wedge8=((wedge8) & (inBounds) & (~D1)) *8;
wedge7=((wedge7) & (inBounds) & (~D1)) *7;
wedge6=((wedge6) & (inBounds) & (~D1)) *6;
wedge5=((wedge5) & (inBounds) & (~D1)) *5;
wedge4=((wedge4) & (inBounds) & (~D1)) *4;
wedge3=((wedge3) & (inBounds) & (~D1)) *3;
wedge2=((wedge2) & (inBounds) & (~D1)) *2;
wedge1=((wedge1) & (inBounds) & (~D1)) *1;

%--------------------------------------------------------------------------
% Add up all the wedges to form the wedge matrix

wedges = wedge9 + wedge8 + wedge7 + wedge6 + wedge5 + wedge4 + wedge3 +...
    wedge20 + wedge2 + wedge19 + wedge18 + wedge17 + wedge16 + wedge15 +...
    wedge14 + wedge13 + wedge12 + wedge11 + wedge10 + wedge1;

% Create final dartboard matrix, applying proper multipliers to each ring
innerBullseye=50.*D0;
outerBullseye=25.*(D1-D0);
wedgesWithMultiplierRings = wedges + 2.*(D4-D3).*wedges + 1.*(D6-D5).*wedges;

fullDartboard = (innerBullseye + outerBullseye + wedgesWithMultiplierRings);


%-------------  Visualize the dartboard as a contour map    ---------------


figure('Color','w','Name','Dartboard Simulator','NumberTitle','off');
imagesc(xa,ya, fullDartboard )
title('Dartboard','fontsize',14)
colorbar
shading interp;
axis equal tight;


%-------------------------------------------------------------------------
