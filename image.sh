#!/usr/bin/env bash
# lib/image.sh
# Módulo de generación de imágenes con ImageMagick
# Genera flyers 1080x1920 (formato story / estado WhatsApp)

OUTPUT_DIR="${OUTPUT_DIR:-output}"
FONDO="${FONDO:-}"          # ruta a imagen de fondo (opcional)
FONT="${FONT:-DejaVu-Sans-Bold}"

# Colores
COLOR_TITULO="#FFFFFF"
COLOR_FECHA="#FFD700"
COLOR_LOCACION="#F0F0F0"
COLOR_HASHTAG="#AADDFF"
COLOR_FONDO_DEFAULT="#1a1a2e"    # azul oscuro si no hay imagen

ANCHO=1080
ALTO=1920

# Verifica que ImageMagick esté disponible
check_imagemagick() {
    if ! command -v convert &>/dev/null; then
        echo "ERROR: ImageMagick no está instalado." >&2
        echo "  Ubuntu/Debian: sudo apt install imagemagick" >&2
        echo "  macOS:         brew install imagemagick" >&2
        return 1
    fi
}

# Genera un único flyer
# Uso: generate_flyer "Texto locación" "Sábado 05 de julio de 2025" 1
generate_flyer() {
    local locacion="$1"
    local fecha_display="$2"
    local index="$3"
    local outfile="${OUTPUT_DIR}/flyer_$(printf '%02d' "$index").png"

    # Base: imagen de fondo o color sólido
    local base_args=()
    if [[ -n "$FONDO" && -f "$FONDO" ]]; then
        base_args=(
            "$FONDO"
            -resize "${ANCHO}x${ALTO}^"
            -gravity Center
            -extent "${ANCHO}x${ALTO}"
        )
    else
        base_args=(
            -size "${ANCHO}x${ALTO}"
            "xc:${COLOR_FONDO_DEFAULT}"
        )
    fi

    convert \
        "${base_args[@]}" \
        \( -size "${ANCHO}x${ALTO}" xc:"rgba(0,0,0,0.55)" \) -composite \
        \
        -gravity North \
        -fill "$COLOR_TITULO" \
        -font "$FONT" \
        -pointsize 110 \
        -annotate +0+160 "MARCHA" \
        -pointsize 80 \
        -annotate +0+300 "POR LA PAZ" \
        \
        -gravity Center \
        -fill "$COLOR_FECHA" \
        -font "$FONT" \
        -pointsize 65 \
        -annotate +0-280 "$fecha_display" \
        \
        -fill "$COLOR_LOCACION" \
        -font "$FONT" \
        -pointsize 52 \
        -annotate +0-120 "$locacion" \
        \
        -gravity South \
        -fill "$COLOR_HASHTAG" \
        -font "$FONT" \
        -pointsize 45 \
        -annotate +0+140 "#MarchaXLaPaz" \
        \
        "$outfile"

    echo "  ✓ flyer_$(printf '%02d' "$index").png"
}

# Genera todos los flyers del array LOCACIONES[]
generate_all_flyers() {
    local fecha_display="$1"

    mkdir -p "$OUTPUT_DIR"

    if (( ${#LOCACIONES[@]} == 0 )); then
        echo "ERROR: No hay locaciones cargadas." >&2
        return 1
    fi

    echo "Generando ${#LOCACIONES[@]} flyer(s) en ./${OUTPUT_DIR}/ ..."
    echo ""

    for i in "${!LOCACIONES[@]}"; do
        generate_flyer "${LOCACIONES[$i]}" "$fecha_display" "$((i+1))"
    done
}
