# =============================================================================
using Printf
using PyPlot

include("MICparse.jl")
include("SPPconstruction.jl")
include("SPPamelioration.jl")
include("MICplot.jl")


# =============================================================================
# exercise2: GRASP on Set Packing Problem

function exercise2fast(fname, nbIteration, α)

    C, A  = loadSPP(string("DataAll", "/", fname))

    zConstruction = zeros(Int64, nbIteration) 
    zImprovement  = zeros(Int64, nbIteration) 
    zBest         = zeros(Int64, nbIteration) 

    start = time()
    zTheBest = 0
    for i=1:nbIteration
        xConstruction, zConstruction[i] = graspSPPconstruction2023(C, A, α)
        xImprovement, zImprovement[i] = GreedyAmelioration2023(C, A, xConstruction, zConstruction[i])
        zTheBest = max(zTheBest, zImprovement[i])
        zBest[i] = zTheBest

    end
    tGRASP = time()-start

    println("-----------------------------------------------------------------")
    println("Instance : ",fname)
    @printf("  z(xBest) = %d | t = %f sec \n\n", zTheBest, tGRASP)
    plotRunGrasp(fname, zConstruction, zImprovement, zBest)

    return nothing
end


# =============================================================================

#fname = "didactic.dat"
#fname = "pb_100rnd0100.dat"
fname = "pb_200rnd0900.dat"
#fname = "pb_2000rnd0100.dat"
#fname = "pb_500rnd0100.dat"
#fname = "pb_500rnd0300.dat"

nbIteration = 100
α           = 0.7

exercise2fast(fname, nbIteration, α)