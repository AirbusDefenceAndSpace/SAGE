function mustMatchNumSamples(arg,ref)
%MUSTMATCHNUMSAMPLES Verify number of samples in data matrices. 
%
% The number of rows in Gamma is used as a reference value. If any other
% data matrix or the time vector is not empty, their number of rows must be
% identical with the number of rows in Gamma. 

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

    if ~isempty(arg)  
        if size(arg,1) ~= size(ref,1)
            error("Number of samples does not match dimension of target data.")
        end
    end

end

