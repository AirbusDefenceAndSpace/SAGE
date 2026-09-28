function mustMatchDataSize(obj, newNames, type) 
%MUSTMACHDATASIZE Verifies dimensions of name arrays.
%
%   The number of names must match to the number of columns in the
%   corresponding matrix. 

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
        obj sagedata
        newNames (1,:) string {mustBeText} 
        type (1,1) string {mustBeMember(type, ["Targets", "States", "Inputs"])}
    end
    
    num = obj.("Num" + type);   % obtain number of columns dynamically
    if size(newNames,2) ~= num 
        error("Dimension of NameArray for " + type + " must match number of columns in data matrix.")
    end

end

