function types = availableTypes(obj)
%AVAILABLETYPES List of all implemented basis types. 

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

    meta = metaclass(obj);  
    methodeList = string( {meta.MethodList.Name} ); % list of all existing methods 

    % Select methods whose names begin with the prefix.
    isBasisMethod = startsWith(methodeList, obj.PrefixTypeFiles);
    
    % Keep only the matching method names.
    methodeList = methodeList(isBasisMethod);
    
    % Remove the prefix from each matching method name.
    methodeList = extractAfter(methodeList, obj.PrefixTypeFiles);
    
    % Return the result as a cell array of character vectors.
    types = cellstr(methodeList(:));

end % of AVAILABLETYPES (Helper-Method of SAGEBASIS) 

