function variableNames = defaultnames(obj, varType)
%DEFAULTVARIABLES Assigns default names to all variables. 
%   
%   Defines the default variable names, based on the data dimensions. 
%   Targets are by default "gamma", states "x" and inputs "u". The target 
%   could be "x dot" for continuous time, "x(k+1)" for discrete time or 
%   "y" for some output. To keep it generic and prevent confusion "gamma" was selected. 

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
        obj (1,1) sagedata 
        varType (1,1) string {mustBeMember(varType, ["Targets", "States", "Inputs"])} = "Target"
    end

    % define default names for each variable type 
    lookup = struct();
    lookup.Targets = "gamma"; 
    lookup.States = "x"; 
    lookup.Inputs = "u"; 

    % determine number of variables for this specific type 
    numFunc = "Num"+varType; 
    nVars = obj.(numFunc);

    % construct array of variable names 
    variableNames = lookup.(varType) + string(1:nVars);

end % of DEFAULTS (sagedata method)

