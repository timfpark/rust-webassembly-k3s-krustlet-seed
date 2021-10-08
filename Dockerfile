# syntax=docker/dockerfile:1.3-labs
FROM rust as build

# capture dependencies
RUN cargo new app
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
RUN --mount=type=cache,target=/usr/local/cargo/registry cargo build --release

# build the app
COPY src ./src
RUN --mount=type=cache,target=/usr/local/cargo/registry <<EOF
  touch src/main.rs         # update timestamp to force a new build
  cargo build --release
EOF

CMD ["/app/target/release/app"]

# slim runtime image
FROM debian:buster-slim as app
COPY --from=build /app/target/release/app /app
CMD ["/app"]
