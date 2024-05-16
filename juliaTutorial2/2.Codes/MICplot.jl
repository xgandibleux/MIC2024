# --------------------------------------------------------------------------- #
# Trace l'activite (zinit, zls, zbest) d'un run GRASP sur une instance

function plotRunGrasp(iname, zinit, zls, zbest)

    figure("Trace of a run",figsize=(6,6)) # Create a new figure
    title("GRASP-SPP | \$z_{Init}\$ \$z_{LS}\$ \$z_{Best}\$ | " * iname)

    xlabel("Iterations")
    ylabel("values of z(x)")
    ylim(max(0,minimum(zinit)-100), maximum(zbest)+10)

    nPoint = length(zinit)
    x=collect(1:nPoint)
    xticks([1,convert(Int64,ceil(nPoint/4)),convert(Int64,ceil(nPoint/2)), convert(Int64,ceil(nPoint/4*3)),nPoint])
    plot(x,zbest[1:nPoint], linewidth=2.0, color="green", label="best solutions")
    plot(x,zls[1:nPoint],ls="",marker="^",ms=2,color="green",label="all improved solutions")
    plot(x,zinit[1:nPoint],ls="",marker=".",ms=2,color="red",label="all constructed solutions")
    vlines(x, zinit, zls, linewidth=0.5)
    legend(loc=4, fontsize ="small")
    #valeur = L"\hat{z}=" * string(zbest[end])
    valeur = "zbest=" * string(zbest[end])
    annotate(valeur, xy=[0.615;0.25], xycoords="figure fraction", ha="left", va="center")

    return nothing
end
