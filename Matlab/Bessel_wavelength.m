%% Plots a bessel 0 fuection and sacles it by wavelength
X = 0:0.1:15.2;
nu = 0;
J = besselj(nu,X);
P = plot(X/(2*pi),J,'LineWidth',2)
hold on;
grid;
line([0,2.4],[0,0],'Color','black','LineStyle','--');
line([0.382,0.382],[0,-0.5],'Color','black','LineStyle','--');
legend('J_0')
title('Bessel Function J_0 with wavelengh');
xlabel('Wavelength {\lambda}');
ylabel('Coherence');