function [coefs, bias] = invstandardize(coefsNorm, normBasis, meanBasis, normTarget, meanTarget)
%INVSTANDARDIZE Reverts standardization of coefficients. 
    
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
    
    coefs = coefsNorm./ normBasis'*normTarget; 
    bias = meanTarget - meanBasis*coefs;

end % of INVSTANDARDIZE (Static-Method of SAGE) 

