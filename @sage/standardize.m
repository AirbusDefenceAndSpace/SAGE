function [stdVal, normVal, meanVal] = standardize(mat)
%STANDARDIZE Columnwise standardization of numeric matrix. 
%   (std, norm, mean) = STANDARDIZE(mat) 
%
%       mat - (numeric) input matrix / vector  
%       
%       mean    - mean value of each column in input matrix 
%       norm    - vector norm of each column in input matrix 
%       std     - standardized version of input matrix 

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
        mat (:,:) double {mustBeNumeric}
    end
    meanVal = mean(mat);   % vector / scalar if input is vector
    normVal = vecnorm(mat-meanVal,2,1);  % vector / scalar if input is vector
    stdVal = (mat-meanVal)./normVal;  % matrix / vector if input is vector
end

