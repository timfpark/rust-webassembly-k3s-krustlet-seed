#!/bin/bash
set -euo pipefail

code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools --force
octant --disable-origin-check
