# Installing rosdock
echo "Giving executable permissions to rosdock"
chmod +x rosdock
echo "Installing rosdock in /bin folder"
sudo cp rosdock /bin/rosdock

# Check exit status of last command
if [ $? -eq 0 ]; then
    echo "✅ rosdock installed successfully."
else
    echo "❌ Error: command failed."
fi

# Check if yq is installed
if ! command -v yq >/dev/null 2>&1; then
  echo "[rosdock] yq not found, installing..."
  sudo apt-get update && sudo apt-get install -y yq
fi


# chmod +x rosdock_connect
# sudo cp rosdock_connect /bin/rosdock_connect
# echo "soruce rosdock_connect" >> ~/.bashrc
