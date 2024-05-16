# --------------------------------------------------------------------------- #
using Printf

include("MICparse.jl")
include("MICconstructionGreedy.jl")
include("MICimprovement.jl")


# =============================================================================
# exercise1: greedy construction + improvement on Set Packing Problem

function exercise1(fname)

    C, A  = loadSPP(string("DataAll", "/", fname))

    xConstruction, zConstruction, tConstruction = greedyConstruction(C, A)
    xImprovement, zImprovement, tImprovement = localSearch(C, A, xConstruction, zConstruction)

    println("-----------------------------------------------------------------")
    println("Instance : ",fname)
    @printf("  z(xCon) = %d | t = %f sec\n", zConstruction, tConstruction)
    @printf("  z(xImp) = %d | t = %f sec \n\n", zImprovement, tImprovement)

    return nothing
end


# =============================================================================

#fname = "didactic.dat"
#fname = "pb_100rnd0100.dat"
fname = "pb_200rnd0900.dat"
#fname = "pb_2000rnd0100.dat"
#fname = "pb_500rnd0100.dat"
#fname = "pb_500rnd0300.dat"

exercise1(fname)