function metrics = errormetrics( signal )
%ERRORMETRICS Calculates signal error metrics.
%
%   metrics = ERRORMETRICS( signal ) returns struct of error metrics for
%   the provided error-signal. The error-signal should be the difference 
%   between reference and target signal. If the >signal< is a matrix it will
%   be evaluated column-wise. The metrics are: 
%       MSE (mean squared error) 
%       MAE (mean absolut error) 
%       RMSE (root mean squared error) 
%       SSE (sum of squared errors) 
%       SAE (sum of absolute errors) 

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
        signal (:,:) double {mustBeNumeric} 
    end

    metrics = struct(); 
            metrics.("MSE") = mean(signal.^2,1);   
            metrics.("MAE") = mean(abs(signal),1);  
            metrics.("RMSE") = sqrt(mean(signal.^2));   
            metrics.("SSE") = sum(signal.^2, 1);     
            metrics.("SAE") = sum(abs(signal), 1); 
    
%     metrics.("Descriptions") = struct( ...
%         "MSE",  "mean squared error", ...
%         "MAE",  "mean absolute error", ...
%         "RMSE", "root mean squared error", ...
%         "SSE",  "sum of squared errors", ...
%         "SAE",  "sum of absolute errors");   

end % of ERRORS (Utilityfunction of SAGE) 

