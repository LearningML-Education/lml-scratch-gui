# Changelog LML

Registro de cambios propios de la personalización LearningML de
`scratch-gui`, distinto de [`CHANGELOG.md`](./CHANGELOG.md) (que es el
changelog heredado del proyecto original y no se actualiza a mano en
este fork).

## [2.0.2] - 2026-08-19

### Added
- El proceso de release (`AGENTS.md`) ahora actualiza el campo
  `lml_version` de `package.json` y añade una entrada aquí en cada tag,
  en vez de dejarlos desincronizados como hasta ahora.
- Se crea este `CHANGELOG-lml.md`.

## [2.0.1] - 2026-08-19

### Changed
- Release de prueba del nuevo pipeline de despliegue (ver entrada
  `2.0.0-beta7 y anteriores`). Sin cambios funcionales en la
  aplicación.

## [2.0.0-beta7 y anteriores]

### Changed
- El despliegue en GitHub Pages se construye y publica directamente
  desde `lml-scratch-gui` (clonando `lml-scratch-vm` y
  `lml-scratch-l10n`, ya públicos, y enlazándolos con `npm link`). Antes
  se delegaba en un repositorio intermedio, `lml-scratch`, que clonaba
  los tres repos (entonces privados) con un token de lectura.
- Se corrigió la política de deployment branch del entorno
  `github-pages` en GitHub para permitir despliegues disparados por
  tags (`v*`), que la configuración por defecto rechazaba.
