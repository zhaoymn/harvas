% %%%%%%%%%%%Note%%%%%%%%%%%%%%%%%%
% Multi scale Entropy 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input the need parameters
function output = MseHRV(IBI_4h,scale)
RR_4h=IBI_4h(:,2);
MSEpre=MultiScaleEn(RR_4h,scale);
output.MSE=MSEpre';
[m1,n1]=size(output.MSE);
scale=m1;%尺度因子
mse1_5=output.MSE(1:5,:);%尺度1-5的矩阵，小尺度矩阵
mse6_15=output.MSE(6:15,:);%尺度6-15的矩阵，中尺度矩阵
mse6_20=output.MSE(6:20,:);%尺度大于5的矩阵，大尺度矩阵
[m2,n2]=size(mse6_15);
[m3,n3]=size(mse6_20);
%计算尺度1-5拟合曲线的斜率
x=1:5;
y=mse1_5';
for i=1:n1
    output.kb(i,:)=polyfit(x,y(i,:),1);
end
%计算尺度1-5曲线与坐标轴X之间的近似面积
%相邻尺度因子之间构成的不规则形状按矩形+直角三角形计算
for i=1:n1
    for j=2:5
        if mse1_5(j,i)>=mse1_5(j-1,i)%比较相邻尺度因子的熵值大小，以确定矩形的高和直角三角形的高
        a1(j-1,i)=mse1_5(j-1,i)*1+0.5*1*(mse1_5(j,i)-mse1_5(j-1,i));
        output.area1_5(i)=sum(a1(:,i));
        else
        a1(j-1,i)=mse1_5(j,i)*1+0.5*1*abs((mse1_5(j,i)-mse1_5(j-1,i)));
        output.area1_5(i)=sum(a1(:,i));
    end
    end
end

for i=1:n2
    for j=2:m2
        if mse6_15(j,i)>=mse6_15(j-1,i)%比较相邻尺度因子的熵值大小，以确定矩形的高和直角三角形的高
        a2(j-1,i)=mse6_15(j-1,i)*1+0.5*1*(mse6_15(j,i)-mse6_15(j-1,i));
        output.area6_15(i)=sum(a2(:,i));
        else
        a2(j-1,i)=mse6_15(j,i)*1+0.5*1*abs((mse6_15(j,i)-mse6_15(j-1,i)));
        output.area6_15(i)=sum(a2(:,i));
    end
    end
end

for i=1:n3
    for j=2:m3
        if mse6_20(j,i)>=mse6_20(j-1,i)%比较相邻尺度因子的熵值大小，以确定矩形的高和直角三角形的高
        a3(j-1,i)=mse6_20(j-1,i)*1+0.5*1*(mse6_20(j,i)-mse6_20(j-1,i));
        output.area6_20(i)=sum(a3(:,i));
        else
        a3(j-1,i)=mse6_20(j,i)*1+0.5*1*abs((mse6_20(j,i)-mse6_20(j-1,i)));
        output.area6_20(i)=sum(a3(:,i));
    end
    end
end
end

 