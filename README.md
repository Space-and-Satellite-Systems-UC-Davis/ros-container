# Pushing Docker Images to GitHub Container Registry (GHCR)

This guide documents the process to authenticate and push Docker images to the Space and Satellite Systems UC Davis GitHub Container Registry.

Note that whenever changes are made to the repo, the image is automatically rebuild by github action. A non-LTS distro image can also be build manually via manually trigging the github action workflow.

## Prerequisites

- Docker/Compatible runtime installed and running
- A GitHub account with access to the [Space-and-Satellite-Systems-UC-Davis](https://github.com/Space-and-Satellite-Systems-UC-Davis) organization
- A GitHub Personal Access Token (Classic) with appropriate permissions. If you don't have one, Follow this [link](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) to get one.

## 1. Store the Token in `.env`

Create or update your `.env` file in the `.devcontainer` directory:

```bash
# .devcontainer/.env
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GITHUB_USERNAME=your-github-username
```

> **Important:** Never commit `.env` files containing secrets to version control.

## 2. Authenticate with GHCR

Use the token stored in your `.env` file to authenticate with GitHub Container Registry:

```bash
# Load environment variables
source .env

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin
```

You should see: `Login Succeeded`

## 3. Build and Tag the Image

Build your Docker image and tag it for GHCR:

```bash
# Build the image
docker build -t ros_container:latest .

# Tag for GHCR (organization name must be lowercase)
docker tag ros_container:latest ghcr.io/space-and-satellite-systems-uc-davis/ros_container:latest
```

### Tagging the image

The image are tagged with the name of the distro, and also the latest and lts tag for the lts images. Below is how you would tag a image, where the string of number is the image id found though `docker image list`. 

For more details see the [workflow file](.github/workflows/docker_build.yml) and also below contains a example script to run the entire process.

```bash
docker tag 0e850d2e62eb ghcr.io/space-and-satellite-systems-uc-davis/ros_container:latest
```

## 4. Push the Image

```bash
docker push ghcr.io/space-and-satellite-systems-uc-davis/ros_container:latest
```

To push all tags:

```bash
docker push ghcr.io/space-and-satellite-systems-uc-davis/ros_container --all-tags
```

## 5. Verify the Push

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
