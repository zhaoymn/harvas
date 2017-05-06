clc;clear;
IBI=importdata('liaoxionghua_1h_V5_0_00_0_59.ibi');
T=1;s=1;th=0.2;L=32;
%function [DC, AC] = PRSA_Ts(rr,T,s,L,th)
%rr原始RR间期序列，T时间窗宽度，s心率加速力、加速力计算长度
%L是PRSA序列的长度的一半，th为相邻RR间期变化的剔除阈值5%、10%、15%、20%、25%
%我们选择：T=1,s=1,th=0.2; L对结果的影响非常小，一般选2^n，32或64都没有问题
Pre_RR=IBI;
%把原始rr间期序列的第一个值赋给新数组Pre_RR
%Pre_RR(1)=rr(1);

%剔除异常点，如果相邻RR间期值相差5%以上则剔除，相邻RR间期相等值剔除
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for i=1:l1-1
%    if abs((rr(i+1)-rr(i))/rr(i))>0.05
%        Pre_RR(i+1)=0;
%    elseif rr(i+1)-rr(i)==0
%        Pre_RR(i+1)=0;
%    else
%    Pre_RR(i+1)=rr(i+1);
%    end
%end

%剔除异常点后得到新的RR间期序列
%例：原始Pre_RR=[0.6 0 0.5 0 0.4 0.3 0.2]，经过操作Pre_RR(:, all(Pre_RR==0, 1))=[]后，
%       Pre_RR=[0.6 0.5 0.4 0.3 0.2]
%Pre_RR(:, all(Pre_RR==0, 1)) = [];  %将剔除异常点剩余的RR间期序列值无缝连接到一起
%lp=length(Pre_RR);  %新的RR间期序列的长度
%ys=rem(lp,5);  %求lp/5的余数
%Pre_RR=Pre_RR(1:lp-ys);  %确保新的RR间期序列长度是5的倍数
%RR=reshape(Pre_RR',[5 length(Pre_RR')/5])'; %按序逐一从Pre_RR'列向量中取出元素，
                                             %并重置成5列 length(Pre_RR')/5 行的矩阵
%RR=mean(RR,2);  %求矩阵RR各行的均值
lp=length(Pre_RR);
ys=rem(lp,T);  %求lp/T的余数
Pre_RR=Pre_RR(1:lp-ys);
Pre_RR=reshape(Pre_RR',[T length(Pre_RR')/T])';  %按序逐一从Pre_RR'列向量中取出元素，
                                             %并重置成T列 length(Pre_RR')/T 行的矩阵
Pre_RR=mean(Pre_RR,2); %求矩阵Pre_RR各行的均值

l1=length(Pre_RR);
RR(1)=Pre_RR(1);

%剔除异常点，如果相邻RR间期值相差5%以上则剔除，相邻RR间期相等值剔除
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:l1-1
    if abs((Pre_RR(i+1)-Pre_RR(i))/Pre_RR(i))>th
        RR(i+1)=0;
    elseif Pre_RR(i+1)-Pre_RR(i)==0
        RR(i+1)=0;
    else
     RR(i+1)=Pre_RR(i+1);
    end
end

%剔除异常点后得到新的RR间期序列
RR(:, all(RR==0, 1)) = [];  %将剔除异常点剩余的RR间期序列值无缝连接到一起
%Step1 definition of anchors标记加速点和减速点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n]=size(RR);
if m>n
    RR=RR';  %确保RR为行向量
else
    RR=RR;
end
l2=length(RR);
dc_index=zeros(1,l2);
dc=zeros(1,l2);
ac_index=zeros(1,l2);
ac=zeros(1,l2);
for i=1:l2-1
    if RR(i+1)>RR(i)
        dc_index(i+1)=i+1;
        dc(i+1)=RR(i+1);
    else
        ac_index(i+1)=i+1;
        ac(i+1)=RR(i+1);
    end
end

%加速点和减速点RR间期值和对应坐标
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dc_index(:, all(dc_index==0, 1)) = [];  %将向量中为0的元素去掉，实现剩余元素的无缝拼合
dc(:, all(dc==0, 1)) = [];
ac_index(:, all(ac_index==0, 1)) = [];
ac(:, all(ac==0, 1)) = [];
%Step2 definition of segments定义含加速点、减速点序列片段L=16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l_dc_index=length(dc_index);
%L=32;
%判断第一个减速点和最后一个减速点能否够构成一个长度为2L的片段，不够补0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seg_dc=zeros(l_dc_index,2*L);
if dc_index(1)<=L
    Pre_RR1=zeros(1,L-(dc_index(1)-1));  %需要在dc_index(1)前面补充 L-(dc_index(1)-1)个0
    DC_RR=[Pre_RR1 RR];
else
    DC_RR=[RR];
end
if (l2-dc_index(end))<=L-1   %l2为剔除异常点后新的RR间期序列的长度
    Post_RR1=zeros(1,L-1-(l2-dc_index(end)));  %%需要在dc_index(end)后面补充 L-1-(l2-dc_index(end))个0
    DC_RR=[DC_RR  Post_RR1];
else
     DC_RR=[DC_RR];
end
%补0后重构RR间期序列
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DC_RR=[Pre_RR1 RR Post_RR1];
for i=1:l_dc_index
    for j=1:2*L
        seg_dc(i,j)=DC_RR(dc_index(i)-(L-j+1)+L-(dc_index(1)-1)); %dc_index(i)-(L-j+1)是没有考虑补0后序号的变化；L-(dc_index(1)-1)是在原始RR序列第一个值前面补充的0的个数
    end
end
%判断第一个加速点和最后一个加速点能否够构成一个长度为2L的片段，不够补0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l_ac_index=length(ac_index);
seg_ac=zeros(l_ac_index,2*L);
if ac_index(1)<=L
    Pre_RR2=zeros(1,L-(ac_index(1)-1));
    AC_RR=[Pre_RR2 RR];
else
     AC_RR=[RR];
end
if (l2-ac_index(end))<=L-1
    Post_RR2=zeros(1,L-1-(l2-ac_index(end)));
    AC_RR=[AC_RR Post_RR2];
else
    AC_RR=[AC_RR];
end
%补0后重构RR间期序列
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AC_RR=[Pre_RR2 RR Post_RR2];
for i=1:l_ac_index
    for j=1:2*L
        seg_ac(i,j)=AC_RR(ac_index(i)+L-(ac_index(1)-1)-(L-j+1));
    end
end

%Step3 and Step4 Phase rectified and signal averaging 整序后求均值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PRSA_DC=mean(seg_dc,1);  %按列求均值
PRSA_AC=mean(seg_ac,1); 
plot(PRSA_DC);
%Step5 Quantification of DC and AC求DC、AC值 DC(AC)=[X(0)+X(1)-X(-2)-X(-1)]/4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DC=1000*(PRSA_DC(L+1)+PRSA_DC(L+2)-PRSA_DC(L)-PRSA_DC(L-1))/4;  
%AC=1000*(PRSA_AC(L+1)+PRSA_AC(L+2)-PRSA_AC(L)-PRSA_AC(L-1))/4;
sum1=0;
sum2=0;
for i=1:s
    sum1=sum1+1000*(PRSA_DC(L+i))/(2*s);  %s心率加速力、加速力计算长度
end
for i=0:(s-1)
    sum2=sum2+1000*(PRSA_DC(L-i))/(2*s);
end
DC=sum1-sum2
sum3=0;
sum4=0;
for i=1:s
    sum3=sum3+1000*(PRSA_AC(L+i))/(2*s);
end
for i=0:(s-1)
    sum4=sum4+1000*(PRSA_AC(L-i))/(2*s);
end
AC=sum3-sum4


