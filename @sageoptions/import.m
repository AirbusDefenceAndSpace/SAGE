function [obj] = import(obj, newOptions)
% IMPORT Applies multiple settings.
%
%   obj = import(sageoptions, newOptions) 
%   Takes the provided SAGEOPTIONS object, applies all settings specified
%   in the struct >newOptions<, and returns the updated object. All fields
%   in >newOptions< must have the exact names as existing properties of
%   SAGEOPTIONS. 

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
        obj sageoptions 
        newOptions struct 
    end
    
    % copying fields from provided struct into sageoptions object 
    % names must match (including capitalization) 
    % does not handle subproperties of structs rekursively
    fields = fieldnames(newOptions); 
    for idx = 1:numel(fields) 
        optionName = fields{idx}; 
        optionValue = newOptions.(optionName); 
        
        obj.(optionName) = optionValue; 
    end

end % of IMPORT (Method of SAGEOPTIONS) 

