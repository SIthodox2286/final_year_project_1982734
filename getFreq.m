function [extractedarray,tableformat] = getFreq(freqencies,Name,beginRECORD,endRECORD)
    % freqencies, the table
    % End of first day record in transition: 566
    % End of first day record in baseline: 629
    % Records are counted in minutes
    display(beginRECORD)
    
    if beginRECORD > endRECORD
        A = endRECORD;
        endRECORD = beginRECORD;
        beginRECORD = A;
    end

    tableformat = freqencies(freqencies.RECORD>=beginRECORD,{Name,'RECORD','Time'});
    tableformat = tableformat(tableformat.RECORD<=endRECORD,{Name,'Time'});
    extractedarray = [(beginRECORD:endRECORD)',table2array(tableformat(:,1))];
    
end

