# Mis Skills de Claude

Repositorio para guardar mis skills personalizados de Claude, para poder
reinstalarlos en cualquier sesión de Cowork / Claude Code sin tener que
recrearlos desde cero.

## Skills disponibles

### `app-manual-builder/`
Genera manuales visuales y sencillos de una app (sin jerga técnica), listos
para compartir con usuarios o clientes. Produce dos archivos separados
(versión Usuario y versión Administrador), en HTML estilo codewiki y en PDF,
con capturas de pantalla reales tomadas navegando la app.

### `uruvet-error-tracking/`
Implementa captura de errores, alertas por email, trazabilidad de requests
(request ID) y métricas de uptime/latencia/error rate para el monorepo
UruVet (uruvet-api en NestJS+TypeORM+Postgres, uruvet-admin/uruvet-intra/
uruvet-web en Angular, uruvet-clientes PWA).

### `rutina-skincare-poster/`
Convierte una rutina de skincare (pasos, productos y modo de uso) en láminas
tipo póster de mañana y noche en el canvas de Design. Pregunta el estilo
(básico elegante o femenino cute), busca las fotos oficiales de los
productos en internet si las de la usuaria son chicas, y las recorta sin
fondo. Para buscar fotos necesita la app de escritorio de Claude abierta
(usa su navegador integrado).

## Skills de terceros (diseño)

Copias sin modificar de repos públicos, con su licencia y un `ORIGEN.md`
(repo, commit copiado y cómo actualizar).

### `emil-kowalski/` (17 skills, MIT)
De [emilkowalski/skills](https://github.com/emilkowalski/skills). Los detalles
chicos y las animaciones fluidas. El principal es `emil-design-eng`; los demás
son especializados: `animate`, `review-animations`, `improve-animations`,
`find-animation-opportunities`, `remove-animations`, `choreograph`,
`animation-performance`, `animation-vocabulary`, `apple-design`, `break-ui`,
`mobile-native`, `prototype`, `pick-ui-library`, `animate-expo`, `write-swift`,
`ask-sonner`.

### `impeccable/` (Apache 2.0)
De [pbakaus/impeccable](https://github.com/pbakaus/impeccable). Vocabulario de
diseño de verdad (`/impeccable polish`, `audit`, `critique`, `bolder`,
`quieter`...) y detector de tics típicos de la IA. Baja su motor (binario
verificado por checksum) la primera vez que corre.

### `design-taste-frontend/` (MIT)
De [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill). Construido
a partir de un estudio de 247 webs reales. Elige dirección de arte, usa fotos
con licencia abierta (Wikimedia Commons, Unsplash) y comprueba el resultado en
un navegador. Necesita Node 22+ y Chrome/Chromium. Pesa ~40 MB.

## Cómo instalar

**Todo de una (Claude Code):**

```sh
git clone https://github.com/ramospalavez/mis-skills-claude
cd mis-skills-claude
./install.sh                          # todos, en ~/.claude/skills
./install.sh impeccable emil-design-eng   # solo algunos
DEST=./.claude/skills ./install.sh    # en un proyecto puntual
./install.sh --list                   # ver los disponibles
```

Después reiniciá Claude Code. Test del instalador: `sh tests/install.test.sh`.

**Uno por uno (Cowork / claude.ai):**

1. Descarga el archivo `.skill` ya empaquetado que está dentro de cada carpeta.
2. En Cowork/Claude Code, comparte el archivo `.skill` con Claude (o pídele
   que lo lea) y usa el botón de instalar/guardar skill.
