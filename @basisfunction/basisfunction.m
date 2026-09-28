classdef basisfunction
%BASISFUNCTION Helper class for SAGE-Toolbox to wrap basisfunction implementation. 
%  
% obj = BASISFUNCTION( fh, type, expression, jacobi ) 
%   inputs: fh (function handle) evaluation of the basisfunction
%               must be of the structure value = fh(x,u,t) where 
%               "x" is full state sequence, 
%               "u" is full input-sequence, 
%               "t" is current time value
%           type (string) to specify the basis-type 
%           expression (string) string of mathematical expression 
%           jacobi (jacobibasis) object to describe jacobi of basisfunction

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

    properties (SetAccess = immutable)
        Type (1,1) string
        Expression (1,1) string 
        Handle function_handle
        Jacobi basisjacobi             
    end
    
    methods
        function obj = basisfunction(fh, type, expression, jacobi )
            %BASISFUNCTION constructor
            arguments 
                fh function_handle
                type (1,1) string 
                expression  (1,1) string
                jacobi (1,1) basisjacobi
            end 

            obj.Handle = fh; 
            obj.Type = type;
            obj.Expression = expression; 
            obj.Jacobi = jacobi;
        end % of constructor 
    end

    methods 
        % provides row vector where jacobi of basis function are evaluated
        % with respect to each state and input  the state and input order 
        % is the same as in corresponding sagedata object (states first) 
        jacobiRow = evaljacobi(obj, x,u,t);
    end
end

