function bool = isenabled( obj, propertyName )
%ISENABLED Converts flag (string-property) to a logical.
%
% bool = isenabled(obj, propertyName) 
%   Returns the logical value that corresponds to a flag-string. 
%   If the property does not exist or is not of the propper format 
%   (must be "on" or off") an error is triggered. 
     
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
        propertyName (1,1) string 
    end

    hasProperty = isprop(obj, propertyName); %check if property exists 
    if hasProperty 
        property = obj.( propertyName );
        if ~isstring(property) % flags can only be strings 
            error("Attempted flag parse on the non-flag property '"+ propertyName +"'.")
        end
        switch property % parse the property 
            case "on" 
                bool = true;
            case "off" 
                bool = false;
            otherwise 
                error("Attempted flag parse on the non-flag property '"+ propertyName +"'.")
        end
    else 
        error("Attempted flag parse on the non-existing property '"+ propertyName +"'.")
    end

    
end % of ISENABLED (Method of SAGEOPTIONS)

