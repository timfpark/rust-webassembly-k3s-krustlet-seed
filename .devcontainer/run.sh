#!/bin/bash
set -euo pipefail

export TAG=`date -u +"%Y%m%dT%H%M%SZ"`

cargo build --target wasm32-wasi --release
bin/wasm-to-oci push target/wasm32-wasi/release/hello-world-rust.wasm "localhost:12345/hello-world-rust:${TAG}"

cat deploy/codespace.yaml | envsubst | kubectl apply -f -

echo "Build deployed"
