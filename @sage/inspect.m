function allProperties = inspect(obj)
%INSPECT Provides a list of all class properties. 
%   The list includes properties that are hidden or have a private
%   get-access. This function is intended for unique usecases and debugging. 

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
    propertyNames = {meta.PropertyList.Name};

    allProperties = struct();
    for idx = 1:numel(propertyNames)
        name = propertyNames{idx};
        allProperties.(name) = obj.(name);
    end

end % of INSPECT ( Method of SAGE ) 

