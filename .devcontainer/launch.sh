#!/bin/bash
set -euo pipefail

CLUSTERS=$(k3d cluster list -o json | jq 'length')
if [ $CLUSTERS -eq '0' ]; then
  k3d registry create host.k3d.internal --port 12345
  k3d cluster create --registry-use host.k3d.internal:12345 -p "8081:80@loadbalancer" --volume $(pwd)/.platform/data:/dev-data
  kubectl wait --for=condition=complete job/helm-install-traefik-crd -n kube-system --timeout=60s
  for D in .platform/*; do
      if [ -d "${D}" ] && [ "${D}" != ".platform/data" ]; then
          kubectl apply -f "${D}"
      fi
  done
else
  k3d cluster start
fi

# prep WASI Rust target
rustup target add wasm32-wasi

# install wasm-opt tool
npm i wasm-opt -g

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
$SCRIPT_DIR/start-kubelet.sh
