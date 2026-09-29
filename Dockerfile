# Moodle image for DEISI with CodeRunner, Node.js and jsdom installed.
# Base: https://github.com/erseco/alpine-moodle
ARG MOODLE_TAG=v5.2.3
ARG NODE_VERSION=22

# Alpine 3.20 (used by the Moodle base) only ships Node 20, which is too old for
# current jsdom, so Node is copied from the official Alpine (musl) Node image.
FROM node:${NODE_VERSION}-alpine AS node

FROM erseco/alpine-moodle:${MOODLE_TAG}

USER root

COPY --from=node /usr/lib/libstdc++.so.6* /usr/lib/libgcc_s.so.1 /usr/lib/
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm

# jsdom installed globally, so scripts run by Moodle can `require('jsdom')`
ENV NODE_PATH=/usr/local/lib/node_modules
ARG JSDOM_VERSION=latest
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && npm install -g jsdom@${JSDOM_VERSION} \
    && npm cache clean --force \
    && node -e "require('jsdom'); console.log('jsdom OK, node ' + process.version)"

COPY --chown=nobody rootfs/ /

USER nobody

# CodeRunner question type and its behaviour, baked into both the immutable source
# tree and the runtime tree. Student code runs on the Jobe server (see jobe/).
ARG CODERUNNER_VERSION=v5.10.6
ARG CODERUNNER_BEHAVIOUR_VERSION=v1.4.8
RUN set -e; \
    for root in /usr/src/moodle /var/www/html; do \
      base="$root"; [ -d "$root/public" ] && base="$root/public"; \
      mkdir -p "$base/question/type/coderunner" "$base/question/behaviour/adaptive_adapted_for_coderunner"; \
      curl -fsSL --retry 5 "https://github.com/trampgeek/moodle-qtype_coderunner/archive/refs/tags/${CODERUNNER_VERSION}.tar.gz" \
        | tar xz --strip-components=1 -C "$base/question/type/coderunner"; \
      curl -fsSL --retry 5 "https://github.com/trampgeek/moodle-qbehaviour_adaptive_adapted_for_coderunner/archive/refs/tags/${CODERUNNER_BEHAVIOUR_VERSION}.tar.gz" \
        | tar xz --strip-components=1 -C "$base/question/behaviour/adaptive_adapted_for_coderunner"; \
    done
