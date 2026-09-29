# moodle-deisi

Moodle image for DEISI based on [erseco/alpine-moodle](https://github.com/erseco/alpine-moodle), with Node.js and [jsdom](https://github.com/jsdom/jsdom) installed globally.

The image is built by GitHub Actions and published to the GitHub Container Registry:

```
docker pull ghcr.io/mdmourao/moodle-deisi:latest
```

## Run locally

```
docker compose up -d
```

Moodle is then at http://localhost. Change `MOODLE_PASSWORD` in `docker-compose.yml` first.

## Build arguments

- `MOODLE_TAG` (default `v5.2.3`): tag of `erseco/alpine-moodle` to build from.
- `JSDOM_VERSION` (default `latest`): jsdom version installed with npm.

## Tags

- `latest`: latest build of `main`
- `vX.Y.Z`: pushing a git tag `vX.Y.Z` publishes it
- `sha-<commit>`: every build
