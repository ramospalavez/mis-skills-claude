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

## Cómo instalar un skill desde aquí

1. Descarga la carpeta del skill que quieras, o el archivo `.skill` ya
   empaquetado que está dentro de cada carpeta.
2. En Cowork/Claude Code, comparte el archivo `.skill` con Claude (o pídele
   que lo lea) y usa el botón de instalar/guardar skill.
