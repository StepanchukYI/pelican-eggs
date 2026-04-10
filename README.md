# pelican-eggs

Custom Pelican/Pterodactyl eggs and Docker images.

## GravitLauncher — Java 25

Fork of [VIZZI-DK/gravit-eggs](https://github.com/VIZZI-DK/gravit-eggs) (which never shipped a Java 25 image to any registry).

- **Dockerfile:** [`docker/gravit-java25/Dockerfile`](docker/gravit-java25/Dockerfile) — `eclipse-temurin:25-jdk-noble` + OpenJFX 25 jmods.
- **Egg JSON:** [`docker/gravit-java25/gravit-egg.json`](docker/gravit-java25/gravit-egg.json) — import into Pelican.
- **Image:** `ghcr.io/stepanchukyi/pelican-eggs:gravit-java25` (built by GitHub Actions on push to `main`).

### Import into Pelican

1. Wait for the `build gravit-java25` workflow to finish (see Actions tab).
2. Ensure the GHCR package visibility is **public** (Packages → pelican-eggs → Package settings → Change visibility → Public).
3. Panel → Nests → Import Egg → upload `docker/gravit-java25/gravit-egg.json`.
4. Create a server from the nest and deploy.

### Rebuild locally (optional)

```bash
cd docker/gravit-java25
docker build -t ghcr.io/stepanchukyi/pelican-eggs:gravit-java25 .
docker push ghcr.io/stepanchukyi/pelican-eggs:gravit-java25
```
