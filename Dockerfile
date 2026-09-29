# Moodle image for DEISI with Node.js and jsdom installed.
# Base: https://github.com/erseco/alpine-moodle
ARG MOODLE_TAG=v5.2.3
FROM erseco/alpine-moodle:${MOODLE_TAG}

USER root

# Node.js + jsdom (global), so scripts run by Moodle can `require('jsdom')`
ARG JSDOM_VERSION=latest
RUN apk add --no-cache nodejs npm \
    && npm install -g jsdom@${JSDOM_VERSION} \
    && npm cache clean --force \
    && node -e "require('jsdom'); console.log('jsdom OK')"

ENV NODE_PATH=/usr/local/lib/node_modules

USER nobody
