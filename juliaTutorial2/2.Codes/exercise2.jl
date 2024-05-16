# =============================================================================
using Printf

include("MICparse.jl")
include("MICconstructionGrasp.jl")
include("MICimprovement.jl")


# =============================================================================
# exercise2: GRASP on Set Packing Problem

function exercise2(fname, nbIteration, α)

    C, A  = loadSPP(string("DataAll", "/", fname))

    start = time()
    zTheBest = 0
    for i=1:nbIteration
        xConstruction, zConstruction, tConstruction = greedyRandomizedConstruction(C, A, α)
        xImprovement, zImprovement, tImprovement = localSearch(C, A, xConstruction, zConstruction)
        zTheBest = max(zTheBest, zImprovement)
    end
    tGRASP = time()-start

    println("-----------------------------------------------------------------")
    println("Instance : ",fname)
    @printf("  z(xBest) = %d | t = %f sec \n\n", zTheBest, tGRASP)

    return nothing
end


# =============================================================================

#fname = "didactic.dat"
#fname = "pb_100rnd0100.dat"
fname = "pb_200rnd0900.dat"
#fname = "pb_2000rnd0100.dat"
#fname = "pb_500rnd0100.dat"
#fname = "pb_500rnd0300.dat"

nbIteration = 10
α           = 0.7

exercise2(fname, nbIteration, α)