#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Check if yq is installed
if ! command -v yq >/dev/null 2>&1; then
  echo "[rosdock] yq not found, installing..."
  sudo apt-get update
  sudo apt-get install -y yq
fi

# Installing rosdock
echo "Installing rosdock in /usr/local/bin"
sudo install -m 755 "$SCRIPT_DIR/rosdock" /usr/local/bin/rosdock
echo "✅ rosdock installed successfully."

# Optional Bash completion instructions
cat <<'EOF'

Optional: enable Bash autocompletion.
Add this to ~/.bashrc, then run: source ~/.bashrc

complete -o nospace -W 'attach --image= --root= --name= --gpus= --display= --rm= --env --mount --device --group_add --docker_args= --verbose --help' rosdock
EOF