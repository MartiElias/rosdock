#!/usr/bin/env bash
set -euo pipefail

echo "Uninstalling rosdock from /usr/local/bin"
sudo rm /usr/local/bin/rosdock
echo "✅ rosdock uninstalled successfully."

echo "Note: yq has been left installed because it may have been present before rosdock or be used by other tools."
echo "If you are sure you no longer need it, you can remove it with: sudo apt-get remove yq"