PL = squeeze(PL_val);
[Minu, Mini] = min(PL);
Count = zeros(6,6);

for n = 1:311
    for c = 1:6 
        if c==Mini(1,n)
            for cc = 1:6
                if PL(c,n)+5>PL(cc,n)
                   Count(c,cc) = Count(c,cc) + 1; 
                end
            end
        end
    end
end

Count = Count*diag(diag(Count))^(-1);

for x = 1:6
    for y = 1:6
        if Count(x,y) > 0.05
            Count(x,y) = 1;
        else
            Count(x,y) = 0;
        end
    end
end