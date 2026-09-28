function basisFunctions = type_monomials(data, params )
%MONOMIALS Defines a list of basis functions using monomials. 
%  

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
        data (1,1) sagedata 
        params (1,1) struct     % contains all parameter, based on a sageoptions
                                % object but preformated in sagebasis 
    end

    nX = data.NumStates;
    nU = data.NumInputs; 
    nVars = nX + nU;
    varNames = [data.StateNames, data.InputNames]; % stack state and input names

    switch params.Type 
        case 'max' 
            if isscalar(params.Order) 
                maxOrder = params.Order;
            elseif isarray(params.Order)  
                maxOrder = max(params.Order); 
            end
            orderList = 1:1:maxOrder; 
        case 'explicit'
            orderList = params.Order;
        otherwise 
            error("Monomials - Unknown Type")
    end
    
    counter = 0;    % no pre-allocation not possible for empty vector of 
                    % basis function in its current implementation 
    for idxOrder = 1:length(orderList) 
        order = orderList(idxOrder);

        % defines how the monomial is constructed 
        % factorsList is a matrix, the number of columns coinsides with current order
        % amout of rows is equal to unique monomials for this case based on current order and nVars
        % the numbers indicates which variables are multiplied
        % example: nVars = 4 and order = 4, which amounts to 35 individual monomials 
        % the 7th row reads: 1 1 2 4. This means the 7th monomial for this
        % case is var1*var1*var2*var4
        factorsList = nchoosek(1:nVars + order -1, order); 
        factorsList = factorsList - (0:order-1); 

        % define a basis function object for each monomial         
        for idxFactors = 1:size(factorsList)
            counter = counter + 1;
            factors = factorsList(idxFactors,:); 
            fhBasis = @(x, u, t) Fh_Monomial(x, u, t, factors);
            fctExpression = ConstructFunctionExpression(factors, varNames); 
            
            % define jacobi object 
            jacobi = basisjacobi(nX,nU); 
            for idxVar = 1:1:(nX+nU)
                jacobiExpression = ConstructJacobianExpression(factors, varNames, idxVar);
                jacobiFh = @(x,u,t,coef)Monomial_Jacobian(x,u,t,factors,idxVar); 
                jacobi = jacobi.AddJacobian(jacobiFh, jacobiExpression, idxVar);
            end
            basisFunctions(counter) = basisfunction(fhBasis, "monomial", fctExpression, jacobi); 
        end
    end
    

end % of function "basis_monomials"

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% %%%%% ----------------------------------------------------------- %%%%% %
% %%%%% -------------------- Helper Functions --------------------- %%%%% % 
% %%%%% ----------------------------------------------------------- %%%%% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

function val = Fh_Monomial(x,u,~,factors) 
    % stack states and inputs 
    vars = [x(:); u(:)];

    monomial = 1;
    for idx = 1:length(factors)
        monomial = monomial * vars(factors(idx));
    end

    val = monomial;
end


function expression = ConstructFunctionExpression(factors, varNames) 
    nVars = length(varNames);
    exponents = histcounts(factors, 1:(nVars+1));
    
    variables = {};
    for idx = 1:nVars 
       if exponents(idx) == 1
           variables{end+1} = varNames{idx};
       elseif exponents(idx) > 1
           variables{end+1} = sprintf('%s^%d', varNames{idx}, exponents(idx));
       end
    end
    expression = strjoin(variables, '*');
end



function val = Monomial_Jacobian(x,u,~,factors,idx) 
    % stack states and inputs 
    vars = [x(:); u(:)]; 
    
    nVars = length(vars);% termine number of variables 

    exponents = histcounts(factors, 1:(nVars+1)); % get exponents of each factor 

    coef = exponents(idx); % exponent of variab
    if coef == 0 
        val = 0;
    else 
        factors( find(factors==idx,1)) = [];    % remove one entry of the variable from the factors to have (exponent - 1) 
        jacobi = 1;
        for idx = 1:length(factors)
            jacobi = jacobi * vars(factors(idx));
        end
    
        val = jacobi*coef;
    end
end



function expression = ConstructJacobianExpression(factors, varNames, idx) 
    % idx - basis functions jacobian with respect to variable with this index
    nVars = length(varNames);% termine number of variables 
    exponents = histcounts(factors, 1:(nVars+1)); % get exponents of each factor 
    
    % -- calculate partial derivative 
    derivativeExponents = exponents; 
    coef = exponents(idx); % exponent becomes coefficient 
    derivativeExponents(idx) = exponents(idx)-1; % reduce exponent by one       
     
    % -- construct expression                
    if coef == 0                                
        expression = '0'; 
    else 
        % build expression analog to function 
        variables{1} = char(string(coef)); % add coefficient infront of expression %@todo, atm it also shows a "1*" if there are other terms  
        for idx = 1:nVars                                                                           
           if derivativeExponents(idx) == 1 
               variables{end+1} = varNames{idx};
           elseif derivativeExponents(idx) > 1
               variables{end+1} = sprintf('%s^%d', varNames{idx}, derivativeExponents(idx));
           end
        end
        expression = strjoin(variables, '*');
    end    
end


