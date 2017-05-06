% % -------------------------------------------------------------------------
% %将RR_4h数据写入txt文本中
% datafile = fopen('ganxiaowu_00_V5_4h_7_08_11_08_hrv.txt','w');
% for i=1:length(RR_4h)
%     fprintf(datafile,'%0.4f\n', Res.HRV.Data.RR(i));
% end
% fprintf(datafile,'\n');
% fclose(datafile);

ibi=importdata('ganxiaowu_00_V5_4h_7_08_11_08_hrv.txt');
IBI=zeros(length(ibi),2);
IBI(:,2)=ibi;
IBI(1,1)=0;
for i=2:length(ibi)
    IBI(i,1)=IBI(i-1,1)+ibi(i-1);
end
% -------------------------------------------------------------------------
%将IBI数据写入txt文本中
datafile = fopen('IBI_ganxiaowu_00_V5_4h_7_08_11_08_hrv.txt','w');
for i=1:length(IBI)
    fprintf(datafile,'%0.4f,%0.4f\n', IBI(i,:));
end
fprintf(datafile,'\n');
fclose(datafile);
