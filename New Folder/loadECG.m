function ECG=loadECG(f)
    % loadIBI: function to load ibi data file into array    
        if ~exist(f,'file')
            error(['Error opening file: ' f])
            return
        end                
        
        ibi=[]; 
        DELIMITER = ',';
%         HEADERLINES = opt.headerSize;

        %read ibi
        tmpData = importdata(f, DELIMITER);
%         if HEADERLINES>0
%             tmpData=tmpData.data;        
%         end        

        %check ibi dimentions
        fre=500;
        ECG=zeros(length(tmpData),2);
        ECG(1,1)=0;
        ECG(1,2)=tmpData(1);
        for i=2:length(tmpData)
            ECG(i,1)=(i-1)/fre;
            ECG(i,2)=tmpData(i);
        end                  
        clear tmpData      
    end