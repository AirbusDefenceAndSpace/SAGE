classdef sage
% SAGE - Regularized regression with nonlinear basis functions.
%
%   obj = SAGE( SAGEDATA ) performs regularized regression for the provided
%       SAGEDATA. It uses the default SAGEOPTIONS. 
%   
%   obj = SAGE( SAGEDATA, SAGEOPTIONS ) performs regularized regression for 
%       the provided SAGEDATA. It uses the provided SAGEOPTIONS. 
% 
%   See also SAGEDATA, SAGEOPTIONS.  

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
        Name (1,1) string = "SageObj"
        % can be used as a unique identifier for the object
    end
    
    properties (SetAccess = immutable) 
        Coefficients
        % cell array - one cell contains the >numeric array< of the
        % coefficients for each basisfunctions for the governing equation
        % of one target quantity. 
        
        Equations
        % cell array - one cell contains the >function handle< for the
        % approximated governing equation of one target quantity.
        


        Bias
        % bias between provided data and data fit, calculated when undoing
        % the standardization of the provided data. This property shows the 
        % true value and is not impacted by the 'BiasThreshold' property. 

        Options sageoptions 
    end
    
    properties (Dependent)  % access wrapper for 
        TargetNames   % TargetNames of hidden 'data' property of type SAGEDATA
        StateNames % StateNames of hidden 'data' property of type SAGEDATA
        InputNames  % InputNames of hidden 'data' property of type SAGEDATA
        BasisTerms % expression of each BasisFunction of of hidden 'basis' property of type SAGEBASIS
    end

    properties (SetAccess = public) 
        Notes (:,:) string {mustBeText}
    end

    properties (Hidden, SetAccess = immutable)
        Data sagedata 
        Basis sagebasis
        CoefficientsNormalized
        % cell array - one cell contains the >numeric array< of the
        % normalized coefficients for each basisfunctions for the governing 
        % equation of one target quantity. 

        EquationsNormalized
        % cell array - one cell contains the >function handle< for the
        % approximated normalized governing equation of one target quantity.
        Meta struct
    end 

    properties (Hidden, SetAccess = immutable)
        BasisStd 
        BasisNorm 
        BasisMean 
        TargetStd
        TargetNorm 
        TargetMean 
        NonZeroCoefs        % NonZeroCoefs of in LibraryIndeces
        IndexConstantBasis  % Index of Constant in LibraryIndeces (only needed for display)  
                                % if there are multiple constants, only one
                                % can have a NonZero-Coefficient 
    end
 

    methods 
        function obj = sage( data, opt )
            %SAGE Constructor
            arguments 
                data sagedata 
                opt sageoptions = sageoptions   % applies defaults if non are provided
            end 
            
            sageTime = tic; 

            % store input data for traceability (immutable)
            obj.Options = opt;  
            obj.Data = data;    % hidden
            obj.Basis = sagebasis(data, opt);   % hidden
            obj.Meta = struct( "TimeStamp", datetime("now"));   % hidden
            


            % --------------------- %
            % -- Standardization -- %
            % --------------------- % 
            [stdBasis, normBasis, meanBasis] = obj.standardize(obj.Basis.BasisMatrix); 
            [stdTarget, normTarget, meanTarget] = obj.standardize(obj.Data.DataGamma); 
            
            % check for time-series with constant value 
            idxConstBasis = find(normBasis == 0); % can only be one, because the basis matrix is well-conditioned
            idxConstTarget = find(normTarget == 0); % can be a vector, as targets are independent and unique
            
            % remove it from basis, as they are NaN entries in 'stdBasis'
            stdBasis(:,idxConstBasis) = [];
            normBasis(idxConstBasis) = []; 
            meanBasis(idxConstBasis) = [];
            
            % handle constant targets 
            if ~isempty(idxConstTarget) 
                error("Invalid Targetdata. Targetdate should not be a constant")
                % @todo, perform regression for constant targets. 
                    % if target is zero, perform regression for zero 
                    % if target is anything but zero, set it to one and
                    % perform regression, the result can then be scaled 
                    % check if there is a constant basis function, because
                    % then the result will always be trivial and does not
                    % make a lot of sense. 
            end

            obj.BasisStd = stdBasis; 
            obj.BasisNorm = normBasis; 
            obj.BasisMean = meanBasis; 
            obj.IndexConstantBasis = obj.Basis.IndependentColumns(idxConstBasis);
            obj.TargetStd = stdTarget; 
            obj.TargetNorm = normTarget; 
            obj.TargetMean = meanTarget;


            % ----------------------------------- %
            % -- Identification of Equation(s) -- %
            % ----------------------------------- %
            numEqn = obj.Data.NumTargets;
            for idx = 1:numEqn
                % Regression 
                regTime = tic;
                coefsNorm = sage.regression(obj.Options, stdTarget(:,idx), stdBasis);
                obj.Meta.("ElapsedTimeRegression") = toc(regTime);

                [coefs, bias] = sage.invstandardize( coefsNorm, normBasis, meanBasis, normTarget(idx), meanTarget(idx)); 
                % Undo-Standardization 
%                 coefs = coefsNorm./ normBasis'*normTarget(idx); 
%                 bias = meanTarget(idx) - meanBasis*coefs;
                
                % Address constant basis function 
                if ~isempty(idxConstBasis) 
                    % coefficient of constant in normalized data is always zero
                    coefsNorm = [coefsNorm(1:idxConstBasis-1); 0; coefsNorm(idxConstBasis:end)];
                    
                    mu = obj.Options.("BiasThreshold");
                    coefConst = bias*(abs(bias)>mu);
                    coefs = [coefs(1:idxConstBasis-1); coefConst; coefs(idxConstBasis:end)];
                    obj.Bias = bias;
                end

                % Remap Coefficients to selected library
                obj.CoefficientsNormalized{idx} = coefsNorm;
                obj.Coefficients{idx} = coefs;
                obj.NonZeroCoefs{idx} = find(obj.Coefficients{idx} ~= 0);
            end
            
            % ---------------------------- %
            % -- Build Function Handler -- %
            % ---------------------------- %
            
            for eqnIdx = 1:numEqn 
                obj.Equations{eqnIdx} = equation(obj, eqnIdx, "physical");
                obj.EquationsNormalized{eqnIdx}  = @(t,x,u) equation(obj, eqnIdx, "normalized");
            end

            obj.Meta.("ElapsedTimeTotal") =  toc(sageTime);
         
    
        end % of SAGE constructor
    end % of methods for constructor
    

    % ------------------------------------- %
    % -- Getter for Dependent Properties -- %
    % ------------------------------------- % 
    methods       
        function label = get.TargetNames(obj) 
            label = obj.Data.TargetNames;
        end
        
        function names = get.StateNames(obj) 
            names = obj.Data.StateNames;
        end

        function names = get.InputNames(obj) 
            names = obj.Data.InputNames;
        end

        function terms = get.BasisTerms(obj) 
            for ii = 1:obj.Basis.SizeLibrary 
                terms(1,ii) = obj.Basis.LibraryFunctions(ii).Expression;
            end
            terms = terms';
        end
    end


    % ------------- %
    % -- Methods -- %
    % ------------- %

    methods (Static, Access = public)  
        [stdVal, normVal, meanVal] = standardize(mat)
        coefsNorm = regression(opt, stdTarget, stdBasis ) % wrapper for regression
        metrics = errormetrics( signal ) % calculated regression error metrics
        [coefs, bias] = invstandardize( coefsNorm, normBasis, meanBasis, normTarget, meanTarget);
    end

    methods (Access = public) 
        data = prop(obj, U, T, x0)  % propagating approximated equation(s)
        allProperties = inspect(obj)    % provides a struct with all properties. also the hidden onces. 
        coefs(obj, mode)    % display all coefficients 
    end
    
    methods (Access = private)
        val = equation(obj) 
    end
    
    % --------------------------- %
    % -- Regression Algorithms -- %
    % --------------------------- %
    
    methods (Static) 
        coefs = Reg_l1_ls_Koh(stdBasis, stdTarget, lambda, tol, quite);
    end

    % ----------------------------- %
    % -- Overload Matlab Methods -- %
    % ----------------------------- % 

    methods (Access = public)
        disp(obj, mode)          
        data = fit(obj) 
    end

end

