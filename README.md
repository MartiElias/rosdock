# 🐋 rosdock  
**Portable ROS 2 development made simple**  
`rosdock` lets you use Docker as if it were your native ROS 2 environment — no Dockerfiles, no compose files, no setup overhead.

---

## 🚧 Status  
⚠️ **Under active development** — APIs may change.

---

## ✨ Features

| Feature | Supported |
|---------|-----------|
| Run ROS 2 inside Docker like a normal shell | ✅ |
| Per-project automatic config (`.config/rosdock/`) | ✅ |
| Auto-mount current folder into container | ✅ |
| Optional NVIDIA / AMD GPU support | ✅ |
| Auto-install `yq` if missing | ✅ |
| No need for docker-compose | ✅ |
| Works in any folder / any project | ✅ |

---

## 📦 Requirements

- Linux host with Docker installed  
- `yq` (auto-installed if missing)  
- Optional: NVIDIA or AMD GPU runtime for Docker  

---

## 🚀 Quick start

```bash
cd my_ros_project/
rosdock --image=ros:humble
```

On first run, rosdock creates:
```bash
.config/rosdock/
 ├─ config.yml
 ├─ entrypoint.sh
 └─ bash_setup.txt
```

Next runs reuse that config automatically.
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
 └─ .config/rosdock/
     ├─ config.yml
     ├─ entrypoint.sh
     └─ bash_setup.txt
```
✅ No $HOME pollution

✅ No global install needed

✅ Just delete the folder to reset config

🛠 Example config.yml
```bash
image_name: ubuntu
init_root: /work_dir
container_name: container_name
gpus: 0
env:
  LANG: C.UTF-8
  RMW_IMPLEMENTATION: rmw_fastrtps_cpp
device:
  - /dev/snd
group_add:
  - audio
entrypoint_path: "./.config/rosdock/entrypoint.sh"
```

🧩 Adding workspace sourcing

Edit .config/rosdock/bash_setup.txt:
```bash
source /work/my_ws/install/setup.bash
```

🗑 Reset / remove config
```bash
rm -rf .config/rosdock
```
❓ Why not docker-compose?

- rosdock is single-command, no yaml needed

- Per-directory config instead of global config

- Auto-GPU detection

- No docker-compose up, no background containers

- Works anywhere — even inside another repo

📝 License

To be decided (MIT or Apache-2.0 recommended)

📌 Roadmap

Detect apt installs in the container and save them in the image

❤️ Contributing

This project is still evolving — PRs, issues, and ideas are welcome.