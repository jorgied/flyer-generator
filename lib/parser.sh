#!/usr/bin/env bash
# lib/parser.sh
# Módulo de lectura de locaciones
# Lee locaciones.txt y carga el array global LOCACIONES[]

LOCACIONES_FILE="${LOCACIONES_FILE:-locaciones.txt}"

load_locaciones() {
    LOCACIONES=()

    if [[ ! -f "$LOCACIONES_FILE" ]]; then
        echo "ERROR: No se encontró '$LOCACIONES_FILE'" >&2
        return 1
    fi

    while IFS= read -r linea || [[ -n "$linea" ]]; do
        # Ignorar líneas vacías y comentarios
        [[ -z "${linea// }" || "$linea" == \#* ]] && continue
        LOCACIONES+=("$linea")
    done < "$LOCACIONES_FILE"

    if (( ${#LOCACIONES[@]} == 0 )); then
        echo "ERROR: '$LOCACIONES_FILE' no tiene locaciones válidas." >&2
        return 1
    fi

    echo "→ ${#LOCACIONES[@]} locaciones cargadas."
}

list_locaciones() {
    local i=1
    for loc in "${LOCACIONES[@]}"; do
        printf "  [%d] %s\n" "$i" "$loc"
        (( i++ ))
    done
}
