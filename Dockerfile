# syntax=docker/dockerfile:1.7

FROM golang:1.25 AS builder
WORKDIR /src

COPY go.mod go.sum ./

# Private HavocAI modules (e.g. mavlink-dialect) require auth. Use a BuildKit
# secret so the token never appears in an image layer.
RUN --mount=type=secret,id=GITHUB_TOKEN \
    git config --global \
        url."https://x-access-token:$(cat /run/secrets/GITHUB_TOKEN)@github.com/".insteadOf \
        "https://github.com/" && \
    GOPRIVATE=github.com/HavocAI/* go mod download

COPY . .

# Passed in from CI; override the Makefile's git-derived variables so the
# version string is correct even though .git is not in the build context.
ARG GIT_TAG=""
ARG COMMIT=00000000
ARG BRANCH=unknown

RUN make telegraf tag="${GIT_TAG}" commit="${COMMIT}" branch="${BRANCH}"

# Replace the binary in the official Telegraf image so we inherit its
# entrypoint, default config layout, and user setup unchanged.
FROM telegraf:1.35.0

COPY --from=builder /src/telegraf /usr/bin/telegraf
