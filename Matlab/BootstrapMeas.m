% %% Bootstrap
% clear all
% clc
% close all
% 
% Sample = zeros(4040000,1);
% for n = 1:4040000
%     Sample(n) = raylrnd(0.707)^2;    
% end

Sample = fade2;

O = sort(Sample);


P = zeros(4184460,1);
B = zeros(100,10000);
H = round(logspace(0 , log10(4184460), 100));

for q = 1:10000
    l = randi([1 4184460],4184460,1);
    for r = 1:4184460        
        P(r, 1) = O(l(r,1));
    end
    P = sort(P);
    for i = 1:100
        B(i,q) = P(H(1,i),1);
    end
    disp(q);
end

%%
y = H/4184460;
b = B;
c = sort(b,2);
o = zeros(100,1);

for i = 1:100
        o(i,1) = O(H(1,i),1);
end

u = o;

figure
for j = 1:10000
    semilogy(c(:,j),y);
    hold on;
end

figure
semilogy(c(:,500),y);
hold on
semilogy(c(:,10000-500),y);
semilogy(u(:,1),y);
xlabel('Fading gain');
ylabel('CDF');
legend('Min','Max','Sample','Location', 'NorthWest');
grid;
% 
% 
% %% Regressiv
% clear all
% clc
% close all
% S = 4040000;
% Sm3 = round(S/(10^3));
% 
% Sample = zeros(S,1);
% SortSamp = zeros(S,2);
% ModelEXP = zeros(S,1);
% SampleM3 = zeros(Sm3:3);
% 
% for n = 1:S
%     Sample(n) = 10*log10(raylrnd(0.707)^2);
%     SortSamp(n,1) = 10*log10(n/S);
%     ModelEXP(n) = 10*log10(1-exp(-n/S));
% end
% SortSamp(:,2) = sort(Sample);
% 
% for n = 1:Sm3
%     SampleM3(n,1) = SortSamp(n,1);
%     SampleM3(n,2) = SortSamp(n,2);
%     SampleM3(n,3) = ModelEXP(n,1);
% end
% 
% MSEexp = (SampleM3(:,2)-SampleM3(:,3)).^2;
% 
% 
% A = 0.1;
% MSEnow = mean((A*SampleM3(:,1)-SampleM3(:,2)).^2);
% MSEbefore = MSEnow+1;
% for Steps = 1:10
%     while MSEbefore > MSEnow
%     MSEbefore = MSEnow;
%     
%     A = A + 10^(-Steps);
%     MSEnow = mean((A*SampleM3(:,1)-SampleM3(:,2)).^2);  
%     end
%     A = A - 10^(-Steps);
%     MSEnow = MSEbefore;
%     MSEbefore = MSEbefore+1;
% end
% 
% B = -5;
% MSEnow = mean(((A*SampleM3(:,1)+B*SampleM3(:,1).^2)-SampleM3(:,2)).^2);
% MSEbefore = MSEnow+1;
% for Steps = 1:10
%     while MSEbefore > MSEnow
%     MSEbefore = MSEnow;
%     
%     B = B + 10^(-Steps);
%     MSEnow = mean(((A*SampleM3(:,1)+B*SampleM3(:,1).^2)-SampleM3(:,2)).^2); 
%     end
%     B = B - 10^(-Steps);
%     MSEnow = MSEbefore;
%     MSEbefore = MSEbefore+1;
% end
% 
% 
% 
% figure
% plot(SampleM3(:,2),SampleM3(:,1));
% hold on
% plot(SampleM3(:,3),SampleM3(:,1));
% plot(SampleM3(:,1)*A,SampleM3(:,1));
% plot(SampleM3(:,1)*A+(SampleM3(:,1).^2)*B,SampleM3(:,1));
% grid
% 
% figure
% plot(MSEexp(:,1),SampleM3(:,1));
% hold on
% grid


%% Regressiv with Bootstrap
clear all
clc
close all
S = 4040000;
Sm3 = round(S/(10^3));
Boot = 10000;

Sample = zeros(S,1);
SortSamp = zeros(S,2);
BootSamp = zeros(S,2);
SampleM3 = zeros(Sm3:2);
A = zeros(Boot,1);
B = zeros(Boot,1);
Nr = zeros(Boot,1);

for n = 1:S
    Sample(n) = 10*log10(raylrnd(0.707)^2);
    SortSamp(n,1) = 10*log10(n/S);
end
SortSamp(:,2) = sort(Sample);


for n = 1:Boot
    RandsNr = randi([1 S],S,1);
    for s = 1:S
        BootSamp(s,1) = SortSamp(RandsNr(s,1),2);
    end
    BootSamp(:,2) = sort(BootSamp(:,1));
    
    for s = 1:Sm3
        SampleM3(s,1) = SortSamp(s,1);
        SampleM3(s,2) = BootSamp(s,2);
    end
    
    A(n) = 0.1;
    MSEnow = mean((A(n)*SampleM3(:,1)-SampleM3(:,2)).^2);
    MSEbefore = MSEnow+1;
    for Steps = 1:10
        while MSEbefore > MSEnow
        MSEbefore = MSEnow;

        A(n) = A(n) + 10^(-Steps);
        MSEnow = mean((A(n)*SampleM3(:,1)-SampleM3(:,2)).^2);  
        end
        A(n) = A(n) - 10^(-Steps);
        MSEnow = MSEbefore;
        MSEbefore = MSEbefore+1;
    end

    B(n) = -5;
    MSEnow = mean(((A(n)*SampleM3(:,1)+B(n)*SampleM3(:,1).^2)-SampleM3(:,2)).^2);
    MSEbefore = MSEnow+1;
    for Steps = 1:10
        while MSEbefore > MSEnow
        MSEbefore = MSEnow;

        B(n) = B(n) + 10^(-Steps);
        MSEnow = mean(((A(n)*SampleM3(:,1)+B(n)*SampleM3(:,1).^2)-SampleM3(:,2)).^2); 
        end
        B(n) = B(n) - 10^(-Steps);
        MSEnow = MSEbefore;
        MSEbefore = MSEbefore+1;
    end    
    disp(n);
    Nr(n) = n;
end

A = sort(A);
B = sort(B);

figure
plot(Nr,A);
hold
plot(Nr,B);
grid;
