clear all;
N=1000; % point in frecuency
dw=10/N; % delta freq.
w=[-2:dw:2-dw]; % frequencies

b=exp((- w.^2));
c=sinc(w*1.8); 
a=b .* c; 
plot(abs(a'),'LineWidth',2);
grid;
line([201,201],[1,0],'Color','black','LineStyle','--');
line([150,250],[0.5,0.5],'Color','red','LineStyle','--');
xlabel('Bandwidth \Delta f');
ylabel('Coherence');
title('Coherence Bandwidth')
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [])