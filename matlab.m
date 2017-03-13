clc;
close all;
clear all;



margin = 0.1;

n = round(logspace(1,10,1000));

BER = logspace(-1,-4,100);

BERLim = BER*10^(margin/10);

y = 0.975;
for j = 1:length(BER)
    for k = 1:length(n)
        err(j) = binoinv(y,n(k),BER(j));
        BERMax = err(j)/n(k);
        if (BERMax < BERLim(j) && err(j) ~= 0)
           nMax(j) = n(k);
           
           break;
        end
    end
end

loglog(BER,err)
grid
xlabel('BER values')
ylabel([strcat('no. bits corosponding to ',num2str(margin),' dB margin'); 'with a 95% confidence              '])
             