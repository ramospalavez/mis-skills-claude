---
name: "rutina-skincare-poster"
description: "Convierte una rutina de skincare (pasos, productos y modo de uso) en láminas tipo póster Matin/Soir en el canvas de Design, con fotos de producto recortadas sin fondo."
---

# Rutina skincare → póster estilo Canva

Usar cuando la usuaria pega una rutina de cuidado de la piel (mañana y/o noche) y pide un diseño bonito, o manda fotos de productos para agregar a una rutina ya diseñada.

## Paso 0: elegir el estilo (preguntar siempre que no lo diga)

Antes de crear el canvas, si el mensaje no dice qué estilo quiere, preguntar con `AskUserQuestion` (una sola pregunta, encabezado "Estilo"):

- **Básico elegante** — Matin/Soir crema y azul noche, serif clásica, sobrio (ver "Estilo básico").
- **Femenino cute** — rosa y lila, letra script, corazones y destellos, sol y luna con carita (ver "Estilo femenino cute").

La usuaria puede escribir otro estilo en "Otro"; en ese caso mantener la estructura y cambiar paleta, tipografías y adornos según lo que pida.

No preguntar si ya lo dijo ("hacelo cute", "como la otra vez, la básica", "muy femenino") ni si se están agregando fotos a un canvas que ya existe: ahí se respeta el estilo que ya tiene. Si nadie puede contestar (corrida sin usuaria presente), usar el básico y decirlo en la respuesta.

Si la usuaria también mandó fotos chicas o collages, en la misma tanda de preguntas se puede sumar: "¿Busco las fotos oficiales en internet?" (ver Opción B), porque implica descargar archivos.

## Estructura común (los dos estilos)

Un canvas de Design con una lámina por momento del día (900 px de ancho, alto según contenido; ~1680 px para una rutina simple).

- Cada paso es una grilla `64px 1fr 140px`:
  1. Círculo de 56 px con el número, color acento. **El número va centrado**: fuente sans de cifras alineadas (DM Sans o Fredoka) 22 px, `line-height: 1`, `font-variant-numeric: lining-nums tabular-nums`, flex centrado. No usar Cormorant para los números (sus cifras antiguas quedan descentradas).
  2. Texto: etiqueta del paso en mayúsculas (14 px, espaciado 3 px), nombre del producto, formato del envase si lo hay (15-17 px), acción (18-19 px).
  3. Foto del producto (ver abajo).
- Un tweak `accent` (color con 4 opciones) por lámina; todo el texto literal en el markup para que se pueda editar en el lienzo.
- Sin emojis, íconos en SVG inline.
- Si la noche cambia según el día: la base común arriba ("Todas las noches") y luego un bloque por grupo de días (ej. Lun·Mié·Vie·Sáb / Mar·Jue / Domingo), cada uno con chip de días y subtítulo. Pasos alternativos ("A o B") van en una tarjeta con las dos fotos superpuestas; dos productos en un mismo paso (doble limpieza) van con dos fotos chicas apiladas.

### Estilo básico

- **Matin / Jour**: fondo crema `#FBF3EA`, texto `#3A2A20`, acento terracota `#B8653C`, texto secundario `#7A6455`, círculo decorativo arriba a la derecha `#F4D9C0`, ícono de sol (SVG trazo).
- **Soir / Nuit**: fondo azul noche `#1F2342`, texto `#F3F0FA`, acento lila `#B9A6E8`, secundario `#C4C0D8`, círculo decorativo `#2C3159`, ícono de luna (SVG trazo).
- Tipografías: Cormorant Garamond (títulos, nombre de producto 36 px) + DM Sans (etiquetas y acciones), vía Google Fonts.
- Encabezado: "RITUEL SKINCARE" en versalitas espaciadas con el acento, título grande (120 px) "Matin" / "Soir", subtítulo itálico ("Jour · éveiller et protéger" / "Nuit · nourrir et réparer").
- Pie: línea fina, frase en versalitas ("DOUCEUR · ÉCLAT · PROTECTION" / "DOUCEUR · RÉPARATION · REPOS") y "Bonne journée" / "Bonne nuit" en itálica.
- Círculo detrás de cada foto: `#F3DFCB` (Matin), `#2E3460` (Soir).

### Estilo femenino cute

- **Mañana**: fondo rosa `#FFF1F4`, texto `#5B2A3A`, secundario `#8E5A6B`, acento `#C2457A` (opciones `#C2457A`, `#A8508F`, `#C25A5A`, `#8E5AB5`), círculos decorativos `#FFD3DF` / `#FFE3EA`, tarjetas blancas de radio 36 px con sombra rosada suave, círculo detrás de la foto `#FFE0E8`, ícono de sol con carita y cachetes rosas.
- **Noche**: fondo lila noche `#2B2347`, texto `#FFF4FA`, secundario `#D9CBEA`, acento `#F7A8C9` (opciones `#F7A8C9`, `#C9B3F5`, `#FFC4A8`, `#A8E0F7`), tarjetas `#42376B`, bloques por día `#352C55` radio 44 px, círculo detrás de la foto `#2E2650`, luna con carita, estrellitas y destellos sueltos en SVG.
- Tipografías: Dancing Script (títulos 132 px, subtítulos de bloque, frase final) + Fredoka (etiquetas, números, nombres de producto 28-30 px) + Quicksand (acciones).
- Encabezado: chip blanco (o `#42376B` de noche) con corazón + "MI RUTINA SKINCARE", título "Mañana" / "Noche", subtítulo ("Todos los días · despertar, hidratar y proteger" / "Rutina nocturna · limpiar, reparar y descansar").
- Chips de días en píldora con el acento.
- Pie: línea con destello en el medio, frase en versalitas ("SUAVIDAD · GLOW · PROTECCIÓN" / "CALMA · REPARACIÓN · DESCANSO") y "Que tengas un lindo día" / "Dulces sueños" en script con corazón.

## Idioma y texto

- Mantener el idioma en que viene la rutina (los textos fijos del estilo se traducen a ese idioma). Si la usuaria pide traducir algo ("ponlo en francés"), traducirlo y nombrar en la respuesta cómo se interpretó.
- Copiar productos y acciones tal cual; no inventar pasos ni productos. Si un paso viene sin número (ej. bálsamo de labios), numerarlo a continuación.
- Un paso de solo agua no lleva foto: va una gota de agua en SVG (relleno blanco, trazo del acento) sobre el círculo del momento.

## Fotos de producto (lo que la hace ver profesional)

**Regla de calidad**: cada recorte tiene que salir de una foto donde el producto mida al menos ~500 px de alto. Recortar productos chicos de un collage (80-190 px) da fotos borrosas y no sirve. Si las fotos de la usuaria son collages o capturas chicas, ofrecer buscar las fotos oficiales en internet (pedir su ok, porque implica descargar archivos) antes de recortar.

### Opción A: fotos de la usuaria (capturas sueltas, producto grande)

Las fotos suelen ser capturas del celular (barra de estado, botones de Pinterest, franjas negras).

1. **Medir el archivo real** antes de recortar (`Image.open(f).size`): las capturas de iPhone vienen a 1320 px de ancho aunque se vean más chicas. Calcular la caja de recorte en píxeles reales, alrededor del producto, dejando afuera toda la interfaz.
2. Seguir con "Quitar el fondo".

### Opción B: buscar las fotos oficiales en internet (preferida para collages o fotos chicas)

El contenedor y la shell de la compu no llegan a tiendas ni CDNs (403 del proxy). Lo que funciona es el **navegador integrado** de la app de escritorio (herramientas `Claude_Browser__*`; leer antes el skill `built-in-browser`).

1. **Encontrar la foto** (JS en la página, mismo origen):
   - **Amazon** (amazon.com) tiene casi todo el K-beauty: `fetch('/s?k=' + query)` → `DOMParser` → `img.s-image` (alt + id de imagen) y `[data-asin]`. Galería de un producto: `fetch('/dp/' + asin)` y regex `"hiRes":"(https:[^"]+)"`. Máxima resolución: `https://m.media-amazon.com/images/I/<id>._SL1500_.jpg`. Ese CDN permite CORS.
   - **Web oficial de la marca** si es Shopify (ej. anua.us): `/search/suggest.json?q=...&resources[type]=product` y luego `/products/<handle>.js` → `images` (agregar `https:`). Sirve cuando Amazon solo tiene sets o infografías.
   - Olive Young Global y Stylevana no sirven: fotos de sets, CORS bloqueado o desafío de Cloudflare.
   - Si aparece un banner de cookies, rechazar las opcionales (además tapa la pantalla).
2. **Elegir**: armar en la página una grilla fija (`position:fixed; z-index:2147483647`) con las candidatas a ~240 px, sacar screenshot y elegir la que muestra **el producto solo**, sin infografías y, si se puede, sin swatches de textura detrás.
3. **Traer los píxeles al contenedor** (no hace falta la carpeta de Descargas):
   - En JS: cargar la imagen con `crossOrigin='anonymous'` en un canvas, recortar al bbox de píxeles no blancos (min RGB < 240, margen 16 px) y escalar para que entre en **790×590**.
   - Mostrarla en un overlay blanco a pantalla completa, arriba a la izquierda, con tamaño CSS = píxeles × **1.28** (viewport 1024×768, screenshot entregado a 800×600: así 1 px de imagen = 1 px de captura).
   - Esperar 1 s (si no, la captura sale con el contenido anterior) y usar `computer` `zoom` con región `[0, 0, ancho, alto]`. Devuelve un PNG sin pérdida 1:1 guardado en el directorio `tool-results` de la sesión; copiarlo a la carpeta de trabajo.
   - Encadenar mostrar → esperar → zoom con `browser_batch` para varios productos.
4. Si el navegador no está disponible (compu desconectada), decirlo y pedir capturas sueltas a pantalla completa.

### Quitar el fondo

`pip install --break-system-packages "rembg[cpu]" scipy`. **Un producto por proceso** (SAM e isnet en el mismo proceso se quedan sin memoria y mueren sin error). No usar `birefnet-general`: también se queda sin memoria.

- **Productos de color sobre fondo blanco limpio**: máscara por relleno desde los bordes (píxeles con min RGB ≥ 246 y baja saturación conectados al borde = fondo), o máscara `rembg` (`isnet-general-use`) ∪ píxeles no blancos (min RGB < 236); `binary_opening`, componente más grande, `binary_fill_holes`.
- **Envases blancos o translúcidos sobre blanco** (tubos, sprays): unir `rembg` isnet + píxeles no blancos, `binary_closing`, componente más grande y luego **envolvente convexa** (`scipy.spatial.ConvexHull`) dibujada como polígono.
- **Fotos con swatch de textura, burbujas o manchas detrás, o envase blanco que isnet corta**: **SAM** (`new_session('sam')`, `only_mask=True`) con `sam_prompt`: un `rectangle` alrededor del envase + 4-6 puntos positivos a lo largo del eje + puntos negativos sobre el swatch. Medir coordenadas dibujando una grilla cada 50 px sobre la imagen.
- **Cerrar la máscara**: los envases son convexos por fila → rellenar cada fila entre su primer y último píxel (tapa huecos de logos y textos blancos). Si quedan muescas en bordes rectos, envolvente convexa **por franja horizontal** (ej. gotero / collar / cuerpo). Si hay partes con hueco entre ellas (ej. discos sobre la tapa de un frasco), rellenar solo desde debajo de esas partes. Si se cuela un pedazo de swatch pegado (ej. una burbuja junto al gotero), limitar columnas en esa franja.
- Suavizar el borde: `MinFilter(3)` + `GaussianBlur(0.9-1.2)` sobre la máscara.

### Normalizar, revisar y subir

1. Recortar al bbox, escalar para que entre en un lienzo transparente de 520×620, centrado y apoyado abajo (10 px de margen). Guardar PNG.
2. **Revisar siempre** con una hoja de contacto a buen tamaño (~260×310 por producto): todos los recortes sobre el fondo de la lámina de mañana y de la de noche del estilo elegido, y mirarla con Read antes de subir. Buscar restos de swatch, bordes cortados en diagonal, huecos en logos y partes faltantes (goteros, picos de bomba). Si un envase blanco se comió bordes, pasarlo por envolvente convexa o SAM.
3. Subir los PNG como assets del canvas (`asset: true`, varios en una llamada) y usar las URLs `/_blob/...` tal cual.

Presentación de cada foto (celda de 140×150):

- Círculo de 120 px apoyado abajo, en el tono suave del estilo.
- Sombra elíptica difusa en la base (64×10 px, `blur(4px)`).
- La imagen encima con `object-fit: contain; object-position: center bottom` y `filter: drop-shadow(0 8px 10px ...)`.
- Sin caja blanca alrededor.

Si falta la foto de un producto: círculo punteado de 120 px con "PHOTO"/"FOTO" en el mismo lugar, y en la respuesta listar exactamente qué productos faltan (contarlos bien: un producto que aparece mañana y noche cuenta una vez).

## Flujo con el canvas

1. Paso 0 (estilo) si corresponde.
2. Listar tipos de Artifact y crear desde el tipo **Design** con un título como "Rituel Skincare" o "Mi Rutina Skincare".
3. Escribir `project/canvas.json` (dos tableros lado a lado, 80 px de separación) y `project/Main.dc.html` (mañana), publicar; luego el de noche y publicar.
4. Para fotos nuevas en un canvas existente: recortar, subir, reemplazar el placeholder del paso correcto con un script (verificando por el nombre del producto o la etiqueta del paso que se reemplaza el que corresponde) y publicar solo los archivos cambiados.
5. Para **reemplazar** fotos ya puestas: script con un mapa explícito `/_blob/<viejo>` → nuevo, que cuenta los reemplazos por archivo y falla si queda algún id que no esté en el mapa ni en la lista de los que se conservan.
6. No verificar renderizando el canvas salvo que la usuaria lo pida.

## Respuesta

Corta, en español rioplatense casual: qué quedó, qué estilo se usó, qué supuestos tomaste (traducciones, numeración, variante del producto si la foto oficial no es idéntica a la suya, ej. SPF45 vs SPF50+), de dónde salieron las fotos y qué fotos faltan. Mencionar que se exporta a PDF o imagen desde Share › Export.