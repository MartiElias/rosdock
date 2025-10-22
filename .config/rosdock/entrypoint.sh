#!/usr/bin/env bash
set -euo pipefail

cat /rosdock/bash_setup.txt >> ~/.bashrc
# Ejecuta el comando recibido
exec "$@"
