function libraryRow = evalbf(obj, x,u,t)
%EVALBF Evaluates library functions at a state and input sequence. 
%   Detailed explanation goes here

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
    libraryRow = zeros(1,nLibraryTerms); 

    for idx = 1:obj.SizeLibrary 
        fh = obj.LibraryFunctions(idx).Handle;
        libraryRow(1,idx) = fh(x,u,t);
    end 

end % of EVAL (Method of SAGEBASIS)

