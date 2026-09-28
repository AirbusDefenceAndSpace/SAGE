function basisConstant = type_constant(data, params)
%CONSTANT Defines a constant as basis function 

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
        data (1,1) sagedata 
        params (1,1) struct 
    end
    
    jacobi = basisjacobi(data.NumStates, data.NumInputs);
    jacobiFh = @(varargin) 0; 
    jacobiExpression = "0";
    for varIdx = 1:(data.NumStates + data.NumInputs)
        jacobi = jacobi.AddJacobian( jacobiFh, jacobiExpression, varIdx);
    end
        
    fh = @(varargin) 1; 
    basisConstant = basisfunction(fh, "constant", "1", jacobi);

end

