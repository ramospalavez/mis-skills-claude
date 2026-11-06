#!/bin/sh
# Test de install.sh: corre contra un destino temporal, nunca contra ~/.claude.
#   sh tests/install.test.sh
set -eu

REPO=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
fallas=0

check() { # descripcion, comando
  if sh -c "$2" >/dev/null 2>&1; then echo "PASS $1"; else echo "FAIL $1"; fallas=$((fallas + 1)); fi
}

total=$(find "$REPO" -mindepth 2 -maxdepth 3 -name SKILL.md -not -path '*/.git/*' | wc -l)

# 1. instalación completa
DEST="$TMP/all" sh "$REPO/install.sh" >/dev/null
check "instala todos los skills ($total)" "[ \$(ls '$TMP/all' | wc -l) -eq $total ]"
check "cada skill instalado tiene SKILL.md" "for d in '$TMP/all'/*; do [ -f \"\$d/SKILL.md\" ] || exit 1; done"
check "no copia paquetes .skill" "[ -z \"\$(find '$TMP/all' -name '*.skill')\" ]"
check "skills anidados (emil-kowalski) quedan planos" "[ -f '$TMP/all/emil-design-eng/SKILL.md' ] && [ ! -e '$TMP/all/emil-kowalski' ]"
check "conserva subcarpetas (impeccable/scripts)" "[ -x '$TMP/all/impeccable/scripts/impeccable' ]"
check "conserva subcarpetas (taste scripts)" "[ -f '$TMP/all/design-taste-frontend/scripts/shoot.mjs' ]"

# 2. selección por nombre
DEST="$TMP/sel" sh "$REPO/install.sh" impeccable animate >/dev/null
check "instala solo los pedidos" "[ \$(ls '$TMP/sel' | wc -l) -eq 2 ] && [ -d '$TMP/sel/impeccable' ] && [ -d '$TMP/sel/animate' ]"

# 3. nombre inexistente falla con código != 0
check "nombre inexistente da error" "! DEST='$TMP/x' sh '$REPO/install.sh' no-existe"

# 4. reinstalar reemplaza (no deja archivos viejos)
touch "$TMP/sel/impeccable/basura.txt"
DEST="$TMP/sel" sh "$REPO/install.sh" impeccable >/dev/null
check "reinstalar reemplaza el skill" "[ ! -e '$TMP/sel/impeccable/basura.txt' ]"

# 5. --list
check "--list muestra todos" "[ \$(sh '$REPO/install.sh' --list | wc -l) -eq $total ]"

# 6. repo clonado en una ruta con espacios
mkdir -p "$TMP/con espacios"
cp -r "$REPO/install.sh" "$REPO/impeccable" "$TMP/con espacios/"
DEST="$TMP/esp" sh "$TMP/con espacios/install.sh" >/dev/null
check "funciona con espacios en la ruta del repo" "[ -f '$TMP/esp/impeccable/SKILL.md' ]"

# 7. el name: del frontmatter coincide con la carpeta (Claude Code usa ambos)
for f in $(find "$REPO" -mindepth 2 -maxdepth 3 -name SKILL.md -not -path '*/.git/*'); do
  carpeta=$(basename "$(dirname "$f")")
  nombre=$(sed -n 's/^name:[[:space:]]*//p' "$f" | head -1 | tr -d '"'"'")
  check "name '$nombre' = carpeta '$carpeta'" "[ '$nombre' = '$carpeta' ]"
done

[ "$fallas" -eq 0 ] && echo "todo OK" || { echo "$fallas fallas"; exit 1; }
