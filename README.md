# 🐋 rosdock
**Simple Docker environments, built with ROS 2 development in mind**

`rosdock` makes it easy to work inside Docker containers, with any Docker image.
It is designed to simplify ROS 2 development, but does not require ROS 2.

The tool is a single Bash script, kept simple so it is easy to understand,
modify, and adapt to your workflow — no compose files required.

---

## ✨ Features

| Feature | Supported |
|---------|-----------|
| Run ROS 2 inside Docker like a normal shell | ✅ |
| Per-project automatic config (`.rosdock/`) | ✅ |
| Auto-mount current folder into container | ✅ |
| Optional NVIDIA / AMD GPU support | ✅ |
| Optional container removal (`--rm=0` / `--rm=1`) | ✅ |
| Optional NVIDIA render offload for hybrid graphics | ✅ |
| Installation script installs `yq` if missing | ✅ |
| No need for docker-compose | ✅ |
| Works in any folder / any project | ✅ |
| X11 GUI forwarding (including XWayland) | ✅ |

---

## 📦 Requirements

- Linux host with Docker installed  
- `yq` (auto-installed if missing)  
- Optional: NVIDIA or AMD GPU runtime for Docker  

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

⚠️ Important: run rosdock from your project directory so it can find `.rosdock/`. Calling the script through a relative path does not change where it looks for configuration.

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

| File | Purpose |
|------|---------|
| `bash_history` | Stores Bash command history so it is preserved across container sessions. |
| `config.yml` | Stores the project's default container settings. Command-line options override these settings. |
| `entrypoint.sh` | Internal startup script that configures history and adds the contents of `bash_setup.txt` to the container's `.bashrc`. |
| `bash_setup.txt` | Custom shell setup commands, such as sourcing a ROS workspace. Its contents are copied into `.bashrc` and run when an interactive Bash terminal opens. |

Next runs reuse that config automatically.

Existing files in `.rosdock/` are preserved when updating rosdock. The history
fix applies to newly generated entrypoints. In an existing `entrypoint.sh`, use
`export HISTFILE="/rosdock/bash_history"` and `trap 'history -a' EXIT` in the
generated Bash setup to share history across new containers.

### 🐋 Container removal

rosdock is designed around disposable containers: start a fresh container for
each session and remove it when its main process exits. This is the default
behavior (`--rm=1`).

Your mounted project files, `.rosdock/` configuration, and Bash history are
preserved independently of the container.

If you need to keep a container and changes made inside it, you can disable
automatic removal:

```bash
rosdock --rm=0
```

The container stops when its main process exits; this option does not keep it
running in the background. On the next run with the same container name,
rosdock starts the existing container and connects to it.

To enable automatic removal when creating a new container:

```bash
rosdock --rm=1
```

This setting applies only when creating a container; it does not change the
removal policy of an existing one.

### 🖥 GUI / Display support (X11 / XWayland)

rosdock can automatically enable GUI support for ROS applications
such as **rviz2**, **rqt**, **gazebo**, or custom Qt / GTK tools.
This uses the X11 socket and the host's `DISPLAY`; native Wayland forwarding is
not configured.

```bash
rosdock --display=1
```

Display forwarding is skipped automatically if `DISPLAY` is unset.
You can also disable it explicitly:

```bash
rosdock --display=0
```

### 🖥 GPU support
```bash
rosdock --gpus=1
```
rosdock detects your system and applies the correct Docker flags:

| GPU | Detection | Docker flags |
|-----|-----------|--------------|
| NVIDIA | `nvidia-smi` | `--gpus all` + NVIDIA environment variables |
| AMD (ROCm) | `/dev/kfd` or `/dev/dri`, with an `amd` runtime registered | Device mounts + `seccomp=unconfined` |

On systems with integrated graphics and a dedicated NVIDIA GPU, applications
may still render with integrated graphics even when NVIDIA is available inside
the container. To request NVIDIA rendering, uncomment
`__NV_PRIME_RENDER_OFFLOAD` and `__GLX_VENDOR_LIBRARY_NAME` under `env` in
`.rosdock/config.yml`, as shown in the example below.

Remember to also enable GPU access with `--gpus=1` or `gpus: 1` at the top level
of the configuration, outside `env`. The render-offload variables do not enable
GPU access by themselves. Restart with a newly created container to apply the
new environment variables; connecting to an existing container does not update
its environment.

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

✅ Configuration stays in the project folder

✅ Just delete the folder to reset config

🛠 Example config.yml
```yaml
# Docker image to use
image_name: ubuntu

# Path inside the container where your host folder will be mounted
work_folder: /work

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

  # On systems with integrated graphics and a dedicated NVIDIA GPU,
  # we recommend uncommenting these variables so applications render with NVIDIA.
  # Otherwise, NVIDIA may be detected but applications may still use integrated graphics.
  # Also enable GPU access with gpus: 1 (outside env) or --gpus=1.
  # __NV_PRIME_RENDER_OFFLOAD: "1"
  # __GLX_VENDOR_LIBRARY_NAME: nvidia

# Optional audio devices (auto-enabled only if /dev/snd exists on the host)
device:
  - /dev/snd

# Optional audio group
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
❓ Why rosdock?

- Start an interactive Docker environment with a single command.
- Keep configuration and shell setup alongside your project.
- Enable GPU and display support with simple flags.
- Use a single Bash script that is easy to inspect and modify.
- Work with any Docker image, with ROS 2 development in mind.

For multi-container applications and service orchestration, Docker Compose
may be a better fit.

📝 License

Apache-2.0

📌 Roadmap

Detect apt installs in the container and save them in the image

❤️ Contributing

This project is still evolving — PRs, issues, and ideas are welcome.
