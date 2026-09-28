function coefsNorm = regression(opt, stdTarget, stdBasis)
%REGRESSION Wrapper function to perform the regularized regression

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
        opt sageoptions 
        stdTarget {mustBeNumeric}
        stdBasis {mustBeNumeric} 
    end

    % ------------------------------- %
    % -- L1-Regularized Regression -- %
    % ------------------------------- % 
    
    % grab parameters from options 
    method = opt.("RegressionAlgorithm");
    lambda = opt.("SparsityParameter"); 
    epsilon = opt.("CoefficientThreshold");
    
    % coefReg - coefficients directly obtained from numerical regression 
    % same number of entries as columns in 'BasisMatrixStd'
    switch method
        case "l1_ls_Koh"    % @todo update method definition 
            tol = 1e-3;     
            quite = 1;     
            coefsReg = sage.Reg_l1_ls_Koh(stdBasis, stdTarget, lambda , tol, quite );
    end 
    
    % set coefficients below threshold to zero in standardized domain 
    % (they are not exact zero for numerical reasons in regression) 
    coefsReg( abs(coefsReg) < epsilon) = 0; 

    % list of all indeces in 'regCoefs' that have a nonzero value 
    % indeces are with respect to the basis-matrix (only independent
    % columns) - use 'IndependentColumns' property of sagebasis to map to
    % library-matrix 
    nonZeroCoefsReg = find(coefsReg ~= 0); 
    
    coefsNorm = zeros(size(coefsReg,1),1); 
    coefsNorm( nonZeroCoefsReg, :) = stdBasis(:, nonZeroCoefsReg) \ stdTarget; 

end % of REGRESSION (Static-Method of SAGE) 

