# Example Configuration for Auto Docker Build

## Required GitHub Secrets

Add these secrets in your GitHub repository settings:
Settings → Secrets and variables → Actions → New repository secret

```
DOCKER_REGISTRY_USER=your-dockerhub-username
DOCKER_REGISTRY_PASSWORD=dckr_pat_your-access-token-here
```

## Workflow File Modification

Edit `.github/workflows/auto-docker-build.yml`, line 31:

```yaml
env:
  # Change this to your Docker Hub username and repository name
  REGISTRY_IMAGE: your-dockerhub-username/your-repo-name
```

## Example Values

If your Docker Hub username is `johndoe` and you want to name the repository `lobehub`:

```yaml
env:
  REGISTRY_IMAGE: johndoe/lobehub
```

And your secrets should be:
```
DOCKER_REGISTRY_USER=johndoe
DOCKER_REGISTRY_PASSWORD=dckr_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Testing

1. Make a commit and push to `main` or `next` branch
2. Check the Actions tab in your GitHub repository
3. Verify the workflow runs successfully
4. Check your Docker Hub for the new image tags

## Expected Image Tags

After build, you'll have these tags:
- `your-username/lobehub:2.1.26-build.123` (version + build number)
- `your-username/lobehub:20260211-abc1234` (date + SHA)
- `your-username/lobehub:latest` (only for main branch)
- `your-username/lobehub:next` (only for next branch)
