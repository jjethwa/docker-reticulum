# docker-reticulum workflow

Configure environment variables to automatically push container images!

You must configure a Docker user and password to access the hardened Python image.

## Configuring to push images to the GitHub Container Registry

1. Go to `Settings` -> `Secrets and variables` -> `Actions`
2. Choose the `Variables` tab
3. Add the following repository variables:
  - Name: `CR_HOST` Value: `ghcr.io`
  - Name: `CR_IMAGE` Value: name of the GitHub repository, `docker-reticulum` if you forked the main repo
  - Name: `CR_USER` Value: your GitHub username 

## Configuring to push images to Gitea

1. Go to `Settings` -> `Actions` -> `Variables`
2. Add the following variables:
  - Name: `CR_HOST` Value: hostname of the Gitea instance
  - Name: `CR_IMAGE` Value: the name of the Gitea repository
  - Name: `CR_USER` Value: your Gitea username
3. Choose `Applications` on the left to generate a personal access token
  - Name it something memorable
  - Set `package` permissions to `Read and write`
  - Generate the token
3. Choose `Secrets` on the left and add the following secret:
  - Name: `CR_PASSWORD` Value: the token you generated above

## Nomenclature

- Variables

  - `CR_HOST` - repository host: ghcr.io for GitHub Container Registry or a Gitea or Forgejo hostname
  - `CR_IMAGE` - the name of the image, defaults to `reticulum`
  - `CR_REPOSITORY` - container repository, defaults to `CR_USER`
  - `CR_USER` - user to authenticate to the container registry as
  - `DOCKER_IMAGE` - the name of the image, defaults to `reticulum`
  - `DOCKER_REPOSITORY` - container repository, defaults to `DOCKER_USER`
  - `DOCKER_USER` - user to authenticate to the Docker Hub as

- Secrets

  - `CR_PASSWORD` - PAT for container registry, if not specified, the `GITHUB_TOKEN` secret will be used
  - `DOCKER_PASSWORD` - PAT for Docker Hub

