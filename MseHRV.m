% %%%%%%%%%%%Note%%%%%%%%%%%%%%%%%%
% Multi scale Entropy 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input the need parameters
function output = MseHRV(IBI_4h,scale)
RR_4h=IBI_4h(:,2);
MSEpre=MultiScaleEn(RR_4h,scale);
output.MSE=MSEpre';
[m1,n1]=size(output.MSE);
scale=m1;%�߶�����
mse1_5=output.MSE(1:5,:);%�߶�1-5�ľ���С�߶Ⱦ���
mse6_15=output.MSE(6:15,:);%�߶�6-15�ľ����г߶Ⱦ���
mse6_20=output.MSE(6:20,:);%�߶ȴ���5�ľ��󣬴�߶Ⱦ���
[m2,n2]=size(mse6_15);
[m3,n3]=size(mse6_20);
%����߶�1-5������ߵ�б��
x=1:5;
y=mse1_5';
for i=1:n1
    output.kb(i,:)=polyfit(x,y(i,:),1);
end
%����߶�1-5������������X֮��Ľ������
%���ڳ߶�����֮�乹�ɵĲ�������״������+ֱ�������μ���
for i=1:n1
    for j=2:5
        if mse1_5(j,i)>=mse1_5(j-1,i)%�Ƚ����ڳ߶����ӵ���ֵ��С����ȷ�����εĸߺ�ֱ�������εĸ�
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
        if mse6_15(j,i)>=mse6_15(j-1,i)%�Ƚ����ڳ߶����ӵ���ֵ��С����ȷ�����εĸߺ�ֱ�������εĸ�
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
        if mse6_20(j,i)>=mse6_20(j-1,i)%�Ƚ����ڳ߶����ӵ���ֵ��С����ȷ�����εĸߺ�ֱ�������εĸ�
        a3(j-1,i)=mse6_20(j-1,i)*1+0.5*1*(mse6_20(j,i)-mse6_20(j-1,i));
        output.area6_20(i)=sum(a3(:,i));
        else
        a3(j-1,i)=mse6_20(j,i)*1+0.5*1*abs((mse6_20(j,i)-mse6_20(j-1,i)));
        output.area6_20(i)=sum(a3(:,i));
    end
    end
end
end

 