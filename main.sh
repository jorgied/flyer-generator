#!/usr/bin/env bash
# main.sh — Generador de flyers para estados de WhatsApp
# Uso: ./main.sh [--fondo imagen.jpg] [--locaciones archivo.txt] [--output dir/]
#
# Requiere: bash, imagemagick
# Sin dependencias de Python ni otros lenguajes

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Cargar módulos
source lib/dates.sh
source lib/parser.sh
source lib/image.sh

# ── Parsear argumentos opcionales ────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --fondo)       FONDO="$2";            shift 2 ;;
        --locaciones)  LOCACIONES_FILE="$2";  shift 2 ;;
        --output)      OUTPUT_DIR="$2";       shift 2 ;;
        --help|-h)
            echo "Uso: $0 [--fondo img.jpg] [--locaciones archivo.txt] [--output dir/]"
            exit 0 ;;
        *)
            echo "Opción desconocida: $1  (usá --help)" >&2
            exit 1 ;;
    esac
done

# ── Verificar dependencias ────────────────────────────────────────────
check_imagemagick

# ── Encabezado ────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════╗"
echo "║   🪧  Generador de Flyers WhatsApp   ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Fechas ───────────────────────────────────────────────────────────
echo "📅 Calculando próximo primer sábado del mes..."
get_next_first_saturday
echo "   → $FECHA_DISPLAY"
echo ""

# ── Locaciones ───────────────────────────────────────────────────────
echo "📍 Cargando locaciones desde '$LOCACIONES_FILE'..."
load_locaciones
echo ""
list_locaciones
echo ""

# ── Generar imágenes ─────────────────────────────────────────────────
generate_all_flyers "$FECHA_DISPLAY"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  ¡Listo! Flyers guardados en output/ ║"
echo "╚══════════════════════════════════════╝"
echo ""

