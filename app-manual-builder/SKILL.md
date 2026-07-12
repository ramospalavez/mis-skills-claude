---
name: app-manual-builder
description: Genera manuales visuales y sencillos de una app, listos para compartir con usuarios finales o clientes, en dos archivos separados (versión Usuario y versión Administrador), con estilo tipo codewiki (sidebar + navegación), capturas de pantalla reales tomadas navegando la app en vivo, y exportados a HTML y PDF. Usa este skill siempre que el usuario pida un "manual de usuario", "guía visual", "documentación para clientes", "onboarding", "walkthrough", un tutorial paso a paso de una app, o mencione capturas de pantalla + manual + versión admin/usuario — incluso si no usa la palabra "skill" o "manual" literalmente, por ejemplo "algo que le pueda mandar a mis clientes explicando cómo usar la app" o "necesito documentación tipo wiki para el equipo y otra para los usuarios". No uses este skill para documentación técnica interna (READMEs de código, docs de API) — está pensado específicamente para gente sin conocimientos técnicos.
---

# App Manual Builder

Genera un manual visual de una app, en lenguaje simple y sin jerga técnica, listo para
compartir con clientes o usuarios finales. Siempre produce **dos archivos separados**:
uno para usuarios normales y otro para administradores (que además incluye de dónde
vienen los datos de la app). Cada versión se entrega en HTML (estilo codewiki, con
sidebar de navegación) y en PDF.

La razón de separar usuario/admin en archivos distintos (no pestañas ni toggle) es que
normalmente se comparten con audiencias distintas — no quieres que un cliente final
reciba por accidente el enlace a la hoja de cálculo o API interna.

## Flujo de trabajo

### 1. Reunir la información antes de escribir nada

No inventes funcionalidades. Antes de redactar, confirma con quien te lo pidió (o
deduce de la conversación si ya se habló del proyecto):

- Nombre de la app y a quién sirve (2-3 líneas simples para la intro).
- Cómo se accede: URL de login, si hay invitaciones/roles para nuevos miembros.
- Qué se puede ajustar en la cuenta (perfil, notificaciones, preferencias).
- Lista de funcionalidades principales — para la versión usuario, y por separado,
  qué puede hacer un administrador que un usuario normal no puede.
- Si falta algo importante, pregunta en vez de rellenar con suposiciones genéricas.

Si tienes acceso a los archivos del proyecto (carpeta conectada), también puedes leer
el README o la documentación existente para entender las funciones — pero **nunca
copies fragmentos técnicos** (nombres de tablas, stack, arquitectura) al manual.

### 2. Detectar las fuentes de datos para la versión admin

Solo para la sección "🔌 De dónde vienen los datos" del manual admin: busca en el
proyecto (código, `.env.example`, configs, README) referencias a de dónde se
alimenta la app — un Google Sheet, una API externa, un webhook, etc.

- Sí incluir: nombre de la fuente, para qué se usa, y un enlace si es público o
  accesible (ej. link a la hoja de cálculo, URL base de una API documentada).
- Nunca incluir: contraseñas, tokens, API keys, connection strings, ni nada que
  esté en un `.env` real (solo `.env.example` con nombres de variables, y aun así
  no expongas el valor). Si dudas si algo es sensible, no lo pongas.
- Si no hay carpeta de proyecto conectada o no encuentras nada, pregunta a quien
  te lo pidió cuáles son las fuentes de datos, en vez de dejarlo vacío.

### 3. Tomar las capturas de pantalla reales

Este skill inserta capturas reales, no placeholders — para eso necesitas navegar la
app tú mismo:

- Si es una web app: usa las herramientas de Claude in Chrome (`navigate`,
  `computer`/`read_page`) para abrir cada pantalla relevante y tomar la captura.
- Si es una app de escritorio: usa las herramientas de computer-use, pidiendo acceso
  a la aplicación correspondiente primero.
- Toma una captura por paso significativo (no captures cada micro-clic — un usuario
  no técnico necesita ver "dónde estoy" antes de cada acción importante, no un GIF
  cuadro por cuadro).
- Recorta o encuadra la captura al área relevante cuando la pantalla completa tenga
  ruido (barras de navegador, otras apps abiertas, datos de otros clientes).
- Convierte cada imagen a base64 e insértala directamente en el `<img src="data:image/png;base64,...">`
  del HTML — así el archivo queda autocontenido y se puede compartir como un solo
  archivo sin enlaces rotos.
- **Si de verdad no puedes acceder a la app en vivo** (por ejemplo, no tienes
  credenciales o acceso al entorno), dilo explícitamente y usa un bloque
  `screenshot-placeholder` con el texto "[Insertar captura aquí]" en su lugar — no
  se supone que sea el caso normal, es un plan B.

### 4. Escribir el contenido

- Lenguaje simple, como si se lo explicaras a alguien sin conocimientos técnicos.
  Nada de "backend", "base de datos", "endpoint", "variable de entorno", "deploy",
  "hosting", ni nombres de frameworks o lenguajes.
- Frases cortas, verbos de acción ("Haz clic en...", "Escribe tu correo..."),
  usa `<span class="ui-label">` para nombres exactos de botones/menús tal como
  aparecen en la interfaz.
- Estructura fija (ver `assets/template.html` para el HTML exacto de cada bloque):

  1. **✨ Encabezado** — nombre de la app + qué es, en 2-3 líneas.
  2. **🔑 Cómo iniciar sesión y habilitar nuevos miembros** — paso a paso desde cero.
  3. **⚙️ Cómo configurar tu cuenta** — perfil, preferencias, notificaciones.
  4. **🧭 Qué puedes hacer en la app** — una `.feature-card` por funcionalidad
     principal, cada una como mini tutorial. En la versión usuario, solo funciones
     de usuario. En la versión admin, incluye además las funciones exclusivas de
     administrador.
  5. **🔌 De dónde vienen los datos** — *solo en la versión admin* (ver paso 2).
  6. **❓ Preguntas frecuentes** — deduce 3-5 dudas típicas de alguien nuevo y
     respóndelas de forma simple.

- Escribe en el mismo idioma en el que te lo pidieron (por defecto, español).

### 5. Construir los dos archivos HTML

Copia `assets/template.html` dos veces (`manual-usuario.html` y `manual-admin.html`)
y llena cada uno con el contenido correspondiente, siguiendo estas reglas del template:

- Reemplaza `{{APP_NAME}}`, `{{VERSION_LABEL}}` (`"Versión Usuario"` / `"Versión
  Administrador"`), `{{APP_DESCRIPTION_2_3_LINEAS}}`, `{{OTHER_VERSION_FILE}}` y
  `{{OTHER_VERSION_LABEL}}` para que cada archivo enlace al otro (el sidebar ya
  trae un enlace cruzado "Ver versión X →").
- Repite el bloque `.step` por cada paso dentro de una sección, y `.feature-card`
  por cada funcionalidad.
- En `manual-admin.html`, deja la sección `#fuentes` (ya viene en el template,
  comentada como "SOLO EN VERSIÓN ADMIN") y quítala por completo del archivo de
  usuario — no la dejes vacía ni oculta con CSS, elimínala del HTML.
- No cambies la hoja de estilos del template salvo que el usuario pida otra
  paleta — está pensada para imprimirse bien en PDF (el sidebar se oculta
  automáticamente en `@media print` y los pasos no se cortan entre páginas).

### 6. Exportar a PDF

Corre el script incluido para cada archivo:

```bash
pip install weasyprint --break-system-packages   # solo la primera vez
python3 scripts/html_to_pdf.py manual-usuario.html manual-usuario.pdf
python3 scripts/html_to_pdf.py manual-admin.html manual-admin.pdf
```

Si weasyprint falla por una imagen o fuente específica, revisa que las imágenes
estén en base64 (no rutas remotas) — es la causa más común.

### 7. Entregar

Guarda los 4 archivos (`manual-usuario.html`, `manual-usuario.pdf`,
`manual-admin.html`, `manual-admin.pdf`) en la carpeta de salida y compártelos con
la herramienta de presentar archivos. Antes de entregar, revisa tú mismo ambos HTML
en busca de: alguna palabra técnica que se haya colado, una captura placeholder que
debería ser real, o una sección admin que se haya filtrado al archivo de usuario.
