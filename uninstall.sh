# Uninstalling rosdock from /bin folder
echo "Uninstalling rosdock from /bin"
sudo rm /bin/rosdock

# Check exit status of last command
if [ $? -eq 0 ]; then
    echo "✅ Command executed successfully."
else
    echo "❌ Error: command failed."
fi

# sudo rm /bin/rosdock_connect 
# sed -i '/soruce rosdock_connect/d' ~/bashrc
