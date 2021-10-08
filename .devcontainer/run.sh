#!/bin/bash
set -euo pipefail

export TAG=`date -u +"%Y%m%dT%H%M%SZ"`

cargo build --target wasm32-wasi --release
wasm-opt -O4 target/wasm32-wasi/release/hello-world-rust.wasm -o target/wasm32-wasi/release/hello-world-rust-opt.wasm
bin/wasm-to-oci push target/wasm32-wasi/release/hello-world-rust-opt.wasm "localhost:12345/hello-world-rust:${TAG}"

DEPLOYMENTS=`kubectl get deployments | wc -l`
if [ "$DEPLOYMENTS" -ge 2 ]
then
    kubectl delete deployment hello-world-wasi-rust
fi

cat deploy/codespace.yaml | envsubst | kubectl apply -f -

echo "Build deployed"
