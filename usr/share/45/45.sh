#!/bin/bash

# Colores
Black="\e[0;30m"
Red="\e[0;31m"
Green="\e[0;32m"
Yellow="\e[0;33m"
Blue="\e[0;34m"
Purple="\e[0;35m"
Cyan="\e[0;36m"
White="\e[0;37m"

# Ruta temporal
DIR="/tmp/geos45_temp.txt"

# Pausa
function pause() {
    echo -e "${Cyan}"
    read -sn 1 -p "   Presiona cualquier tecla para continuar..."
    echo -e "${White}"
}

# Validar IPv4
function is_ipv4() {
    local ip="$1"
    [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && return 0 || return 1
}

# Validar IPv6
function is_ipv6() {
    local ip="$1"
    [[ "$ip" =~ ^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}(([0-9]{1,3}\.){3}[0-9]{1,3})|([0-9a-fA-F]{1,4}:){1,4}:([0-9]{1,3}\.){3}[0-9]{1,3}))$ ]] && return 0 || return 1
}

# Validar dominio
function is_domain() {
    local domain="$1"
    [[ "$domain" =~ ^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$ ]] && return 0 || return 1
}

# Función para obtener datos de geolocalización
function fetch() {
    local input="$1"
    if [[ -z "$input" ]]; then
        echo -e "${Red}[Error] No se proporcionó una entrada válida.${White}"
        exit 1
    fi

    curl -s -H "User-Agent: keycdn-tools:https://veekrum.github.io" \
        "https://tools.keycdn.com/geo.json?host=${input}" | \
        jq -r '.data.geo | to_entries[] | "\(.key): \(.value)"' > "$DIR" 2>/dev/null

    if [[ -s "$DIR" ]]; then
        echo -e "${Green}Información geolocalizada para ${input}:${White}"
        cat "$DIR"
        rm "$DIR"
    else
        echo -e "${Red}[Error] No se pudo obtener información para ${input}.${White}"
    fi
}

# Mostrar uso
function usage() {
    echo -e "${Yellow}Uso:${White} geos45 [OPCIONES]"
    echo -e "\t-h | --help\tMuestra esta ayuda"
    echo -e "\t-v | --version\tMuestra la versión de la herramienta"
    echo -e "\t-u | --usar\tMuestra ejemplos de uso"
}

# Mensajes de ejemplo
function msg() {
    echo -e "${Cyan}"
    echo -e "\tGeos45 [dominio]  (ej: www.example.com)"
    echo -e "\tGeos45 [IPv4]     (ej: 127.0.0.1)"
    echo -e "\tGeos45 [IPv6]     (ej: 2001:0db8:85a3:0000:0000:8a2e:0370:7334)"
    echo -e "${White}"
}

# Validar entrada
function check_input() {
    local input="$1"
    if is_ipv4 "$input" || is_ipv6 "$input" || is_domain "$input"; then
        fetch "$input"
    else
        echo -e "${Red}[Error] Entrada inválida. Proporcione una dirección IPv4, IPv6 o un dominio válido.${White}"
        usage
        exit 1
    fi
}

# Banner e introducción
clear
pause
echo ""
echo -e "${White}    Geos45 es una herramienta para geolocalizar IPs y dominios."
echo -e "${White}    Soporta IPv4, IPv6 y dominios."
echo -e "${Purple}"

echo '''
                       ________________________________________________________
                       ========================================================
                           
                            #      ## ###          ######## ## #######  
                           ##     ###  ## ######## ######## ## #######  
                          ####### ###   # ######## ##     # ## ##       
                         ######## ###              ##    ## ###   ###   
                         ######## ### ###          ##   ### ### #  ###  
                          ####### ### ###          ##       ## ### ###  
                           ##      ## ##           ##       ##  # ###   
                            #                      ##                  
                                                              <===Geos45 (R)
                       ________________________________________________________
                       ========================================================
                          Geolocalizando IPv4, IPv6 y dominios by ====== Bunkerland =====   
'''
echo -e "${White}"
pause

# Procesar argumentos
if [[ $# -eq 0 ]]; then
    echo -e "${Red}[Error] Debes proporcionar una opción o un host.${White}"
    usage
    exit 1
fi

while true; do
    case "$1" in
        -h|--help) usage; exit ;;
        -v|--version) echo "Geos45 versión 1.1"; exit ;;
        -u|--usar) msg; exit ;;
        *) check_input "$1"; exit ;;
    esac
done
