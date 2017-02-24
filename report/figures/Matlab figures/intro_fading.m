

x = linspace(0,1,1000);
y = linspace(0,1,1000);

[xdata1, ydata1] = meshgrid(x,y);
zdata1 = mag2db(abs(sin(2*pi*2*xdata1)+sin(2*pi*2*ydata1))+0.01);

figure('Color',[1 1 1]);

% Create axes
axes1 = axes;
hold(axes1,'on');

% Create surf
surf(xdata1,ydata1,zdata1,'LineStyle','none');
%colormap hot
% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 1]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 1]);
% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-50 50]);
%view(axes1,[5.6843418860808e-14 79.12]);
view(axes1,[0 90]);
grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',30,'XTick',zeros(1,0),'YTick',zeros(1,0),'ZTick',...
    zeros(1,0));
% Create colorbar
c = colorbar('peer',axes1);
 ylabel(c,'Fading gain (dB)')
