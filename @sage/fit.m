function data = fit(obj)
%FIT Calculates and displays the fit of the regression result. 
%   
%   
%   fit( SAGE ) draws the time series of the reference target data (Gamma) 
%       and the regression fit (Theta*Xi) for each equation. 
%       Annotates the maximum absolute error. 
%
%   data = fit( SAGE ) returns the datapoints of the obtained regression 
%       fit (Theta*Xi). Is a matrix where one column corresponds to one 
%       target quantity. 

% -------------------------------------------------------------------------  
% This File is part of the SAGE-Toolbox: 
%                Sparse Approximation of Governing Equations 
%       
% Repository: https://github.com/AirbusDefenceAndSpace/SAGE
%
% Copyright (C) 2026, Sage Toolbox Authors. 
% SPDX-License-Identifier: GPL-2.0-only
% See LICENSE.txt for the full license text. 
% -------------------------------------------------------------------------
    
    % setting flag for plot 
    if nargout == 0
        plotFlag = true;
    else 
        plotFlag = false; 
    end
    
    % pre-allocation
    nSample = obj.Data.NumSamples; 
    nEqn = obj.Data.NumTargets;
    data = zeros(nSample, nEqn); 
    
    % loop over each equation and calculate data (Theta*Xi) 
    for eqnIdx = 1:nEqn 
        data(:, eqnIdx) = obj.Basis.LibraryMatrix*obj.Coefficients{eqnIdx}; 
    end

    % create plot if no output argument exists 
    if plotFlag 
        ref = obj.Data.Gamma;    
        
        % determines time vector 
        tVec = obj.Data.T; 
        % if non exists, calculates one based on time-step
        if isempty(tVec) 
            tVec = 1:obj.Data.Ts:obj.Data.Ts*nSample;
        end
        
        % calculate maximum error for subplot title
        errorSignal = abs(ref-data);
        [maxError, maxErrorIdx] = max(errorSignal);
    
        % creates plot
        figName = obj.Name + " - DataFit";
        figure("Name", figName)
        tiledlayout(2*nEqn,4)
        for idx = 1:nEqn 
            nexttile([2,4])
            hold off 
            plot(tVec, ref(:,idx)) 
            hold on 
            plot(tVec, data(:,idx))  
            grid on 
            legend("DataRef", "DataFit")
            title("AbsoluteMaxError: " + string(maxError(idx)) +  " at " + string((maxErrorIdx(idx)-1)*obj.Data.Ts) + " " + obj.Data.TimeUnit)
            xlabel("Time (" + obj.Data.TimeUnit + ")")
            ylabel(obj.TargetNames(idx))
        end
        sgtitle(figName)

    end % of plot-routine

end % of FIT (Method of SAGE) 
