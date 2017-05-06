function MSE = MultiScaleEn(data,scale)
r = 0.15*std(data);
for i = 1:scale
    buf = croasgrain(data,i);
    MSE(i) = SampEn(buf,r);
end