#!/usr/bin/env bash
# lib/dates.sh
# Módulo de fechas — calcula el próximo primer sábado del mes
# Sin dependencias externas, solo Bash + date

# Nombres de meses en español
MESES=("" "enero" "febrero" "marzo" "abril" "mayo" "junio"
           "julio" "agosto" "septiembre" "octubre" "noviembre" "diciembre")

# Devuelve el primer sábado del mes dado (YYYY MM)
# Uso: _primer_sabado 2025 7
_primer_sabado() {
    local year="$1"
    local month="$2"
    local dia=1

    while (( dia <= 7 )); do
        # date -d funciona en Linux; en macOS usar: date -j -f "%Y-%m-%d"
        local dow
        if date --version &>/dev/null 2>&1; then
            # GNU date (Linux)
            dow=$(date -d "${year}-$(printf '%02d' "$month")-$(printf '%02d' "$dia")" +%w 2>/dev/null)
        else
            # BSD date (macOS)
            dow=$(date -j -f "%Y-%m-%d" "${year}-$(printf '%02d' "$month")-$(printf '%02d' "$dia")" +%w 2>/dev/null)
        fi
        # %w: 0=domingo, 6=sábado
        if [[ "$dow" == "6" ]]; then
            echo "$dia"
            return
        fi
        (( dia++ ))
    done
}

# Calcula el próximo primer sábado desde hoy
# Exporta: FECHA_DIA, FECHA_MES, FECHA_ANIO, FECHA_DISPLAY
get_next_first_saturday() {
    local today_y today_m today_d
    today_y=$(date +%Y)
    today_m=$(date +%-m)   # mes sin cero inicial
    today_d=$(date +%-d)   # día sin cero inicial

    local year=$today_y
    local month=$today_m
    local intentos=0

    while (( intentos < 13 )); do
        local primer_sab
        primer_sab=$(_primer_sabado "$year" "$month")

        # ¿Es hoy o en el futuro?
        if (( year > today_y )) || \
           (( year == today_y && month > today_m )) || \
           (( year == today_y && month == today_m && primer_sab >= today_d )); then
            FECHA_DIA=$primer_sab
            FECHA_MES=$month
            FECHA_ANIO=$year
            FECHA_DISPLAY="Sábado $(printf '%02d' "$primer_sab") de ${MESES[$month]} de $year"
            return 0
        fi

        # Avanzar al mes siguiente
        (( month++ ))
        if (( month > 12 )); then
            month=1
            (( year++ ))
        fi
        (( intentos++ ))
    done

    echo "ERROR: no se pudo calcular la fecha" >&2
    return 1
}
