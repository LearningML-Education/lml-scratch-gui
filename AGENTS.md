# AGENTS.md

Instrucciones para agentes de codificación (Claude Code, Codex, Cursor,
Copilot Workspace, etc.) que trabajen en este repositorio.

## Publicar una nueva release

El sitio en GitHub Pages (`https://learningml.org/lml-scratch-gui/`) se
construye y despliega directamente desde este repositorio. El workflow
`.github/workflows/deploy-pages.yml` clona `lml-scratch-vm` y
`lml-scratch-l10n` (públicos) en el **mismo nombre de tag** que se
empuje aquí, los enlaza con `npm link` y publica el resultado.

Repos hermanos, mismo nivel que este (`org` GitHub:
`LearningML-Education`):
- `../lml-scratch-l10n`
- `../lml-scratch-vm`
- `../lml-scratch-gui` (este repo)

**Los tres repos deben tener un tag con el mismo nombre exacto** antes
de que el deploy se dispare, o el paso `git clone --branch "$TAG_NAME"`
del workflow falla.

**Requisito de configuración (ya aplicado, verificar si algo falla):**
el entorno `github-pages` de este repo en GitHub tiene protección de
rama de despliegue (`custom_branch_policies: true`). Por defecto solo
permitía la rama `main`, lo que rechazaba el deploy disparado por
`push: tags` (un tag no es una rama). Hay que tener una política de
tipo `tag` que cubra el patrón de tags usado (`v*`):
```bash
gh api repos/LearningML-Education/lml-scratch-gui/environments/github-pages/deployment-branch-policies \
  -f name='v*' -f type=tag
```
Si un release falla en segundos con la anotación *"Tag ... is not
allowed to deploy to github-pages due to environment protection
rules"*, es este el problema — revisa las políticas con:
```bash
gh api repos/LearningML-Education/lml-scratch-gui/environments/github-pages/deployment-branch-policies
```

### Procedimiento

1. Elegir `TAG` (sigue el esquema existente, p. ej. `v2.0.0-beta7`; usa
   `git tag -l` en los tres repos para ver el último y proponer el
   siguiente). Si no está claro, pregunta al usuario en vez de asumir.

2. En cada uno de los tres repos, comprobar antes de tocar nada:
   ```bash
   git status                 # debe estar limpio
   git status -sb             # rama al día con origin (sin ahead/behind)
   git tag -l "$TAG"          # debe estar vacío (el tag no debe existir ya)
   ```
   Si algo no cumple, para y resuélvelo (o pregunta) antes de continuar.

3. Confirmar con el usuario el tag y los commits que se van a etiquetar
   antes de empujar nada — es una acción visible en repos públicos y
   dispara CI.

4. Crear y empujar el tag **en este orden: `l10n` → `vm` → `gui`**
   (`gui` va último porque su `push --tags` dispara el workflow, y para
   entonces `vm`/`l10n` ya deben tener el tag en remoto):
   ```bash
   cd lml-scratch-l10n && git tag -a "$TAG" -m "$TAG" && git push origin "$TAG"
   cd ../lml-scratch-vm && git tag -a "$TAG" -m "$TAG" && git push origin "$TAG"
   cd ../lml-scratch-gui && git tag -a "$TAG" -m "$TAG" && git push origin "$TAG"
   ```

5. Localizar y esperar el run que dispara el push del tag:
   ```bash
   RUN_ID=$(gh run list --workflow=deploy-pages.yml \
     -R LearningML-Education/lml-scratch-gui --limit 1 --json databaseId --jq '.[0].databaseId')
   gh run watch "$RUN_ID" --exit-status -R LearningML-Education/lml-scratch-gui
   ```
   Si el run no aparece (retraso de GitHub), dispararlo manualmente:
   ```bash
   gh workflow run deploy-pages.yml -f tag="$TAG" -R LearningML-Education/lml-scratch-gui
   ```

6. Si `gh run watch` sale con éxito, verificar el sitio:
   ```bash
   curl -sI https://learningml.org/lml-scratch-gui/
   ```
   Si falla, inspeccionar el paso que falló:
   ```bash
   gh run view "$RUN_ID" --log-failed -R LearningML-Education/lml-scratch-gui
   ```
   (típicamente: tag ausente en `vm`/`l10n`, o fallo real de build/`npm link`).

### Notas

- La variable `MOBILENET_BASE_URL` vive en el entorno `github-pages` de
  este repo en GitHub (Settings → Environments) — no se toca en un
  release normal.
- El repo `lml-scratch` (antiguo orquestador) ya no participa en este
  flujo; no hace falta tocarlo.
- Ver también la sección "Despliegue en GitHub Pages" de `README.md`.
