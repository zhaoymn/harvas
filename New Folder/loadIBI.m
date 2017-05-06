function ibi=loadIBI(f)
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
        [rows cols] = size(tmpData);                
        if rows==1 %all data in 1st row
            tmpData=tmpData';
            ibi=zeros(cols,2);
            tmp=cumsum(tmpData);
            ibi(2:end,1)=tmp(1:end-1);
            ibi(:,2)=tmpData;
        elseif cols==1 %all data in 1st col
            ibi=zeros(rows,2);
            tmp=cumsum(tmpData);
            ibi(2:end,1)=tmp(1:end-1);
            ibi(:,2)=tmpData;
        elseif rows<cols %need to transpose
            ibi=tmpData';
        else
            ibi=tmpData; %ok
        end                                      
        clear tmpData      
    end