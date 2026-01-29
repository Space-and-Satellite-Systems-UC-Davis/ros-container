# ROS 2 + Nav2 Devcontainer Template

A [devcontainer template](https://containers.dev/implementors/templates/) for ROS 2 development with Nav2 navigation stack, Gazebo simulation, and VNC desktop access.

## Features

- ROS 2 with Nav2 navigation stack pre-installed
- Gazebo simulator (version matched to ROS distro)
- VNC desktop access via noVNC (browser-based)
- Multi-architecture support (amd64/arm64)
- VS Code extensions for ROS development

## Quick Start

### VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`)
3. Select **Dev Containers: Add Dev Container Configuration Files...**
4. Select **Show All Definitions...**
5. Search for `ros-devcontainer` or browse community templates
6. Choose your ROS distribution when prompted

### CLI

Using the [devcontainer CLI](https://github.com/devcontainers/cli):

```bash
# Apply the template to your project
devcontainer templates apply \
  --template-id ghcr.io/space-and-satellite-systems-uc-davis/ros-devcontainer

# Or specify a ROS distribution
devcontainer templates apply \
  --template-id ghcr.io/space-and-satellite-systems-uc-davis/ros-devcontainer \
  --template-args '{"rosDistro": "humble"}'
```

## Configuration Options

| Option | Description | Default | Choices |
|--------|-------------|---------|---------|
| `rosDistro` | ROS 2 distribution to use | `jazzy` | `humble`, `jazzy`, `kilted` |

### Gazebo Versions

Each ROS distribution is paired with a specific Gazebo version:

| ROS Distro | Gazebo Version |
|------------|----------------|
| Humble | Fortress |
| Jazzy | Harmonic |
| Kilted | Ionic |

## Using the Container

### VNC Desktop Access

The container includes a VNC server with noVNC for browser-based desktop access:

1. Start the devcontainer
2. Open http://localhost:6080/vnc.html in your browser
3. No password is required by default

The VNC server runs on port 5901, and noVNC is available on port 6080.

### ROS 2 Development

The container sources `/opt/ros/<distro>/setup.bash` automatically. Your workspace is mounted at `/workspace`.

```bash
# Build your packages
cd /workspace
colcon build

# Source your workspace
source install/setup.bash
```

## Pre-built Docker Images

Pre-built images are available for direct use:

```bash
# Latest LTS (Jazzy)
docker pull ghcr.io/space-and-satellite-systems-uc-davis/ros-container:latest

# Specific distribution
docker pull ghcr.io/space-and-satellite-systems-uc-davis/ros-container:jazzy
docker pull ghcr.io/space-and-satellite-systems-uc-davis/ros-container:humble
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for instructions on building and modifying the Docker images.

## License

[MIT](LICENSE)
