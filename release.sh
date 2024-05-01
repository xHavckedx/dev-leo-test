# Obtén el último tag
last_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

# Verifica si el tag es nuevo
if git rev-parse $last_tag >/dev/null 2>&1
then
    echo "Tag $last_tag encontrado"

    # Verifica si el tag sigue el versionado semántico
    if [[ $last_tag =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
        echo "El tag $last_tag sigue el versionado semántico"

        # Verifica si ya existe una rama release con el nombre del tag
        if ! git rev-parse --verify release/$last_tag >/dev/null 2>&1
        then
            # Si la rama no existe, crea una nueva rama release con el nombre del tag
            git checkout -b release/$last_tag
            git push origin release/$last_tag
        else
            echo "La rama release/$last_tag ya existe"
        fi
    else
        echo "El tag $last_tag no sigue el versionado semántico"
    fi
else
    echo "No se encontró el tag $last_tag"
fi
