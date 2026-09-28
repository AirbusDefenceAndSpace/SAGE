function subproperties = subprops(obj, property, returnType, format, includeMain )
%SUBPROPS Extract a struct or array of subproperties.
%   Subproperties are identified by using the name of their main property as prefix. 
%
%   out = SUBPROPS(obj, property, returnType, format, includeMain)
%
%   inputs: 
%       property    - name string of the main property 
%       returnType  - specifies variable type and contained information of
%                     the function output (default = 'values')
%                       'values'    - struct with properties
%                       'names'     - array with the propertynames 
%       format      - specifies string format of array output/ struct
%                     fieldNames (default = 'short') 
%                       'long'      - keeps the main property prefix
%                       'short'     - removes the main property prefix 
%       includeMain - specifies, if the main property is included in the output  
%                     if enabled, the main property is listed as 'Main' when 
%                     the format option 'short' is selected (default = false)            

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
        property (1,1) string 
        returnType (1,1) string {mustBeMember(returnType, ["values", "names"])} = "values"
        format (1,1) string {mustBeMember(format, ["long", "short"])} = "short"
        includeMain (1,1) logical = false
    end
    
    propertyNames = string(properties(obj)); % list of all options
    
    % identify properties that start with the property name
    % this also includes the main property
    indcs = startsWith( propertyNames, property);
    
    % list of properties only containing main property name as prefix
    specificPropertyList = propertyNames(indcs);
    
    % remove the main property from list, depending on 'includeMain' setting
    if ~includeMain 
        specificPropertyList(specificPropertyList == property) = []; 
    end
    
    switch returnType
        case "values"   % provides a structure with the property as fieldName  
            subproperties = struct();
            for ii = 1:numel(specificPropertyList)
                subprob = specificPropertyList(ii);  % name of the subproperty
                switch format 
                    case "short" 
                        fieldName = erase(subprob, property);   % remove main property prefix
                        if fieldName == "" 
                            fieldName = "Main"; % re-add main property as "Main"
                        end
                    case "long" 
                        fieldName = subprob;
                end                    
                subproperties.(fieldName) = obj.(subprob);  % add subproperty to struct  
            end
        case "names"    % provide an array of the field names 
            switch format 
                case "short" 
                    for ii = 1:numel(specificPropertyList)
                        subprob = specificPropertyList(ii); 
                        propName = erase(subprob, property); 
                        if propName == "" 
                            propName = "Main"; % re-add main property as "Main"
                        end
                        subproperties(ii,1) = propName;
                    end
                case "long" 
                    subproperties = specificPropertyList;
            end
    end

end % of SUBPROBS (Method of SAGEOPTIONS)

    