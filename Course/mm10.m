clc;
close all;
clear all;


NumNodes = 500;
Dist = 20;



for n = 1:NumNodes
    Nodes(n).pos = 100*rand(1, 2);
    Nodes(n).Neighbourgh = zeros(1,NumNodes);
    for k = 1:n
        if ((n ~= k) && (Dist > norm(Nodes(n).pos-Nodes(k).pos,2)))
        %if (norm(Nodes(n).pos-Nodes(k).pos,2))    
        Nodes(n).Neighbourgh(k) = 1;
        Nodes(k).Neighbourgh(n) = 1;
        end
    end
end

for n = 1:NumNodes
    scatter(Nodes(n).pos(1),Nodes(n).pos(2),'b')
    hold on
    for k = 1:NumNodes
        if Nodes(n).Neighbourgh(k) == 1
            line([Nodes(n).pos(1) Nodes(k).pos(1)], [Nodes(n).pos(2) Nodes(k).pos(2)]) 
        end
    end
end


