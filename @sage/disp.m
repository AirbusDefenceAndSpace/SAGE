function disp(obj, mode)
%DISP Displays approximated governing equations. 
%
%   DISP(SAGE, mode) Prints the approximated governing equation(s)
%       determined by SAGE. Only terms with non-zero coefficients are shown.
%       The optional >mode< specifies, if the "physical" or "normalized"
%       coefficients are displayed. Default is "physical". 

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
        obj (:,:) sage 
        mode (1,1) string {mustBeMember(mode, ["physical","normalized"])} = "physical"
    end
   
    tableWidth = 60; % defines size of separators

    % Title
    fprintf('%s\n', repmat('-', 1, tableWidth));
    if mode == "normalized" 
        fprintf("Normalized ")
    end
    fprintf('Equations for >')
    fprintf(obj.Name)
    fprintf('<\n')
    fprintf('%s\n', repmat('-', 1, tableWidth));

    for eqnIdx = 1:1:obj.Data.NumTargets
        switch mode 
            case "physical" 
                eqnStr = ['Eqn',char(string(eqnIdx)),': ',char(obj.TargetNames(eqnIdx)),' = '];
            case "normalized" 
                eqnStr = ['Eqn', char(string(eqnIdx)), ' (normalized): ' char(obj.TargetNames(eqnIdx)),' = '];
        end

        nonZeroCoefs = obj.NonZeroCoefs{eqnIdx}; % list of non-zero coefficients 
        for idx = 1:numel(nonZeroCoefs) 
            libraryIdx = nonZeroCoefs(idx); % library index for basisfunction
            if libraryIdx == obj.IndexConstantBasis % dont need the "1*" for constant
                termStr = '';
            else 
                fctExpression = char(obj.Basis.LibraryFunctions(libraryIdx).Expression);
                termStr = ['*', fctExpression];
            end

            switch mode
                case 'physical'
                    coef = obj.Coefficients{eqnIdx}(nonZeroCoefs(idx) );
                case 'normalized'
                    coef = obj.CoefficientsNormalized{eqnIdx}( nonZeroCoefs(idx) );
            end
            if coef > 0 && idx > 1
                signStr = ' + '; % add a plus for all but the first term, if the coefficient is positive
            else 
                signStr = ' '; % negative coefficients have the sign build in 
            end
            eqnStr = [eqnStr, signStr, num2str(coef), termStr];
        end

        disp(eqnStr)    
    end % of loop over equations
    fprintf('%s\n', repmat('-', 1, tableWidth));

end % of DISP (overloaded matlab function for SAGE) 
