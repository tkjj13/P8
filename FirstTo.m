clc;
close all;
clear all;


data = xlsread('FirstTo.xlsx', 'Guld');
data = data(4063:end,1:4);

id = 1;
tid = 2;
value = 4; % penge
treshold = [200 500 1000];
nTres = 3;

sz = size(data);

index = 1;
user = 1;
for row = 1:sz(1)-1
   sorted_data(user,index,:) = data(row,:); 
   if data(row,id) ~= data(row+1,id)
       index = 1;
       user = user +1;
   else
       index = index + 1;
   end
end





sz = size(sorted_data);
time = 1E10*ones(nTres,sz(1),sz(2));
for tres = 1:nTres
    for user = 1:sz(1)
        start = 1;
        slut = 1;
        done = 0;
        while ~done       
           if sum(sorted_data(user,start:slut,value)) >= treshold(tres)
              time(tres,user,start) = sorted_data(user,slut,tid)-sorted_data(user,start,tid);
              start = start + 1;
              slut = start - 1;
           end

           slut = slut + 1;
           if slut > sz(2)
               done = 1;
           end
        end
    end
end

fastest = min(time,[],3);
%%
for tres = 1:nTres
    index = 1;
    for n = 1:sz(1)
        if fastest(tres,n) ~= 1E10
            table(tres,index,1) = sorted_data(n,1,id);
            table(tres,index,2) = fastest(tres,n);
            index = index + 1;
        end
    end
end

tabel1(:,:) = table(1,:,:);
tabel2(:,:) = table(2,:,:);
tabel3(:,:) = table(3,:,:);


