function jacobiMat = evaljacobi(obj, x,u,t)
%EVALJACOBI Provides jacobi matrix of all basisfunctios at provided datapoint. 
%   Evaluates all jacobis of each basis function at the provided state and
%   input sequence and time point. Output is a matrix, where each row
%   corresponds to one basisfunction, and the columns corresponds to the
%   variables (first states, then inputs) 
   
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

    nLibraryTerms = obj.SizeLibrary;
    nVars = length(x) + length(u); 
    
    jacobiMat = zeros( nLibraryTerms, nVars );
    for bfIdx = 1:nLibraryTerms
        jacobiMat(bfIdx, :) = obj.LibraryFunctions(bfIdx).evaljacobi(x,u,t);
    end

end % of evaljacobi (Method of SAGEBASIS)

