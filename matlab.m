clc;
close all;
clear all;



margin = 1;

n = round(logspace(1,10,1000));

BER = logspace(-1,-7,100);

BERLim = BER*10^(margin/10);

y = 0.975;
for j = 1:length(BER)
    for k = 1:length(n)
        err(k) = binoinv(y,n(k),BER(j));
        BERMax = err(k)/n(k);
        if (BERMax < BERLim(j) && err(k) ~= 0)
           nMax(j) = n(k);
           
           break;
        end
    end
end

loglog(BER,nMax)
grid
xlabel('BER values')
ylabel([strcat('no. bits corosponding to ',num2str(margin),' dB margin'); 'with a 95% confidence              '])
             