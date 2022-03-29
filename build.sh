#!/usr/bin/env sh

architecture=$(arch)
image=1001fonts/docker_state_exporter:latest

if [ "$architecture" = "arm64" ] || [ "$CI" = true ]; then
    docker buildx build \
        --platform linux/arm64/v8,linux/amd64 \
        --no-cache --pull \
        -t "${image}" \
        --push .
else
    docker build --no-cache --pull -t "${image}" .
    docker push "${image}"
fi
