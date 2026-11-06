# Origen: Impeccable (Paul Bakaus)

- Repo: https://github.com/pbakaus/impeccable (licencia Apache 2.0, ver `LICENSE`)
- Commit copiado: `c3bb418ee38ee49a6b999b7752c1368f3123a2bd` (2026-11-06)
- Copia sin modificar de `.claude/skills/impeccable` (la variante standalone para Claude Code).

Vocabulario de diseño (`/impeccable polish`, `audit`, `critique`, `distill`, `animate`,
`bolder`, `quieter`...) y un detector de tics de IA (bordes laterales, gradientes
violeta, easing con rebote, glows oscuros).

Ojo: `scripts/impeccable` baja un binario la primera vez que corre (desde los releases
de GitHub, verificado contra `scripts/engine-checksums.txt`). No necesita Node.
El hook de diseño automático no viene en esta copia: se agrega con `npx impeccable install`
si lo querés.

Actualizar: `npx impeccable update`, o clonar el repo y copiar `.claude/skills/impeccable`.
