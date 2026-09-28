classdef sagebasis
    %SAGEBASIS Framework for basisfunctions used in sage-regression. 
    %  
    % Helper class to support core operation fo SAGE-Toolbox. 
    
    %@ToDO put aspects of constructor in separate functions so that they
    %can be called indivudally for nieche usecases

    % call everything, or at least the function vector library, prior to 
    % basis extraction to be consistent with naming


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
 
    % ----------------------------------------------- %
    % -- Library/Basis Function Definition Methods -- %
    % ----------------------------------------------- %

    % Definition of basis types. Types often result in multiple basis
    % functions (e.g. monomials is a type, but selecting monomials
    % typically ends up being multiple basis functions. 
    % The functions are static (independent of class) as their definition
    % only relies on provided data and some settings (params). This way
    % they can also be used without the additional overhead added by
    % sagebasis. 
    methods (Static) 
        [basisfunctionConstant] = type_constant(data, params) 
        [basisfunctionsMonomials] = type_monomials(data, params)
    end
    
    % This is a object specific "constant", that list all existing types
    % and their priority. The priority is used to define the order in which
    % the terms are listed to obtain consistant results. 
    properties (Hidden, SetAccess = immutable)
        TypePriorities = struct( ...
            "Constant", 1, ...      
            "Monomials", 2)
    end

    
    properties (SetAccess = immutable)
        LibraryMatrix (:,:) double % matrix of all basis function evaluated at each point in time 
        LibraryFunctions (:,1) basisfunction % list of all basis functions
                % can be multiple functions per type and specific order
                % according to priority list 
        IndependentColumns (:,1) double % list of indeces of the columns in LibraryMatrix to obtain 
                % a well-conditions basis matrix (no linear dependent
                % columns) 

    end
    

    properties (Hidden, Dependent)
        SizeLibrary (1,1) double % number of basis functions in library 
        SizeBasis   (1,1) double % number of basis functions in basis
        BasisMatrix (:,:) double % well-conditioned version of library matrix 
        BasisFunctions  (:,1) basisfunction % only the basis functions that belong to 'BasisMatrix'
    end
    

    methods % 
        function num = get.SizeLibrary(obj)
            num = length(obj.LibraryFunctions);
        end

        function num = get.SizeBasis(obj) 
            num = length(obj.BasisFunctions);
        end

        function mat = get.BasisMatrix(obj) 
            mat = obj.LibraryMatrix(:, obj.IndependentColumns );
        end

        function bf = get.BasisFunctions(obj) 
            bf = obj.LibraryFunctions( obj.IndependentColumns );
        end
    end


    properties (Hidden, SetAccess = immutable)
        PrefixTypeFiles = "type_"    % prefix for functions used to define basis-types
        FormattedTypeOptions struct = struct()  % struct with the parameters for each basis-type
        SortedEnabledTypes (1,:) string {mustBeText}
    end

    
    % ------------------------------ %
    % -- Object Utility Functions -- %
    % ------------------------------ %
    methods (Static) 
        [BasisMatrix, IndependentColumns] = basisextraction(mat, method)
        sampleData = sample(mat,idx)
    end

    methods 
        libraryRow = evalbf(obj, x,u,t);
        jacobiMat = evaljacobi(obj, x,u,t)
    end



    methods
        function obj = sagebasis( data, opt )
            %SAGEBASIS Constructor 
            %   Detailed explanation goes here
            arguments 
                data (1,1) sagedata 
                opt (1,1) sageoptions
            end

            % high level validation of basistype implementation
            typePrioList = fieldnames(obj.TypePriorities);  
            typeFuncList = obj.availableTypes;    
            isValid = isempty(setxor( lower(typePrioList), lower(typeFuncList) ));
            if ~isValid 
                error("Missmatch in 'basistype' implementation.")
                % Implementation of basistypes requires an entry in the
                % priority list and corresponding function with the correct
                % prefix (property 'PrefixType'). The spelling must be
                % identical, capitalization is irrelevant. 
                % 
            end

            % type-specific options in a specific format for more intuitive implementation in class  
            for idx = 1:numel(typePrioList) 
                typeName = typePrioList{idx};  
                obj.FormattedTypeOptions.(typeName) = opt.isenabled(typeName);
                obj.FormattedTypeOptions.( typeName + "Params" ) = opt.subprops(typeName, "values", "short", false);
            end

            %   list only containing enabled basis-types and their priorities
            enabledTypesPrios = struct(); 
            for idx = 1:numel(typePrioList) 
                typeName = typePrioList{idx};
                if obj.FormattedTypeOptions.(typeName)
                   enabledTypesPrios.(typeName) = obj.TypePriorities.(typeName); 
                end
            end

            %   define call-order for basis types (must create reproducable results) 
            enabledTypes = string(fieldnames(enabledTypesPrios));   % list of enabled types
            priority = cell2mat(struct2cell(enabledTypesPrios));    % list of their priorities
            
            % Sorte them based on their priority. 
            % Types with the same priority are sorted alphabetically. 
            [~, idx] = sortrows(table(priority, enabledTypes), ["priority", "enabledTypes"]);
            obj.SortedEnabledTypes = enabledTypes(idx);
        
            % loop through each enabled basis type in the order specified before 
            for idx = 1:numel(obj.SortedEnabledTypes) 
                typeName = obj.SortedEnabledTypes(idx);     % select basis_type
                typeFunc = obj.PrefixTypeFiles + lower(typeName);    % name of corresponding function 
                
                % call the basis-type, which must return a vector of basis-function objects
                typeLibraryFunctions = obj.(typeFunc)( data, obj.FormattedTypeOptions.(typeName+"Params") );   
                
                % stack the basis functions 
                obj.LibraryFunctions = [obj.LibraryFunctions; typeLibraryFunctions(:)];     
            end

            % local reference for data matrices 
            X = data.DataX;
            U = data.DataU; 
            T = data.DataT; 

            % construct library matrix (each basis function evaluated at
            % each state/input sequence included in the provided data) 
            nSample = data.NumSamples; 
            nLibraryTerms = length(obj.LibraryFunctions); 
            obj.LibraryMatrix = zeros(nSample, nLibraryTerms); %pre-allocation of library-matrix
            
            for sampleIdx = 1:nSample % loop through all state/input sequence (i.e. points in time) 
                x = sagebasis.sample(X, sampleIdx);
                u = sagebasis.sample(U, sampleIdx); 
                t = sagebasis.sample(T, sampleIdx);
                obj.LibraryMatrix(sampleIdx, :) = obj.evalbf(x,u,t);  
            end
            
            % determine independent basis function
            % adds obj.BasisMatrix and obj.IndependentColumns 
            extractionMethod = opt.("BasisExtractionAlgorithm");
            [~, obj.IndependentColumns] = sagebasis.basisextraction(obj.LibraryMatrix, extractionMethod);           
            

        end % of SAGEBASIS constructor 
    end
    


    
     
end

