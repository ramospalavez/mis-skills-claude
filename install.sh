#!/bin/sh
# Instala los skills de este repo en Claude Code.
#
#   ./install.sh                      todos los skills en ~/.claude/skills
#   ./install.sh impeccable animate   solo esos (por nombre de carpeta)
#   DEST=./.claude/skills ./install.sh   en un proyecto en vez de global
#   ./install.sh --list               lista los skills disponibles
#
# Un skill es cualquier carpeta que tenga un SKILL.md (busca hasta 2 niveles,
# así entran también los de emil-kowalski/<skill>). No copia los .skill
# empaquetados. Si el skill ya existe en el destino, lo reemplaza.
set -eu

REPO=$(cd "$(dirname "$0")" && pwd)
DEST=${DEST:-"$HOME/.claude/skills"}

listar() {
  find "$REPO" -mindepth 2 -maxdepth 3 -name SKILL.md -not -path '*/.git/*' \
    -exec dirname {} \; | sort
}

if [ "${1:-}" = "--list" ]; then
  listar | while read -r d; do basename "$d"; done
  exit 0
fi

mkdir -p "$DEST"
pedidos="$*"
instalados=0
encontrados=""

# separar solo por salto de línea: rutas con espacios (ej. "CRM Software/")
IFS='
'
for dir in $(listar); do
  nombre=$(basename "$dir")
  if [ -n "$pedidos" ]; then
    case " $pedidos " in *" $nombre "*) ;; *) continue ;; esac
  fi
  rm -rf "${DEST:?}/$nombre"
  mkdir -p "$DEST/$nombre"
  # copia todo menos los paquetes .skill
  (cd "$dir" && tar cf - --exclude='*.skill' .) | (cd "$DEST/$nombre" && tar xf -)
  echo "ok  $nombre"
  instalados=$((instalados + 1))
  encontrados="$encontrados $nombre"
done

unset IFS
for p in $pedidos; do
  case " $encontrados " in *" $p "*) ;; *) echo "no existe: $p" >&2; exit 1 ;; esac
done

echo "$instalados skills en $DEST. Reiniciá Claude Code para que los cargue."
