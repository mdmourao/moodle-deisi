# moodle-deisi

Moodle for DEISI with [CodeRunner](https://coderunner.org.nz) questions that can use [jsdom](https://github.com/jsdom/jsdom) in Node.js.

Two images are built by GitHub Actions and published to the GitHub Container Registry:

| Image | What it is |
|-------|------------|
| `ghcr.io/mdmourao/moodle-deisi` | Moodle ([erseco/alpine-moodle](https://github.com/erseco/alpine-moodle)) with the CodeRunner plugins, plus Node.js 22 and jsdom |
| `ghcr.io/mdmourao/moodle-deisi-jobe` | [Jobe](https://github.com/trampgeek/jobeinabox) sandbox, where CodeRunner runs student code, with Node.js 22 and jsdom |

CodeRunner does not run code inside Moodle: it sends it to the Jobe server. That is why jsdom must be in the Jobe image for questions to use it.

## Run locally

```
docker compose up -d
```

This pulls the latest images from GHCR (no build). To build them from this repo instead:

```
docker compose -f docker-compose.yml -f docker-compose.build.yml up -d --build
```

Moodle is then at http://localhost (first start takes a few minutes). Log in with `admin` / `admin` (test only: change `MOODLE_PASSWORD` in `docker-compose.yml` for anything public). CodeRunner is configured automatically to use the `jobe` container.

## Codespaces

Open the repo in a Codespace (Code → Codespaces → Create codespace on main). It starts Moodle, Postgres and Jobe and forwards port 80; open the "Moodle" port from the Ports tab.

## Test jsdom in Moodle

1. Create a course (or use any course) and open its **Question bank**.
2. **Import** → format **Moodle XML** → upload [`examples/pergunta-jsdom.xml`](examples/pergunta-jsdom.xml).
3. Open the question in **Preview**, paste the answer below and click **Check**. Both tests should pass.

```js
const { JSDOM } = require('jsdom');

function titulo(html) {
  return new JSDOM(html).window.document.querySelector('h1').textContent;
}
```

## Build arguments

Moodle image (`Dockerfile`):

- `MOODLE_TAG` (default `v5.2.3`): tag of `erseco/alpine-moodle`.
- `NODE_VERSION` (default `22`): Node.js major version.
- `JSDOM_VERSION` (default `latest`).
- `CODERUNNER_VERSION` / `CODERUNNER_BEHAVIOUR_VERSION`: plugin tags.

Jobe image (`jobe/Dockerfile`): `JOBE_TAG`, `NODE_VERSION`, `JSDOM_VERSION`.

## Tags

- `latest`: latest build of `main`
- `vX.Y.Z`: pushing a git tag `vX.Y.Z` publishes it
- `sha-<commit>`: every build
