classdef sageoptions
%SAGEOPTIONS Creates an option list for the SAGE-Toolbox
%
%   Opt = SAGEOPTIONS returns the default settings. 
%   
%   Opt = SAGEOPTIONS( presets ) applies presets to the settings. 
%           >presets< must be a struct where each field must have a
%           corresponding option in the list. 
%   ------------------------------------------------------------------- 
%
%   General Settings:
%       RegressionAlgorithm             Specifies method for regularized regression.
%       SparsityParameter               Coefficients for l1-regularization term.      
%       CoefficientThreshold            Normalized coefficients below threshold are set to zero.    
%       BiasThreshold                   Bias below threshold are set to zero.   
%       BasisExtractionAlgorithm        Specifies method to obtain a well-conditioned basis matrix.
%   -------------------------------------------------------------------                          
%
%   Available basisfunctions/library functions and their options:
%       Constant            Toggles a constant value as basis function.
%      
%       Monomials           Toggles monomials as basis functions.                 
%       MonomialsOrder      Specifies the monomial orders used as basis functions  
%       MonomialsType       Specifies how to interprete the 'MonomialsOrder'- parameter    
%                               'max' - takes largest value in 'MonomialsOrder' and uses all monomials upto this order 
%                               'explicit' - uses only the orders specified by the array 'MonomialsOrder'
%
% See also SAGE, SAGEDATA

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

    properties (Access = public)
        RegressionAlgorithm (1,1) string {mustBeMember(RegressionAlgorithm, ["l1_ls_Koh"])} = "l1_ls_Koh"
        SparsityParameter (1,1) double {mustBeNumeric, mustBeNonnegative} = 0.01
        CoefficientThreshold (1,1) double {mustBeNumeric, mustBeNonnegative} = 1e-3 
        BiasThreshold (1,1) double {mustBeNumeric, mustBeNonnegative} = 1e-7 
        BasisExtractionAlgorithm (1,1) string {mustBeMember(BasisExtractionAlgorithm, ["qrDecomposition", "none"])} = "qrDecomposition"
        
        % Properties for Basis-Functions
        Constant (1,1) string {mustBeMember(Constant, ["on", "off"])} = "on"

        Monomials (1,1) string {mustBeMember(Monomials, ["on", "off"])} = "on"
        MonomialsType (1,1) string {mustBeMember(MonomialsType, ["max", "explicit"])} = "max"
        MonomialsOrder (1,:) double {mustBeInteger} = 1
    end

    methods % Constructor
        function obj = sageoptions( presets )
            %SAGEOPTIONS Creates option list for the SAGE-Toolbox.
            % Default values are specific in the property definitions. 

            arguments 
                presets struct = struct() 
            end
            
            if nargin == 1 % if presets are provided
                obj = obj.import(presets);  % overwrite default values with presets
            end
        end
    end % of SAGEOPTIONS constructor


    methods 
        allProperties = inspect(obj) 
        obj = import(obj, newOpt)
    end

    

end

