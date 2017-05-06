clc;clear;
A=[1;2;3;5;8;9;11];
B=[];
B(1)=A(1);
i=1;
for k=1:length(A)
       if A(k+1)-B(i)>2
          B(i+1)=A(k+1);
          i=i+1;
       end
end