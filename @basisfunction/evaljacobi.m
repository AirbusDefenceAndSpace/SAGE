function jacobiRow = evaljacobi(obj, x, u, t)
%EVALJACOBI (BASISFUNCTION class method) Evaluates jacobi at the given data points.    
% 
% jacobiRow = EVALJACOBI(obj, x, u, t) evaluates all jacobis of a
%       basisfunction for a given state-sequence (x), input-sequence (u)
%       and time-point (t). 

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

    nJacobi = length( obj.Jacobi.Handles );
    jacobiRow = zeros(1,nJacobi);   % pre-allocation  

    % populate jacobi at datapoints 
    for idx = 1:nJacobi 
        fh = obj.Jacobi.Handles{idx};
        jacobiRow(idx) = fh(x,u,t); 
    end 

end

