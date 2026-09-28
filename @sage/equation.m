function fh = equation(obj, eqnIdx, mode)
%EQUATION Defines function handle of approximated equation by sage. 

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
        obj sage 
        eqnIdx (1,1) double {mustBePositive}  
        mode (1,1) string {mustBeMember(mode, ["physical", "normalized"])} 
    end

    switch mode 
        case "physical" 
            coefs = obj.Coefficients{eqnIdx}; 
        case "normalized" 
            coefs = obj.CoefficientsNormalized{eqnIdx}; 
    end
    
    fh = @(x,u,t)obj.Basis.evalbf(x,u,t)*coefs ;     
    
end % of EQAUATION (Method of SAGE)

