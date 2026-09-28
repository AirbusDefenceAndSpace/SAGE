function [basis, independentColumns] = basisextraction(library, method)
%BASISEXTRACTION Extracts a linear independent column basis. 

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
        library (:,:) double 
        method (1,1) string {mustBeMember(method, ["qrDecomposition"]) } = "qrDecomposition"
    end
    
    switch method
        case "none" 
            % passes through library matrix, regardless if singular or
            % regular (mostly intended for debug purposes) 
            basis = library; 
            independentColumns = 1:size(library,2); 
            warning("BasisExtractionAlgorihm set to 'none' - Basis could be ill-conditioned.")

        case "qrDecomposition"
            % identifies and removes linearly dependent columns in library-matrix 
            % using pivoting qr-decomposition 
            % R - upper triangular; P - permutation vector
            [~, R, P] = qr( library, "econ", "vector");
            
            % not using 'rank' to reduce computational burden as qr is already calculated
            relativeTol = max(size(library)) * eps(class(library)); 
            numericalRank = sum(abs(diag(R)) > relativeTol * abs(R(1,1)));
                
            independentColumns = sort(P(1:numericalRank));  % array of columns to build well-conditioned basis matrix 
            basis = library(:, independentColumns );    % extract basis 
    end


end % of BASIS EXTRACTION (Static-Method of SAGEBASIS)

