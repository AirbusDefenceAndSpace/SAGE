function sampled = sample(mat,idx)
%SAMPLE Returns specific row of the provided matrix. 
%   
%   This helper function only ensures that the index does not exceed the
%   number of array elements for empty states/inputs/time and the state and
%   input vectors have correct dimensions when evaluating the basis
%   functions. 
 
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

    if isempty(mat) 
        sampled = [];
    else 
        sampled = mat(idx,:);
    end

end

