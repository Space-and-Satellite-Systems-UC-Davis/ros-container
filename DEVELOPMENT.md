# Development Guide

This guide covers how to build, modify, and test the Docker images for this devcontainer template.

## Prerequisites

- Docker or a compatible container runtime
- A GitHub account with access to the [Space-and-Satellite-Systems-UC-Davis](https://github.com/Space-and-Satellite-Systems-UC-Davis) organization (for pushing images)
- A GitHub Personal Access Token (Classic) with `write:packages` scope

## Repository Structure

```
ros-container/
├── src/
│   └── ros-devcontainer/           # Template folder
│       ├── devcontainer-template.json
│       └── .devcontainer/
│           ├── devcontainer.json
│           ├── Dockerfile
│           ├── .env
│           └── scripts/
│               ├── xstartup
│               └── start-vnc.sh
├── .github/workflows/
│   ├── docker_build.yml            # Builds Docker images
│   └── publish_template.yml        # Publishes devcontainer template
├── README.md
├── DEVELOPMENT.md
└── LICENSE
```

## Building Locally

### Build the Docker Image

```bash
cd src/ros-devcontainer/.devcontainer

# Build with default ROS distro (Jazzy)
docker build -t ros-container:jazzy .

# Build with a specific ROS distro
docker build --build-arg ROS_DISTRO=humble -t ros-container:humble .
docker build --build-arg ROS_DISTRO=kilted -t ros-container:kilted .
```

### Test the Image

```bash
# Run interactively
docker run -it --rm \
  -p 6080:6080 \
  -p 5901:5901 \
  ros-container:jazzy

# Start VNC server inside the container
start-vnc.sh
```

Then open http://localhost:6080/vnc.html in your browser.

## Pushing Images to GHCR

### 1. Configure Credentials

Create a `.env` file (do not commit this):

```bash
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GITHUB_USERNAME=your-github-username
```

### 2. Authenticate with GHCR

```bash
source .env
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
```

### 3. Tag and Push

```bash
# Tag for GHCR
docker tag ros-container:jazzy ghcr.io/space-and-satellite-systems-uc-davis/ros-container:jazzy

# Push
docker push ghcr.io/space-and-satellite-systems-uc-davis/ros-container:jazzy
```

## GitHub Actions Workflows

### Automatic Builds

The `docker_build.yml` workflow automatically builds and pushes Docker images when:

- Changes are pushed to `main` or `dev` branches
- A pull request targets `main`

The LTS distribution (currently Jazzy) is built by default and tagged as `latest` and `lts`.

### Manual Builds

To build a non-LTS distribution:

1. Go to **Actions** > **Build and Push Docker Image**
2. Click **Run workflow**
3. Select the desired ROS distribution
4. Click **Run workflow**

### Template Publishing

The `publish_template.yml` workflow publishes the devcontainer template to GHCR after a successful Docker build on `main`. It can also be triggered manually.

## Multi-Architecture Builds

The GitHub Actions workflow builds images for both `linux/amd64` and `linux/arm64` architectures using native runners:

- `ubuntu-latest` for amd64
- `ubuntu-24.04-arm` for arm64

For local multi-arch builds, use Docker Buildx:

```bash
# Create a builder
docker buildx create --use

# Build multi-arch image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --build-arg ROS_DISTRO=jazzy \
  -t ghcr.io/space-and-satellite-systems-uc-davis/ros-container:jazzy \
  --push \
  src/ros-devcontainer/.devcontainer
```

## Testing the Template

### Local Template Testing

```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Test applying the template
mkdir test-project && cd test-project
devcontainer templates apply --template-id ../src/ros-devcontainer

# Build and run
devcontainer build --workspace-folder .
devcontainer up --workspace-folder .
```

### Testing Published Template

```bash
devcontainer templates apply \
  --template-id ghcr.io/space-and-satellite-systems-uc-davis/ros-devcontainer
```

## Troubleshooting

### "owner not found" Error

Ensure the organization name is lowercase: `space-and-satellite-systems-uc-davis`

### "unauthorized" or "denied" Error

1. Verify your token has `write:packages` scope
2. Ensure you're a member of the organization with package write permissions
3. Re-authenticate: `docker logout ghcr.io` then login again

### "name unknown" Error

The package may not exist yet. The first push creates it automatically with correct permissions.

### Build Cache Issues

Clear the Docker build cache:

```bash
docker builder prune
```
