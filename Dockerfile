# syntax=docker/dockerfile:1.7-labs

FROM bufbuild/buf:latest as buf

FROM dart:stable AS build

# Copy Buf binary
COPY --from=buf /usr/local/bin/buf /usr/local/bin/buf

# Install required global packages
RUN dart pub global activate melos
RUN dart pub global activate build_runner
RUN dart pub global activate protoc_plugin

# Boostrap melos workspace
WORKDIR /app
COPY pubspec.* .
COPY melos.yaml .
RUN dart pub get

COPY --parents packages/**/pubspec.* .
RUN melos bootstrap

# Generate protocol buffers
COPY --parents packages/**/buf.* .
COPY --parents packages/**/*.proto .
RUN melos run buf:generate

# Generate protocol buffers
COPY --parents packages/**/buf.* .
COPY --parents packages/**/*.proto .
RUN melos run buf:generate

# Build schemas
COPY --parents packages/**/build.yaml .
COPY --parents packages/**/*.dart .
RUN melos run build_runner:build

# Compile executable
WORKDIR /app/packages/lutrachat_backend/lutrachat_backend_rest/bin
RUN dart compile exe lutrachat_backend_rest.dart -o lutrachat_backend_rest

FROM alpine:latest

# Add Sqlite driver
RUN apk add --no-cache sqlite-libs sqlite-dev

# Copy binaries
COPY --from=build /runtime/ /
COPY --from=build /app/packages/lutrachat_backend/lutrachat_backend_rest/bin/lutrachat_backend_rest /usr/bin/lutrachat_backend_rest

ENTRYPOINT ["/usr/bin/lutrachat_backend_rest"]
