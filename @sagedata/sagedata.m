classdef sagedata
%SAGEDATA Handling of all data points used in sage-regression.
%   Helper class to support the core operation of the SAGE-Toolbox. It
%   collects and handles all data used in the regression and ensures
%   propper dimensions and formating. 
%   
%   obj = sagedata(Gamma,X,U,T,TDisc)
%
%       inputs: 
%           Gamma (double matrix) time series (columns) of all target quantities
%                       (left-side of the equation)  
%           X (double matrix - optional) time series (columns) of all states
%           U (double matrix - optional) time series (columns) of all inputs
%           T (double vector - options) time vector of provided data.
%           TDisc (string- optional) specifies time discretization. 
%               "continuous" or "discrete" (default) 
%    
%   By default, generic variable names "gamma*", "x*" and "u*" are set. 
%   Unique names can be assigned via the properties "TargetNames", 
%   "StateNames" and "InputNames". 
% 
%   See also SAGE, SAGEOPTIONS.  


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

    % ------------------- %
    % -- Data Matrices -- %
    % ------------------- %

    % Columns are time-series of one quantity. One row for each quantity. 
    properties (SetAccess = immutable)  % must be private for method "singletarget"
        Gamma   (:,:) double {mustBeNumeric}    % Targets-Matrix (Left-Side of Equation) 
        %   Targets are by default "gamma". The target could be "x dot" for continuous
        %   time, "x(k+1)" for discrete time or "y" for some output. To keep it
        %   generic and prevent confusion "gamma" was selected. 
        X       (:,:) double {mustBeNumeric}    % States-Matrix  
        U       (:,:) double {mustBeNumeric}    % Inputs-Matrix   
    end 
    
    % ---------- %
    % -- Time -- %
    % ---------- %  

    properties (SetAccess = immutable)
        T  (:,1) double {mustBeNumeric}    % Time-Vector
        Ts (1,1) double {mustBeNumeric, mustBePositive} = 1     % Time-Step, assumed constant 
        TimeDiscretization (1,1) string {mustBeMember(TimeDiscretization, ["discrete", "continous"])} = "discrete"
    end

    properties (Access = public) 
        TimeUnit (1,1) string = "Seconds"
    end

    % -------------------- % 
    % -- Variable Names -- % 
    % -------------------- %

    properties 
        TargetNames     (1,:) string {mustBeText} 
        StateNames      (1,:) string {mustBeText}
        InputNames      (1,:) string {mustBeText}   
    end
    
    methods % setter to ensure correct dimensions of name-arrays
        function obj = set.TargetNames(obj, newNames) 
            mustMatchDataSize(obj, newNames, "Targets")             
            obj.TargetNames = newNames;
        end

        function obj = set.StateNames(obj, newNames) 
            mustMatchDataSize(obj, newNames, "States")             
            obj.StateNames = newNames;
        end

        function obj = set.InputNames(obj, newNames) 
            mustMatchDataSize(obj, newNames, "Inputs")             
            obj.InputNames = newNames;
        end

    end

    % ------------- % 
    % -- Counter -- %
    % ------------- %

    properties (Hidden, SetAccess=immutable)   
        NumTargets
        NumStates 
        NumInputs
        NumSamples  % length of Gamma is reference for all data. 
    end


    % ------------------------------------------ %
    % -- Dependent Properties for Data-Access -- % 
    % ------------------------------------------ %
    
    % The regression implemented in 'SAGE' relies on those properties. 
    % This implementation ensures forward compatibility for additional
    % functionality (e.g. only using a selected time envelope for the
    % regression), without changes in the code of the 'SAGE'-class.  
    properties (Hidden, Dependent) 
        DataGamma
        DataX    
        DataU   
        DataT
    end
    % -- Getter for Dependent Properties -- % 
    % Those need to be adjusted with additional features. 
    methods 
        function Gamma = get.DataGamma(obj)
            Gamma = obj.Gamma;
        end

        function X = get.DataX(obj)
            X = obj.X;
        end

        function U = get.DataU(obj)
            U = obj.U;
        end

        function T = get.DataT(obj)
            T = obj.T;
        end
        
    end
    

    % ----------------- %
    % -- Constructor -- % 
    % ----------------- %   
    methods 
        function obj = sagedata(Gamma,X,U,T,TDisc)
            %SAGEDATA Constructor
            arguments 
                Gamma (:,:) {mustBeNumeric}  % numbers of samples in Gamma is reference 
                X (:,:) {mustBeNumeric, mustMatchNumSamples(X,Gamma)} = []
                U (:,:) {mustBeNumeric, mustMatchNumSamples(U,Gamma)} = []
                T (:,1) {mustBeNumeric, mustMatchNumSamples(T,Gamma)} = []
                TDisc (1,1) string {mustBeMember(TDisc, ["discrete", "continous"])} = "discrete" 
            end
            
            obj.NumSamples = size(Gamma,1);
            
            % initialize target data 
            obj.Gamma = Gamma; 
            obj.NumTargets = size(Gamma,2);
            obj.TargetNames = obj.defaultnames("Targets"); 

            % initialize state data
            obj.X = X; 
            obj.NumStates = size(X,2); 
            obj.StateNames = obj.defaultnames("States"); 
    
            % initialize input data
            obj.U = U; 
            obj.NumInputs = size(U,2);
            obj.InputNames = obj.defaultnames("Inputs"); 
            
            % initialize time information
            if isscalar(T)  % input T is timestep
                if T <= 0 % must be positive 
                    error("Scalar-Time")
                end
                obj.T = []; % time-vector is empty  
                obj.Ts = T; 
            elseif ~isempty(T) 
                obj.Ts = T(2)-T(1);
            end
            obj.T = T;
            obj.TimeDiscretization = TDisc;  
        end
    end % of SAGEDATA constructor


    % ----------------------- %
    % -- Method Definition -- % 
    % ----------------------- %
    methods 
        [varNames] = defaultnames(obj, varType)
    end

end % of class definition SAGEDATA

