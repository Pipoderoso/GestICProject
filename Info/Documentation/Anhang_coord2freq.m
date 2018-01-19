function signal   = toneGenerator(xCoord,yCoord,zCoord, Xmax, Xmin, Ymax, Ymin, Zmax, Zmin, calDone)
%INFO

nBits = 16; % Number of bits for each coordinate

columns = 3; 
rows = 2; 
maxHeight = (2^nBits)*1/2; %Key max Sensitivity height. Max Value = 2^nBits -1 
pos = 0;
outBounds = false; 
enable = true;


actualQuadrant = zeros(rows,columns); 
xArrayLimits = zeros(1,columns +1); 
yArrayLimits = zeros(1,rows +1); 


% CALIBRATION (Run only when calibration data has been gathered)
if (calDone == 1)
    % piecwise X-Function
    if (xCoord <= Xmin)
        xCoord = 0;
    end

    if (xCoord > Xmax)
        xCoord = 0;
    end
    % piecwise Y-Function
    if (yCoord <= Ymin)
        yCoord = 0;
    end

    if (yCoord > Ymax)
        yCoord = 0;
    end
    % piecwise Z-Function
    if (zCoord <= Xmin)
        zCoord = 0;
    end

    if (zCoord > Zmax)
        zCoord = 0;
    end
end
% END OF CALIBRATION


for i = 1:(columns+1)
    xArrayLimits(1,i) = (i-1) * power(2,nBits)/columns; 
end


for i = (1:rows+1)
    yArrayLimits(1,i) = (i-1) * power(2,nBits)/rows; 
end
 

for i = 2:(columns+1)
    if (xCoord > xArrayLimits(i-1)) && (xCoord < xArrayLimits(i))
        for j = 2:(rows +1)
            if (yCoord > yArrayLimits(j-1)) && (yCoord < yArrayLimits(j))
                actualQuadrant((j-1),(i-1)) = 1; 
                break;
            end
        end
        break;
    end
end

 
pos = find(actualQuadrant,1); % Position of "1" in matrix.  1 3 5 7
                              %                             2 4 6 8                                 

if (isempty(pos))
    outBounds = true; 
else
    outBounds = false;
end

if outBounds || (zCoord > maxHeight)
    enable = false;
else 
    enable = true; 
end

if (enable)
    signal = power(2,(pos(1)-1)/12) * 440; %440Hz base     
else
    signal = 0;
end


end
