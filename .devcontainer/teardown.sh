#!/bin/bash
set -euo pipefail

k3d cluster delete
k3d registry delete --all
