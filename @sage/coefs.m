function coefs(obj, mode)
%COEFS Displays approximated coefficients for each basisfunctions and equation.
%
%   COEFS( SAGE, mode ) lists the expression of all selected basisfunction
%       and the corresponding approximated coefficient for each equation. 
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
        obj (1,1) sage
        mode (1,1) string {mustBeMember(mode, ["physical","normalized"])} = "physical"
    end

    numEqn = obj.Data.NumTargets;
    numTerms = obj.Basis.SizeLibrary;

    % Formatting
    termWidth = 32;
    coefWidth = 18;

    termFormat = sprintf('%%-%ds', termWidth);
    coefFormat = sprintf('%%%d.8g', coefWidth);
    headerCoefFormat = sprintf('%%%ds', coefWidth);

    % Total table width
    tableWidth = termWidth + numEqn * coefWidth;

    % Top separator
    fprintf('%s\n', repmat('-', 1, tableWidth));
    
    % Title 
    if mode == "normalized" 
        fprintf("Normalized ")
    end
    fprintf('Coefficients for >')
    fprintf(obj.Name)
    fprintf('<\n')

    % Header
    fprintf(termFormat, 'Terms');
    for eqnIdx = 1:numEqn
        fprintf(headerCoefFormat, obj.TargetNames(eqnIdx));
    end
    fprintf('\n');

    % Header separator
    fprintf('%s\n', repmat('-', 1, tableWidth));

    % Coefficients
    for libraryIdx = 1:numTerms
        label = obj.Basis.LibraryFunctions(libraryIdx).Expression;
        fprintf(termFormat, label);
        for eqnIdx = 1:numEqn
            switch mode
                case "physical"
                    coef = obj.Coefficients{eqnIdx}(libraryIdx);

                case "normalized"
                    coef = obj.CoefficientsNormalized{eqnIdx}(libraryIdx);
            end
            fprintf(coefFormat, coef);
        end
        fprintf('\n');
    end

    % Bottom separator
    fprintf('%s\n', repmat('-', 1, tableWidth));

end % of COEFS (Method of SAGE) 

