# --------------------------------------------------------------------------- #
# Local search greedy algorithm improving a feasible solution

function localSearch(C, A, x_in, z_in)

    print("  Improvement... ")
    start = time()

    # -------------------------------------------------------------------------
    # initialisation

    xCurr = copy(x_in)                     # current solution 
    zCurr = z_in
    xBest = copy(x_in)                     # best solution
    zBest = z_in

    var0 = findall(isequal(0), xCurr[:])   # collect indexes of variables equal to 0
    var1 = findall(isequal(1), xCurr[:])   # collect indexes of variables equal to 1

    # current RHS vector for the variables set to 1 => identify all the constraints saturated (1) and non-saturated (0)
    rhsCurr = zeros(Int, size(A,1)) 
    for j in var1
        rhsCurr = rhsCurr + A[:,j] 
    end

    # local search (deepest ascent ) ------------------------------------------

    # neighborhood visited with the move 2-1 exchange -------------------------
    succes = true
    while succes == true

        j01Best  = 0
        j10aBest = 0
        j10bBest = 0

        succes = false

        # visit the entire neighborhood from the current solution -------------
        for j10a in var1
            for j10b in var1[var1 .> j10a]
                for j01 in var0

                    # consider a neighboor: 
                    #  1) test if the value of the neighboor is better than the zbest known 
                    #  2) test if the neighboor is feasible after the considered move  
                    if  (   (zCurr - C[j10a] - C[j10b] + C[j01] > zBest) 
                         && (findfirst( x -> x>1 , rhsCurr - A[:,j10a] - A[:,j10b] + A[:,j01] ) == nothing)
                        )
                        # a neighboor improving the best solution known is found in the neighborhood
                        # => record the move and the value of the new best solution found
                        j01Best  = j01
                        j10aBest = j10a
                        j10bBest = j10b
                        zBest    = zCurr - C[j10aBest] - C[j10bBest] + C[j01Best]
                        succes   = true
                    end

                end
            end
        end

        if succes
            # apply the improving move identified, giving a new current solution
            var0 = setdiff(var0,j01Best)                                     
            push!(var0,j10aBest); push!(var0,j10bBest)

            var1 = setdiff(var1,j10aBest);  var1 = setdiff(var1,j10bBest)
            push!(var1,j01Best)

            xBest[j01Best] = 1;  xBest[j10aBest] = 0;  xBest[j10bBest] = 0
            zCurr = zBest
            rhsCurr = rhsCurr - A[:,j10aBest] - A[:,j10bBest] + A[:,j01Best]

            #@printf("    exchange %3d %3d %3d ",j10aBest, j10bBest, j01Best)
            #println("| z(x) = ", zBest)
            print("x")
        end
    end

    tImprovement = time()-start
    println("\n   ↳ done!")
    return xBest, zBest, tImprovement
end

