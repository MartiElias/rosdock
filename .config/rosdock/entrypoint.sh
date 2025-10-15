#!/usr/bin/env bash
set -euo pipefail

cat /rosdock/bashfile.txt >> ~/.bashrc
# Ejecuta el comando recibido
exec "$@"
