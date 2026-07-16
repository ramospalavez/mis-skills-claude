---
name: uruvet-error-tracking
description: Implementa captura de errores, alertas por email, trazabilidad de requests (request ID) y métricas de uptime/latencia/error rate para el monorepo UruVet (uruvet-api en NestJS+TypeORM+Postgres, uruvet-admin/uruvet-intra/uruvet-web en Angular, uruvet-clientes PWA). Usá este skill cada vez que Romina pida agregar error tracking, alerting, logging centralizado, trazabilidad de un bug de punta a punta, o visibilidad de qué se rompe en prod — sea para todo el monorepo o para un módulo puntual (ej. "agregale alertas al webhook de pagos", "quiero saber cuándo falla un job de sync", "necesito rastrear este error hasta el final"). No uses este skill para bugs puntuales que no tienen que ver con instrumentación (eso es debugging normal, no este skill).
---

# UruVet — Error Tracking y Alerting

Objetivo: que Romina se entere por email cuando algo se rompe en serio en prod (no de
cada 404), pueda rastrear cualquier error de punta a punta con un solo ID, y tenga
números (tasa de error, latencia, uptime) para ver si algo empeora con el tiempo.

Todo lo de `CLAUDE.md` aplica sin excepción acá: tests en el mismo commit, migración
TypeORM en el mismo commit que el cambio de entidad, no commitear/pushear sin permiso,
reportar DONE/DONE_WITH_CONCERNS/BLOCKED/NEEDS_CONTEXT al terminar, decir qué reiniciar.
Esta skill no repite esas reglas para acortar — las da por leídas.

## 0. Antes de escribir una línea: fijate qué ya existe

No asumas que el proyecto está vacío de esto. Buscá antes de instalar nada nuevo:

- `grep -r "sentry\|datadog\|newrelic\|logrocket" package.json */package.json` en el
  monorepo — si ya hay una herramienta de error tracking instalada, extendé esa, no
  metas una segunda que compita.
- Buscá un módulo de mail ya armado (`grep -ri "mailer\|nodemailer\|resend\|sendgrid"
  uruvet-api/src -r`, mirá si existe algo en `modules/common/`). Si ya hay uno, usalo
  para las alertas — no agregues un segundo proveedor de email.
- Buscá si ya hay logging estructurado (`winston`, `pino`, un `Logger` custom).
- Si algo de esto existe, tu trabajo es conectarlo con lo que falta de este skill, no
  reemplazarlo.
- Si nada existe: para error tracking + alerting + trazas + tendencias todo-en-uno, la
  Capa 1 (herramienta probada, "no reinventes") es un servicio tipo Sentry (hay opción
  self-hosted gratis, GlitchTip, si el punto es no pagar SaaS). Instalar un servicio
  externo implica una cuenta nueva — eso lo da de alta Romina, no vos. Decíselo en una
  frase y esperá luz verde antes de asumir que vamos por ahí. La alternativa (construir
  esto con Postgres + un par de módulos NestJS, como se describe abajo) no depende de
  ningún servicio externo ni cuenta nueva, así que es la opción por defecto si no hay
  luz verde para instalar algo pago.

## 1. Request ID de punta a punta

- Middleware en `uruvet-api` que toma el header `x-request-id` si el caller ya mandó
  uno (útil para requests encadenados entre frontend → API → webhook), o genera uno
  nuevo con `crypto.randomUUID()` si no vino.
- Guardalo en `AsyncLocalStorage` (o `nestjs-cls`, es librería estándar para esto en
  Nest — Capa 1) para que cualquier service o el logger lo lean sin que se lo pases
  como parámetro a mano por todos lados.
- Devolvé el mismo ID en el header de la respuesta y en cualquier error serializado al
  cliente — así el usuario (o el frontend) puede reportarlo y vos lo buscás directo.
- Test: `request-id.middleware.spec.ts` — cubre "genera uno nuevo si no viene" y
  "respeta el que viene del caller".

## 2. Captura de errores por capa

### Backend (`uruvet-api`)

- `AllExceptionsFilter` global (`APP_FILTER`) que atrapa `HttpException`, errores de
  TypeORM (constraint violations, fallas de conexión) y cualquier excepción no
  manejada.
- Clasificá severidad ahí mismo: 5xx y no controlados = **CRÍTICO**; 4xx esperados
  (validación, 404, auth) = informativo, no dispara alerta ni infla el ruido.
- Cada error arma un `ErrorEvent`: `requestId`, `timestamp`, `stack`, `endpoint`,
  método HTTP, `userId` (si hay sesión), contexto (qué intentaba hacer — endpoint +
  operación, no el body crudo), `environment` (`process.env.NODE_ENV`), mensaje.
  **Nunca** metas passwords, tokens, ni datos de tarjetas en el contexto o el stack
  serializado.
- Persistí el `ErrorEvent` en Postgres (tabla `error_events`, migración TypeORM en el
  mismo commit que la entidad) — con esto tenés trazabilidad y tendencias sin depender
  de un tercero.
- Webhooks/automatizaciones (ej. procesamiento asíncrono de pagos): no pasan por el
  filtro HTTP porque no tienen response — envolvé el handler en try/catch que llama al
  mismo `ErrorTrackingService.capture()` que usa el filtro, para que compartan un solo
  camino captura → alerta en vez de tener dos sistemas paralelos.
- Funciones serverless, si las hay: mismo patrón, wrapper fino que delega a
  `ErrorTrackingService`.
- Errores fuera del ciclo de un request (falla de conexión a la DB al bootear,
  migraciones que fallan): logueálos directo con `ErrorTrackingService` desde el
  bootstrap de Nest.

### Frontend (`uruvet-admin`, `uruvet-intra`, `uruvet-web` — Angular)

- `GlobalErrorHandler implements ErrorHandler`, provisto en el `AppModule`
  reemplazando el default — captura excepciones no manejadas de Angular (incluye
  errores de render y de RxJS sin catch).
- `HttpInterceptor` que loguea errores de response (4xx/5xx) adjuntando el
  `x-request-id` que vino en la respuesta del backend.
- Ambos postean a `POST /error-events` en `uruvet-api` (mismo `ErrorTrackingService`
  del backend) — el frontend no decide si algo alerta, eso lo decide el backend según
  severidad.

### PWA (`uruvet-clientes`)

- Mismo patrón de `GlobalErrorHandler` si es Angular; si no, `window.onerror` +
  `window.onunhandledrejection` posteando al mismo endpoint.
- Si el POST falla por estar offline: encolar en IndexedDB y reintentar cuando vuelva
  la conexión — no perder el error, pero tampoco bloquear la app esperando la red.

### Errores de base de datos

Los que ocurren dentro de un request los agarra el `AllExceptionsFilter` (TypeORM los
tira como excepciones normales). Los que ocurren fuera de un request (bootstrap,
migraciones) van directo a `ErrorTrackingService` como se describe arriba.

## 3. Alertas por email — solo lo crítico

- `ErrorTrackingService.capture(event)` siempre persiste en Postgres. Si
  `event.severity === 'CRITICO'`, llama a `AlertMailer.send(event)`.
- Formato del email (fijo, no lo cambies sin que Romina lo pida):
  - **Subject:** `[CRÍTICO] Error - {tipoDeError}`
  - **Body:** timestamp, stack trace completo, endpoint/URL, `userId`, contexto (qué
    operación intentaba — ej. "checkout de turno", "sync de pago vía webhook"),
    ambiente (prod/staging), y el `requestId` para buscarlo después.
- Rate-limit las alertas: si el mismo tipo de error se repite muchas veces en poco
  tiempo (ej. la DB se cae y tira 500 errores en un minuto), no mandes 500 emails —
  agrupá por tipo de error + ventana de tiempo (ej. 5 minutos) y mandá un solo email
  con el conteo. Sin esto el alerting se convierte en ruido y la primera vez que
  importe, Romina ya lo va a estar ignorando.
- Proveedor de email: revisá el paso 0 primero. Si no hay nada armado, `@nestjs-modules/mailer`
  es la opción estándar en Nest (Capa 1) — pero antes de asumir un proveedor
  (Resend, SMTP, SendGrid) nuevo, preguntale a Romina cuál ya paga o prefiere.

## 4. Trazabilidad y logs centralizados

- Logger estructurado (JSON), no `console.log` suelto. Si no hay uno, `nestjs-pino` es
  la opción estándar (Capa 1, no reinventes un formatter de logs).
- Configurá el logger una sola vez para que incluya el `requestId` del
  `AsyncLocalStorage` automáticamente en cada línea — no lo repitas a mano en cada
  `log.info(...)`.
- "Rastrear un error de inicio a fin" sale gratis una vez que el `requestId` está
  propagado (paso 1) y todo (logs + `error_events`) está tageado con él: buscás por ese
  ID y tenés la traza completa.
- Búsqueda y filtrado: un endpoint admin `GET /error-events?severity=&from=&to=&endpoint=`
  protegido por auth de admin, consumido por una pantalla simple en `uruvet-admin`. Con
  el volumen de UruVet, Postgres con índices en `requestId`, `severity` y `createdAt`
  alcanza — no hace falta un Kibana ni un ELK para esto.

## 5. Feedback loop — métricas

- Tasa de error y tendencias: query agrupada por día/endpoint sobre `error_events` —
  ya la tenés gratis con la tabla del paso 2.
- Latencia de APIs: interceptor NestJS que mide el tiempo entre entrada y salida del
  request, logueado con el mismo `requestId`. Si más adelante hace falta un dashboard
  en serio, exponer `/metrics` en formato Prometheus es lo estándar (Capa 1) — no lo
  instales de entrada si nadie lo va a mirar todavía; preguntale a Romina si quiere el
  dashboard ahora o le alcanza con los datos crudos por un tiempo.
- Uptime: healthcheck en `/health` con `@nestjs/terminus` (ya es librería estándar de
  Nest, no construyas un monitor de uptime a mano), chequeado por un cron externo o
  UptimeRobot.

## Orden sugerido de implementación

1. Paso 0 (investigar qué ya existe) — no sigas sin esto, cambia todo lo demás.
2. Request ID (paso 1) — todo lo demás depende de que este exista primero.
3. `ErrorTrackingService` + tabla `error_events` + `AllExceptionsFilter` (paso 2,
   backend primero).
4. `AlertMailer` + formato de email + rate-limit (paso 3).
5. Frontend/PWA (paso 2, resto) — dependen del endpoint `POST /error-events` ya
   armado en el paso anterior.
6. Logging estructurado + endpoint de búsqueda (paso 4).
7. Métricas/health (paso 5) — es lo último porque es lo menos urgente de los cuatro
   pedidos originales.

Cada paso de esta lista es su propio commit potencial con sus tests — no los mezcles
en un commit gigante "agregar error tracking" que sea imposible de revisar.
