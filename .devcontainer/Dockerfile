# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.192.0/containers/codespaces-linux/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/universal:1-focal

# ** [Optional] Uncomment this section to install additional packages. **
USER root
#
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
#

RUN curl -L https://github.com/rancher/k3d/releases/download/v4.4.8/k3d-linux-amd64 -o /usr/local/bin/k3d \
  && chmod +x /usr/local/bin/k3d

RUN curl -LO https://github.com/vmware-tanzu/octant/releases/download/v0.24.0/octant_0.24.0_Linux-64bit.tar.gz \
  && tar xvf octant_0.24.0_Linux-64bit.tar.gz \
  && mv ./octant_0.24.0_Linux-64bit/octant /usr/local/bin/octant

USER codespace
