# 🐋 rosdock  
**Portable ROS 2 development made simple**  
`rosdock` lets you use Docker as if it were your native ROS 2 environment — no compose files, no setup overhead.

---

## 🚧 Status  
⚠️ **Under active development**

---

## ✨ Features

| Feature | Supported |
|---------|-----------|
| Run ROS 2 inside Docker like a normal shell | ✅ |
| Per-project automatic config (`.rosdock/`) | ✅ |
| Auto-mount current folder into container | ✅ |
| Optional NVIDIA / AMD GPU support | ✅ |
| Auto-install `yq` if missing | ✅ |
| No need for docker-compose | ✅ |
| Works in any folder / any project | ✅ |
| Automatic X11 / Wayland GUI forwarding | ✅ |

---

## 📦 Requirements

- Linux host with Docker installed  
- `yq` (auto-installed if missing)  
- Optional: NVIDIA or AMD GPU runtime for Docker  

---

---

## 🛠 Setup

To install rosdock, clone the repository and run the installation script:

```bash
git clone https://github.com/MartiElias/rosdock.git
cd rosdock
./install.sh
```
This will install rosdock system-wide, making it available from any directory.

---

## 🚀 Quick start
The workflow of rosdock focuses on bringing your current project folder into the Docker container automatically. The folder from which rosdock is executed will be mounted inside the container at the path defined in **work_folder** in the configuration file.

⚠️ Important: rosdock must be executed from the project directory (not using a relative path to another folder).

```bash
cd my_ros_project/
rosdock --image=ros:humble
```

On first run, rosdock creates:
```bash
.rosdock/
 ├─ bash_history
 ├─ config.yml
 ├─ entrypoint.sh
 └─ bash_setup.txt
```

Next runs reuse that config automatically.

🖥 GUI / Display support (X11 & Wayland)

rosdock can automatically enable GUI support for ROS applications
such as **rviz2**, **rqt**, **gazebo**, or custom Qt / GTK tools.
```bash
rosdock --display=1
```
Disable display is useful for SSH sessions.
```bash
rosdock --display=0
```

🖥 GPU support
```bash
rosdock --gpus=1
```
rosdock detects your system and applies the correct Docker flags:
GPU	Detection	Runtime Flags
NVIDIA	nvidia-smi	--gpus all + env
AMD (ROCm)	/dev/kfd or /dev/dri	--runtime=amd + devices + groups
📁 Per-project configuration

Each project keeps its own config — nothing is stored globally:
```bash
project_root/
 └─ .rosdock/
     ├─ bash_history
     ├─ config.yml
     ├─ entrypoint.sh
     └─ bash_setup.txt
```
✅ No $HOME pollution

✅ No global install needed

✅ Just delete the folder to reset config

🛠 Example config.yml
```bash
# Docker image to use
image_name: ubuntu

# Path inside the container where your host folder will be mounted
work_folder: /work_dir

# Name of the container
container_name: container_name

# GPU support (0 = disabled, 1 = enabled)
gpus: 0

# Display / GUI support (0 = disabled, 1 = enabled)
display: 1

# Environment variables
env:
  LANG: C.UTF-8
  RMW_IMPLEMENTATION: rmw_fastrtps_cpp

# Devices (audio by default)
device:
  - /dev/snd

# Groups (audio by default)
group_add:
  - audio
```

🧩 Adding workspace sourcing

Edit .rosdock/bash_setup.txt:
```bash
source /work/my_ws/install/setup.bash
```

🗑 Reset / remove config
```bash
rm -rf .rosdock
```
❓ Why not docker-compose?

- rosdock is single-command, no yaml needed

- Per-directory config instead of global config

- Auto-GPU detection

- No docker-compose up, no background containers

- Works anywhere — even inside another repo

📝 License

Apache-2.0

📌 Roadmap

Detect apt installs in the container and save them in the image

❤️ Contributing

This project is still evolving — PRs, issues, and ideas are welcome.
