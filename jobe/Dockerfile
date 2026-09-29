# Jobe sandbox (runs CodeRunner code) with Node.js and jsdom.
# Base: https://github.com/trampgeek/jobeinabox
ARG JOBE_TAG=latest
ARG NODE_VERSION=22

# Ubuntu's Node is too old for current jsdom, so Node comes from the official image.
FROM node:${NODE_VERSION}-bookworm-slim AS node

FROM trampgeek/jobeinabox:${JOBE_TAG}

COPY --from=node /usr/local/bin/node /usr/bin/node
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

# Jobe runs student code with /usr/bin/nodejs and a clean environment (no NODE_PATH),
# so jsdom is linked into /usr/lib/node, one of Node's built-in global module folders.
ARG JSDOM_VERSION=latest
RUN printf '%s\n' '#!/bin/sh' \
      '# Jobe caps address space (CodeRunner default 1000 MB). glibc reserves 64 MB of' \
      '# address space per malloc arena and V8 starts one worker thread per core, so' \
      '# cap both or Node dies with "heap out of memory" before running any code.' \
      'export MALLOC_ARENA_MAX=2' \
      'exec /usr/bin/node --v8-pool-size=2 "$@"' > /usr/bin/nodejs \
    && chmod 755 /usr/bin/nodejs \
    && ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && mkdir -p /opt/node-libs \
    && npm install --prefix /opt/node-libs jsdom@${JSDOM_VERSION} \
    && npm cache clean --force \
    && rm -rf /usr/lib/node \
    && ln -s /opt/node-libs/node_modules /usr/lib/node \
    && cd /tmp && env -i /usr/bin/nodejs -e "require('jsdom'); console.log('jsdom OK, node ' + process.version)"
