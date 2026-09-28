classdef basisjacobi
%BASISJACOBI Helper class for SAGE-Toolbox to wrap jacobi implementation. 
% 
%   obj = BASISJACOBI(numStates, numInputs) initializes jacobi object with  appropriate dimensions
%
%   To define the individual basis functions call: 
%   obj = AddJacobian(obj, fh, expression, idx, idxType) 
%       inputs: obj (jacobianbasis) 
%               fh (function handle) - evaluation of jacobi. must be of the
%                   structure value = fh(x,u,t) where 
%                       "x" is full state sequence, 
%                       "u" is full input-sequence, 
%                       "t" is current time value    
%               expression - string of mathematical expression
%               varIdx  - variable index defining which state/input
%               idxType - (string) "variable", "state" or "input" 
%                   defines if varIdx refers to the state idex
%                   "state", input index ("index") or a combined indexing
%                   "variable" (default).
%                       Clarification for "variable", for a system with 
%                       3 states and 2 inputs, varIdx = 4 refers to input1. 
    
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

    properties
        Handles (:,1) cell 
        Expressions  (:,1) string 
    end

    properties (Hidden, SetAccess = immutable)
        NumStates
        NumInputs
    end
    
    methods
        function obj = basisjacobi( numStates, numInputs )
            
            arguments 
                numStates (1,1) double {mustBeNonnegative} % number of statevariables in basis function
                numInputs (1,1) double {mustBeNonnegative} % number of inputvariables in basis function
            end

            obj.NumStates = numStates; 
            obj.NumInputs = numInputs; 

            % pre-allocate data 
            for idx = 1:(numStates + numInputs) 
                obj.Expressions(idx) = "Unknown"; 
                obj.Handles{idx} = @(varargin) 0; 
            end
            

        end % of Constructor of BASIS-JACOBIAN
   
        
        function obj = AddJacobian(obj, fh, expression, varIdx, idxType )
            % ADDJACOBIAN (Method of BASISJACOBI) Definition of jacobi wrapper.  
            %
            %   obj = AddJacobian(obj, fh, expression, idx, idxType) 
            %       inputs: obj (jacobianbasis) 
            %               fh (function handle) - evaluation of jacobi. must be of the
            %                   structure value = fh(x,u,t) where 
            %                       "x" is full state sequence, 
            %                       "u" is full input-sequence, 
            %                       "t" is current time value    
            %               expression - string of mathematical expression
            %               varIdx  - variable index defining which state/input
            %               idxType - (string) "variable", "state" or "input" 
            %                   defines if varIdx refers to the state idex
            %                   "state", input index ("index") or a combined indexing
            %                   "variable" (default).
            %                       Clarification for "variable", for a system with 
            %                       3 states and 2 inputs, varIdx = 4 refers to input
            arguments 
                obj basisjacobi
                fh function_handle 
                expression (1,1) string 
                varIdx (1,1) double {mustBeNonnegative}
                idxType (1,1) string {mustBeMember(idxType, ["variable", "state", "input"])} = "variable"
            end

            % validate index and determine varIndex
            switch idxType 
                case "variable" 
                    if varIdx > obj.NumStates + obj.NumInputs 
                        error("Invalid Index - Exceeds number of variables.")
                    end
                    varIdx = varIdx;
                case "state"
                    if varIdx > obj.NumStates 
                        error("Invalid Index - Exceeds number of states.")
                    end
                    varIdx = varIdx; 
                case "input"
                    if varIdx > obj.NumInputs 
                        error("Invalid Index - Exceeds number of inputs.")
                    end
                    varIdx = varIdx + obj.NumStates;
            end
           
            % populate entries 
            obj.Handles{varIdx} = fh; 
            obj.Expressions(varIdx) = expression;
        end
    end
end % of Classdefinition BASISJACOBI

