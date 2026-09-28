function data = prop(obj, U, T, x0, refX)
% PROP Propagates approximate equation forward in time. 
%
%

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

    arguments 
        obj (1,1) sage 
        U (:,:) double {mustBeNumeric} 
        T (:,1) double {mustBeNumeric} = []
        x0 (:,1) double {mustBeNumeric} = []
        refX (:,:) double {mustBeNumeric} = [] 
    end
    
    % setting flag for plot 
    if nargout == 0
        plotFlag = true;
    else 
        plotFlag = false; 
    end

    % setting flag for reference in plot 
    if ~isempty(refX) 
        if size(refX) == size(U) 
            hasReference = true; 
        else    
            hasReference = false; 
            warning('Dimensions of >reference data< does not match >input data<')
        end
    else 
        hasReference = false; 
    end


    nSample = size(U,1);
    nU = obj.Data.NumInputs;
    nX = obj.Data.NumStates; 
    nEqn = obj.Data.NumTargets; 
    
    % ------------------------------------------ %
    % -- custom input validation and defaults -- % 
    % ------------------------------------------ %

    % -- Input Matrix 
    % Note: this does not check if the approximated equation has any term
    % that actually depends on an input. 
    if nU ~= size(U,2)
        error("Number of inputs does not match regression data.")
    end
    
    % -- Time Vector
    if isempty(T) 
        T = 0:obj.Data.Ts:(nSample-1)*obj.Data.Ts;
    else 
        if length(T) ~= size(U,1) 
            error("Dimensions of input-data and time-vector do not match.") 
        end
    end

    if isempty(x0) % default - zero initial conditions
        x0 = zeros(1,nX); 
    else 
        % check correct dimensions of 
        if size(x0,1) ~= nX
            error("Invalid size of initial state-vector.")
        end
    end
    

    % pre-allocation 
            nT = length(T); 
            data = zeros(nT, nX); 
            data(1,:) = x0;
           for eqnIdx = 1:nEqn  
            % local reference to the equation handle, so I dont need to
            % access the object in each object. 
            % i dont know, if this brings any performance improvement in
            % matlab but this is standard practice in lua for optimization
            eqn{eqnIdx} = obj.Equations{eqnIdx};
           end
           for tIdx = 1:nT-1 
                t = T(tIdx);
                x = data(tIdx,:);
                u = sagebasis.sample(U, tIdx);
                for eqnIdx = 1:nEqn 
                    data(tIdx+1,eqnIdx) = eqn{eqnIdx}(x,u,t);
                end

           end

    switch obj.Data.TimeDiscretization
        case "discrete" 

        case "continuous" 
            data = (data'-x)/obj.Data.Ts;
    end
    

     % create plot if no output argument exists 
    if plotFlag 
                
        % calculate maximum error for subplot title
        if hasReference 
            errorSignal = abs(refX-data);
            [maxError, maxErrorIdx] = max(errorSignal);
        end
    
        % creates plot
        figName = obj.Name + " - Propagation (" + obj.Data.TimeDiscretization+ ")";
        figure("Name", figName)
        tiledlayout(2*nEqn,4)
        for idx = 1:nEqn 
            nexttile([2,4])
            hold off 
            if hasReference 
                plot(T, refX(:,idx))
            else 
                plot(T, data(:,idx)) 
            end 
            hold on 
            if hasReference 
                plot(T, data(:,idx)) 
                legend("Reference", "Propagation")
            end
            grid on 
            
            if hasReference 
                title("AbsoluteMaxError: " + string(maxError(idx)) +  " at " + string((maxErrorIdx(idx)-1)*obj.Data.Ts) + " " + obj.Data.TimeUnit)
            end
            xlabel("Time (" + obj.Data.TimeUnit + ")")
            ylabel(obj.TargetNames(idx))
        end
        sgtitle(figName)

    end % of plot-routine

end % of PROP (Method of SAGE) 

