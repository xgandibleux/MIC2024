# =============================================================================
# Constructive greedy algorithm building a feasible solution (naive implementation)
# Implementation style to highlight the different steps of the algorithm (could be optimized)

function greedyConstruction(C_in, A_in)

    println("  Construction (greedy)...")
    start = time()

    # -------------------------------------------------------------------------
    # initialisation

    # data
    m,n = size(A_in)
    C = copy(C_in)
    A = copy(A_in)

    # solution
    z = 0  
    x = zeros(Int64, n) 

    freeVariables = collect(1:n)    # all variables are free
    saturatedConstraints = Int64[]  # none constraint is saturated

    # -------------------------------------------------------------------------
    # remove from the instance all variables occuring in none constraint

    # identify all variables occuring in none constraint
    variablesNotConstrained = findall( isequal(0) , vec( sum(A, dims=1) ) )

    # fix to 1 into the solution all variables occuring in none constraint
    x[variablesNotConstrained] .= 1
    z += sum( C[variablesNotConstrained] )    

    # remove from the list of free variables those how have been fixed
    freeVariables = freeVariables[ setdiff( 1:end , variablesNotConstrained ) ]

    # remove columns corresponding to fixed variables
    C = C[ setdiff( 1:end , variablesNotConstrained ) ]
    A = A[ : , setdiff( 1:end , variablesNotConstrained ) ]

    # -------------------------------------------------------------------------
    # select iteratively variables to add into the solution

    while (size(A,1) != 0) && (size(C,1) != 0)

        # ---------------------------------------------------------------------
        # select one variable and add it into the current solution

        utility = C ./ vec( sum(A, dims=1) )
        variableSelected = argmax(utility)

        x[ freeVariables[ variableSelected ] ] = 1 
        z += C[variableSelected] 

        # ---------------------------------------------------------------------
        # identify all the variables impacted by the variable fixed 

        # identify all constraints concerned by the selected variable: constraints saturated => to remove
        saturatedConstraints = findall( isequal(1) , A[ : , variableSelected ] ) 

        # identify all variables linked to the variable selected
        linkedVariables = Int64[]
        for i in saturatedConstraints 
            linkedVariables = union( linkedVariables , findall( isequal(1) , A[i,:] ) ) 
        end
        linkedVariables = unique(linkedVariables) 

        # remove from the list of free variables those how are linked (and thus fixed)
        freeVariables = freeVariables[ setdiff( 1:end , linkedVariables ) ]

        # ---------------------------------------------------------------------
        # reduce the instance consequently to the fixed variables

        # remove columns corresponding to fixed variables
        C = C[ setdiff(1:end , linkedVariables) ]
        A = A[ : , setdiff( 1:end , linkedVariables ) ]

        # remove lines of A corresponding to saturated constraints
        A = A[ setdiff( 1:end , saturatedConstraints ) , : ]

        # ---------------------------------------------------------------------
        # remove lines of A containing only zero value => constraint not related to a variable

        removableConstraints = Int64[]
        for line in (1:size(A,1))
            if findfirst( isequal(1) , A[line,:] ) == nothing
                removableConstraints = union( removableConstraints , line )
            end
        end
        A = A[ setdiff( 1:end , removableConstraints ) , : ]

    end

    tConstruction = time()-start
    println("   ↳ done!")
    return x, z, tConstruction

end
