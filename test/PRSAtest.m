clc;clear;
IBI=importdata('liaoxionghua_1h_V5_0_00_0_59.ibi');
T=1;s=1;th=0.2;L=32;
%function [DC, AC] = PRSA_Ts(rr,T,s,L,th)
%rrԭʼRR�������У�Tʱ�䴰��ȣ�s���ʼ����������������㳤��
%L��PRSA���еĳ��ȵ�һ�룬thΪ����RR���ڱ仯���޳���ֵ5%��10%��15%��20%��25%
%����ѡ��T=1,s=1,th=0.2; L�Խ����Ӱ��ǳ�С��һ��ѡ2^n��32��64��û������
Pre_RR=IBI;
%��ԭʼrr�������еĵ�һ��ֵ����������Pre_RR
%Pre_RR(1)=rr(1);

%�޳��쳣�㣬�������RR����ֵ���5%�������޳�������RR�������ֵ�޳�
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

%�޳��쳣���õ��µ�RR��������
%����ԭʼPre_RR=[0.6 0 0.5 0 0.4 0.3 0.2]����������Pre_RR(:, all(Pre_RR==0, 1))=[]��
%       Pre_RR=[0.6 0.5 0.4 0.3 0.2]
%Pre_RR(:, all(Pre_RR==0, 1)) = [];  %���޳��쳣��ʣ���RR��������ֵ�޷����ӵ�һ��
%lp=length(Pre_RR);  %�µ�RR�������еĳ���
%ys=rem(lp,5);  %��lp/5������
%Pre_RR=Pre_RR(1:lp-ys);  %ȷ���µ�RR�������г�����5�ı���
%RR=reshape(Pre_RR',[5 length(Pre_RR')/5])'; %������һ��Pre_RR'��������ȡ��Ԫ�أ�
                                             %�����ó�5�� length(Pre_RR')/5 �еľ���
%RR=mean(RR,2);  %�����RR���еľ�ֵ
lp=length(Pre_RR);
ys=rem(lp,T);  %��lp/T������
Pre_RR=Pre_RR(1:lp-ys);
Pre_RR=reshape(Pre_RR',[T length(Pre_RR')/T])';  %������һ��Pre_RR'��������ȡ��Ԫ�أ�
                                             %�����ó�T�� length(Pre_RR')/T �еľ���
Pre_RR=mean(Pre_RR,2); %�����Pre_RR���еľ�ֵ

l1=length(Pre_RR);
RR(1)=Pre_RR(1);

%�޳��쳣�㣬�������RR����ֵ���5%�������޳�������RR�������ֵ�޳�
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

%�޳��쳣���õ��µ�RR��������
RR(:, all(RR==0, 1)) = [];  %���޳��쳣��ʣ���RR��������ֵ�޷����ӵ�һ��
%Step1 definition of anchors��Ǽ��ٵ�ͼ��ٵ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n]=size(RR);
if m>n
    RR=RR';  %ȷ��RRΪ������
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

%���ٵ�ͼ��ٵ�RR����ֵ�Ͷ�Ӧ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dc_index(:, all(dc_index==0, 1)) = [];  %��������Ϊ0��Ԫ��ȥ����ʵ��ʣ��Ԫ�ص��޷�ƴ��
dc(:, all(dc==0, 1)) = [];
ac_index(:, all(ac_index==0, 1)) = [];
ac(:, all(ac==0, 1)) = [];
%Step2 definition of segments���庬���ٵ㡢���ٵ�����Ƭ��L=16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
l_dc_index=length(dc_index);
%L=32;
%�жϵ�һ�����ٵ�����һ�����ٵ��ܷ񹻹���һ������Ϊ2L��Ƭ�Σ�������0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seg_dc=zeros(l_dc_index,2*L);
if dc_index(1)<=L
    Pre_RR1=zeros(1,L-(dc_index(1)-1));  %��Ҫ��dc_index(1)ǰ�油�� L-(dc_index(1)-1)��0
    DC_RR=[Pre_RR1 RR];
else
    DC_RR=[RR];
end
if (l2-dc_index(end))<=L-1   %l2Ϊ�޳��쳣����µ�RR�������еĳ���
    Post_RR1=zeros(1,L-1-(l2-dc_index(end)));  %%��Ҫ��dc_index(end)���油�� L-1-(l2-dc_index(end))��0
    DC_RR=[DC_RR  Post_RR1];
else
     DC_RR=[DC_RR];
end
%��0���ع�RR��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DC_RR=[Pre_RR1 RR Post_RR1];
for i=1:l_dc_index
    for j=1:2*L
        seg_dc(i,j)=DC_RR(dc_index(i)-(L-j+1)+L-(dc_index(1)-1)); %dc_index(i)-(L-j+1)��û�п��ǲ�0����ŵı仯��L-(dc_index(1)-1)����ԭʼRR���е�һ��ֵǰ�油���0�ĸ���
    end
end
%�жϵ�һ�����ٵ�����һ�����ٵ��ܷ񹻹���һ������Ϊ2L��Ƭ�Σ�������0
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
%��0���ع�RR��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AC_RR=[Pre_RR2 RR Post_RR2];
for i=1:l_ac_index
    for j=1:2*L
        seg_ac(i,j)=AC_RR(ac_index(i)+L-(ac_index(1)-1)-(L-j+1));
    end
end

%Step3 and Step4 Phase rectified and signal averaging ��������ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PRSA_DC=mean(seg_dc,1);  %�������ֵ
PRSA_AC=mean(seg_ac,1); 
plot(PRSA_DC);
%Step5 Quantification of DC and AC��DC��ACֵ DC(AC)=[X(0)+X(1)-X(-2)-X(-1)]/4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DC=1000*(PRSA_DC(L+1)+PRSA_DC(L+2)-PRSA_DC(L)-PRSA_DC(L-1))/4;  
%AC=1000*(PRSA_AC(L+1)+PRSA_AC(L+2)-PRSA_AC(L)-PRSA_AC(L-1))/4;
sum1=0;
sum2=0;
for i=1:s
    sum1=sum1+1000*(PRSA_DC(L+i))/(2*s);  %s���ʼ����������������㳤��
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


