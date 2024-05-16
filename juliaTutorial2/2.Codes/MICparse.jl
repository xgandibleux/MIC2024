# --------------------------------------------------------------------------- #
# collect the un-hidden filenames available in a given directory

function getfname(target)
    # target : string := chemin + nom du repertoire ou se trouve les instances

    # retourne le repertoire courant
    println("pwd = ", pwd())

    savepwd = pwd()

    # positionne le currentdirectory dans le repertoire cible
    cd(joinpath(pwd(),target))

    # recupere tous les fichiers se trouvant dans le repertoire data
    allfiles = readdir()

    # vecteur booleen qui marque les noms de fichiers valides
    flag = trues(size(allfiles))

    k=1
    for f in allfiles
        # traite chaque fichier du repertoire
        if f[1] != '.'
            # pas un fichier cache => conserver
            println("fname = ", f)
        else
            # fichier cache => supprimer
            flag[k] = false
        end
        k = k+1
    end

    cd(savepwd)

    # extrait les noms valides et retourne le vecteur correspondant
    finstances = allfiles[flag]
    return finstances
end

# --------------------------------------------------------------------------- #
# Loading an instance of SPP (format: OR-library)

function loadSPP(fname)
    # fname : name of the file to parse
    
    f=open(fname)
    # lecture du nbre de contraintes (m) et de variables (n)
    m, n = parse.(Int, split(readline(f)) )
    # lecture des n coefficients de la fonction economique et cree le vecteur d'entiers c
    C = parse.(Int, split(readline(f)) )
    # lecture des m contraintes et reconstruction de la matrice binaire A
    A=zeros(Int, m, n)
    for i=1:m
        # lecture du nombre d'elements non nuls sur la contrainte i (non utilise)
        readline(f)
        # lecture des indices des elements non nuls sur la contrainte i
        for valeur in split(readline(f))
          j = parse(Int, valeur)
          A[i,j]=1
        end
    end
    close(f)
    return C, A
end


# ---- Parser reading an instance "rail" from OR-library 
#      (http://people.brunel.ac.uk/~mastjjb/jeb/orlib/scpinfo.html)

function loadInstanceRAIL(fname::String)

    f = open(fname)
    nbctr, nbvar = parse.(Int, split(readline(f)))
    A = zeros(Int, nbctr, nbvar)       # matrix of constraints
    c = zeros(Int, nbvar)              # vector of costs
    nb = zeros(Int, nbvar)
    for i in 1:nbvar
        flag = 1
        for valeur in split(readline(f))
            if flag == 1
                c[i] = parse(Int, valeur)
                flag +=1
            elseif flag == 2
                nb[i] = parse(Int, valeur)
                flag +=1
            else
                j = parse(Int, valeur)
                A[j,i] = 1
            end
        end
    end
    close(f)
    return nbvar, nbctr, A, c
end