# --------------------------------------------------------------------------- #
# Constructive greedy algorithm building a feasible solution (version 2023)
# code de 2018 ayant recu une premiere optimisation

# @time sur imac (nov 2023) : 0.091042 seconds (51.30 k allocations: 4.596 MiB, 99.10% compilation time)

function graspSPPconstruction2023(C, A, alpha)

    verbose = false

    nLin,nCol = size(A)
    if verbose
        println("nLin   : ", nLin)
        println("nCol   : ", nCol)
        println("C      : ", C)
        println("A      : ", A)
        println("-------- ")
    end

    # Pretraitements ----------------------------------------------------------

    # Somme colonne par colonne afin d'obtenir le nombre de 1 par colonne
    sumCol = vec(sum(A, dims=1))

    # Extrait ligne par ligne l'indice de la colonne ou l'element de A vaut 1
    unLin =  Vector{Vector{Int64}}(undef,nLin)
    for i in eachindex(unLin)
        unLin[i] = findall(isequal(1), A[i,:])
        #unLin[i] = findall(isequal(1), view(A, i,:) )
    end

    # Extrait colonne par colonne l'indice de la ligne ou l'element de A vaut 1
    unCol =  Vector{Vector{Int64}}(undef,nCol)
    for j in eachindex(unCol)
        unCol[j] = findall(isequal(1), A[:,j])
        #unCol[j] = findall(isequal(1), view(A, :,j) )
    end

    # Indice des variables
    indVar = collect(1:nCol)

    # Initialisation de la solution -------------------------------------------

    # valeur de la solution
    z::Int64 = 0
    # variables de la solution  toutes initalisees a zero
    x = fill(-1, nCol)
    #x = zeros(Int8, nCol)
    # calcul des utilites
    utilite = C ./ sumCol
    # RHS
    RHS = zeros(Int64, nLin)
    # Nombre de variables libres
    nVarLibres = nCol
    # Nombre de contraintes non saturees
    nCteNonSaturees =nLin

    # Elimine de l'instance toutes les variables concernees par aucune contrainte
    variablesConcernees = findall(isequal([]), unLin)

    for j in variablesConcernees
        # maj solution
        x[j] = 1      # fixe a 1 la variable non contrainte
        z = z + C[j]  # ajoute le coef de la fct economique pour la variable non contrainte

        # supprime les colonnes correspondant aux variables fixees
        indVar[j]  = 0 # marque par zero une variable non selectionnable (i.e. fixee a 0 ou 1)
        utilite[j] = 0 # idem pour l'utilite
        nVarLibres -= 1 # comptabilise qu'une variable a ete fixee
    end

    # Selection iterative d'elements ajoutes dans la solution -----------------
    while (nCteNonSaturees != 0) && (nVarLibres != 0)

        # selectionne l'indice selon RCL
        #j_selec = argmax(utilite)
        # !!!!!!!!!!!!! BEGIN !!!!!!!!!!!!!
        j_selec = selectionRCL( utilite , α )
        # !!!!!!!!!!!!!  END  !!!!!!!!!!!!!    

        # maj solution
        x[j_selec] = 1       # fixe a 1 la variable selectionnee
        z = z + C[j_selec]   # ajoute le coef de la fct economique pour la variable selectionnee
        nVarLibres -= 1      # comptabilise qu'une variable a ete fixee

        # retire la variable de l'ensemble restant
        indVar[j_selec]  = 0  # marque par zero une variable fixee
        utilite[j_selec] = 0  # idem pour l'utilite

        if verbose
            println("ivar   : ", indVar)
            println("U      : ", utilite)
            println("jselec : ",j_selec)
            println("-------- ")
        end

        # 1) maintient a jour l'etat de saturation des contraintes
        # 2) fixe a zero les variables dependantes
        # => maj indices des variables selectionnables
        # => maj utilites
        for i in unCol[j_selec]

            # met a jour le RHS : une contrainte de plus est saturee
            RHS[i] = 1
            # met a jour le compteur de contraintes non saturees
            nCteNonSaturees -= 1

            # selectionne tous les indices des variables a fixer a 0
            for j in setdiff(unLin[i],j_selec)
                if x[j] == -1
                    nVarLibres -= 1 # comptabilise qu'une variable a ete fixee
                    x[j]       = 0 # fixe a 0 la variable
                    indVar[j]  = 0 # marque par zero une variable fixee
                    utilite[j] = 0 # idem pour l'utilite
                #else
                    # si x[j]=0 => deja eliminee suite au parcours d'une autre contrainte
                end
            end
        end

    end # fin while

    if verbose
        println("ivar   : ", indVar)
        println("U      : ", utilite)
        println("x      : ", x)
        println("z      : ", z)
        println("#varlibres      : ", nVarLibres)
        println("nCteNonSaturees : ", nCteNonSaturees)
        println("-------- ")
    end

    return x, z

end
