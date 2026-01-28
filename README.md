# Pushing Docker Images to GitHub Container Registry (GHCR)

This guide documents the process to authenticate and push Docker images to the Space and Satellite Systems UC Davis GitHub Container Registry.

## Prerequisites

- Docker installed and running
- A GitHub account with access to the [Space-and-Satellite-Systems-UC-Davis](https://github.com/Space-and-Satellite-Systems-UC-Davis) organization
- A GitHub Personal Access Token (Classic) with appropriate permissions

## 1. Create a GitHub Personal Access Token (Classic)

1. Go to [GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)](https://github.com/settings/tokens)
2. Click **Generate new token** > **Generate new token (classic)**
3. Give it a descriptive name (e.g., `ghcr-push-token`)
4. Select the following scopes:
   - `write:packages` - Upload packages to GitHub Package Registry
   - `read:packages` - Download packages from GitHub Package Registry
   - `delete:packages` (optional) - Delete packages from GitHub Package Registry
5. Click **Generate token**
6. **Copy the token immediately** - you won't be able to see it again

## 2. Store the Token in `.env`

Create or update your `.env` file in the `.devcontainer` directory:

```bash
# .devcontainer/.env
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GITHUB_USERNAME=your-github-username
```

> **Important:** Never commit `.env` files containing secrets to version control.

## 3. Authenticate with GHCR

Use the token stored in your `.env` file to authenticate with GitHub Container Registry:

```bash
# Load environment variables
source .env

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
```

You should see: `Login Succeeded`

## 4. Build and Tag the Image

Build your Docker image and tag it for GHCR:

```bash
# Build the image
docker build -t ros_container:latest .

# Tag for GHCR (organization name must be lowercase)
docker tag ros_container:latest ghcr.io/space-and-satellite-systems-uc-davis/ros_container:latest
```

### Tagging with Version Numbers

For versioned releases:

```bash
docker tag ros_container:latest ghcr.io/space-and-satellite-systems-uc-davis/ros_container:v1.0.0
```

## 5. Push the Image

```bash
docker push ghcr.io/space-and-satellite-systems-uc-davis/ros_container:latest
```

To push all tags:

```bash
docker push ghcr.io/space-and-satellite-systems-uc-davis/ros_container --all-tags
```

## 6. Verify the Push

After pushing, verify your image is available at:
https://github.com/orgs/Space-and-Satellite-Systems-UC-Davis/packages/container/package/ros_container

## Quick Reference Script

Create a script `push-to-ghcr.sh` for convenience:

```bash
#!/bin/bash
set -e

# Load credentials
source .env

# Configuration
IMAGE_NAME="ros_container"
REGISTRY="ghcr.io/space-and-satellite-systems-uc-davis"

# Login
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

# Tag and push
docker tag ${IMAGE_NAME}:latest ${REGISTRY}/${IMAGE_NAME}:latest
docker push ${REGISTRY}/${IMAGE_NAME}:latest

echo "Successfully pushed ${REGISTRY}/${IMAGE_NAME}:latest"
```

## Troubleshooting

### "owner not found" Error

This usually means a typo in the organization name. Ensure you use:
- `space-and-satellite-systems-uc-davis` (all lowercase, correct spelling)

### "unauthorized" or "denied" Error

1. Verify your token has `write:packages` scope
2. Ensure you're a member of the organization with package write permissions
3. Re-authenticate: `docker logout ghcr.io` then login again

### "name unknown" Error

The package may not exist yet. The first push creates it automatically if you have the correct permissions.
