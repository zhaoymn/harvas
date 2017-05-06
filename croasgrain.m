function Dst = croasgrain(data,scale)
L = length(data);
k = 1;
for i = 1:scale:L-scale+1
    Dst(k) = mean(data(i:i+scale-1));
    k=k+1;
end