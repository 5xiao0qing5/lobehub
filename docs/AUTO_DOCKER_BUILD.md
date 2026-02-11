# Auto Docker Build Configuration Guide

## 📋 Overview

This guide explains how to configure the automatic Docker image build workflow to automatically build and push Docker images with auto-incrementing version numbers to your Docker Hub on every code change.

## 🎯 Features

- ✅ **Auto Trigger**: Automatically builds on every push to `main` or `next` branches
- ✅ **Auto-Incrementing Versions**: Generates incrementing build numbers based on commit count
- ✅ **Multiple Version Tags**:
  - Main version tag: `v2.1.26-build.123`
  - Date+SHA tag: `20260211-abc1234`
  - Branch tag: `latest` (main branch) or `next`
- ✅ **Multi-Architecture Support**: Automatically builds `linux/amd64` and `linux/arm64` architectures
- ✅ **Manual Trigger**: Supports manual trigger with optional version suffix

## 📝 All GitHub Actions Workflows Overview

### 1. Testing & CI (5 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `test.yml` | Run all tests (packages, app, desktop, database) | Every push and pull request |
| `e2e.yml` | End-to-end testing (Playwright + PostgreSQL) | Every push and pull request |
| `claude-auto-testing.yml` | Auto-generate unit tests using Claude AI | Daily at 05:30 UTC or manual |
| `claude-auto-e2e-testing.yml` | Auto-generate E2E tests using Claude AI | Daily at 21:00 UTC or manual |
| `lighthouse.yml` | Performance audits (Lighthouse) | Daily or manual |

### 2. Desktop Build & Release (6 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `desktop-build-electron.yml` | Build desktop Next.js bundle | Push to `next` branch or PR changes to desktop paths |
| `pr-build-desktop.yml` | Build desktop for PR (all platforms) | PR update + `trigger:build-desktop` label |
| `manual-build-desktop.yml` | Manual desktop build with channel selection | Manual dispatch (nightly/beta/stable) |
| `release-desktop-beta.yml` | Build & release beta/nightly versions | Release published with pre-release suffix |
| `release-desktop-stable.yml` | Build & release stable versions + S3 upload | Release published (stable tag) or manual |
| `verify-desktop-patch.yml` | Smoke test desktop patch changes | Push/PR to specific paths |

### 3. Web/Docker Release (4 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `release.yml` | Publish web app: lint, test, release to npm | Push git tag `v*.*.*` |
| `pr-build-docker.yml` | Build Docker image for PR | PR update + `trigger:build-docker` label |
| `release-docker.yml` | Build & push multi-arch Docker images | Release published or manual |
| `**auto-docker-build.yml**` | **🆕 Auto-build Docker images with incrementing versions** | **Push to main/next branches or manual** |
| `revalidate-docs.yml` | Revalidate docs site cache | Push to `docs/**` (main/next branches) |

### 4. Versioning & Automation (4 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `auto-tag-release.yml` | Create git tags from merged PRs | PR merged to main with `🚀 release: v*` title |
| `auto-i18n.yml` | Generate i18n translations | Daily at 00:00 UTC or manual |
| `sync-database-schema.yml` | Sync database schema visualization | Push `database-schema.dbml` |
| `sync-main-to-dev.yaml` | Sync main → dev branch | Push to main |

### 5. Claude AI Automation (6 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `claude.yml` | Claude code analysis (mention @claude) | Issue/PR comment with `@claude` |
| `claude-translator.yml` | Auto-translate issues/PRs to English | Issue opened, comments, reviews |
| `claude-translate-comments.yml` | Translate non-English code comments | Daily at 02:00 UTC or manual |
| `claude-issue-triage.yml` | Auto-triage issues with labels | Issue opened or `trigger:triage` label |
| `claude-dedupe-issues.yml` | Detect duplicate issues | Issue opened or manual |
| `claude-migration-support.yml` | Migration support for specific issues | Comment on migration issues (#11757, #11707) |

### 6. Issue Management (4 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `issue-auto-comments.yml` | Auto-comment when issues/PRs open/close/merge | Issue/PR opened, closed |
| `issue-auto-close-duplicates.yml` | Auto-close duplicate issues | Daily at 02:00 UTC or manual |
| `issue-close-require.yml` | Auto-close inactive issues with specific labels | Daily at 00:00 UTC |
| `lock-closed-issues.yml` | Lock closed issues after inactivity | Daily at 01:00 UTC |

### 7. Utilities & Monitoring (2 workflows)

| Workflow File | Purpose | Trigger |
|--------------|---------|---------|
| `sync.yml` | Sync upstream fork changes | Every 6 hours or manual |
| `bundle-analyzer.yml` | Analyze bundle size | Manual dispatch |

### Scheduled Jobs Summary

| Time (UTC) | Workflow | Description |
|-----------|----------|-------------|
| 00:00 | `auto-i18n.yml` | Generate translations |
| 00:00 | `issue-close-require.yml` | Close inactive issues |
| 01:00 | `lock-closed-issues.yml` | Lock closed issues |
| 02:00 | `claude-translate-comments.yml` | Translate code comments |
| 02:00 | `issue-auto-close-duplicates.yml` | Close duplicate issues |
| 05:30 | `claude-auto-testing.yml` | Generate unit tests |
| Every 6h | `sync.yml` | Sync fork |
| 21:00 | `claude-auto-e2e-testing.yml` | Generate E2E tests |

## 🚀 Configuration Steps

### Step 1: Fork the Repository

1. Visit the original repository: https://github.com/lobehub/lobe-chat
2. Click the **Fork** button in the top right to fork it to your account

### Step 2: Configure Docker Hub

1. **Create a Docker Hub repository** (if you don't have one):
   - Visit https://hub.docker.com
   - Click **Create Repository**
   - Enter repository name (e.g., `lobehub`)
   - Choose **Public** or **Private**

2. **Get Docker Hub access token**:
   - Visit https://hub.docker.com/settings/security
   - Click **New Access Token**
   - Enter token name (e.g., `github-actions`)
   - Select **Read, Write, Delete** permissions
   - Copy the generated token (shown only once!)

### Step 3: Configure GitHub Secrets

1. Go to your forked repository settings:
   - Click **Settings** → **Secrets and variables** → **Actions**

2. Add the following Secrets (click **New repository secret**):

| Secret Name | Description | Example Value |
|------------|-------------|---------------|
| `DOCKER_REGISTRY_USER` | Docker Hub username | `yourusername` |
| `DOCKER_REGISTRY_PASSWORD` | Docker Hub access token | `dckr_pat_xxxxx...` |

### Step 4: Modify Workflow Configuration

Edit the `.github/workflows/auto-docker-build.yml` file and modify line 31 with your image name:

```yaml
env:
  # Change to your Docker Hub username and repository name
  REGISTRY_IMAGE: yourusername/lobehub
```

**Important**: Replace `yourusername/lobehub` with your actual Docker Hub username and repository name.

### Step 5: Commit Changes

```bash
git add .github/workflows/auto-docker-build.yml
git commit -m "🐳 Configure automatic Docker build"
git push origin main
```

## 📦 Version Number Explanation

### Auto-Generated Version Tags

Each build automatically generates the following tags:

1. **Main Version Tag** (based on package.json + build number):
   - Format: `v{version}-build.{build_number}`
   - Example: `2.1.26-build.1234`
   - Note: Build number is the total git commit count, increments with each commit

2. **Date+SHA Tag**:
   - Format: `{date}-{short_sha}`
   - Example: `20260211-abc1234`
   - Note: Uses UTC date and 7-character commit SHA

3. **Branch Tag**:
   - `latest`: Only for main branch builds
   - `next`: For next branch builds

### Version Number Increment Rules

- **Build Number Increment**: After each commit, the value of `git rev-list --count HEAD` automatically increases
- **Base Version**: Read from the `version` field in `package.json`
- **Full Version Example**: If package.json version is `2.1.26`, after the 1234th commit it generates `2.1.26-build.1234`

### Manual Version Suffix

You can also manually trigger builds with a custom version suffix:

1. Go to **Actions** in your GitHub repository
2. Select **Auto Build Docker Image**
3. Click **Run workflow**
4. Enter a suffix in **Version suffix** (e.g., `beta`, `alpha`)
5. Click **Run workflow**

This will generate a version tag like `2.1.26-beta.1234`.

## 🎯 Usage Examples

### Pull Images

```bash
# Pull latest version (main branch)
docker pull yourusername/lobehub:latest

# Pull specific build version
docker pull yourusername/lobehub:2.1.26-build.1234

# Pull specific date build
docker pull yourusername/lobehub:20260211-abc1234

# Pull latest next branch build
docker pull yourusername/lobehub:next
```

### Run Container

```bash
docker run -d \
  --name lobehub \
  -p 3210:3210 \
  -e DATABASE_URL="your-database-url" \
  -e AUTH_SECRET="your-auth-secret" \
  -e KEY_VAULTS_SECRET="your-key-vaults-secret" \
  yourusername/lobehub:latest
```

## 🔍 Monitor Build Status

### View Build Logs

1. Go to your GitHub repository
2. Click the **Actions** tab
3. Select **Auto Build Docker Image** workflow
4. View recent run records

### Build Summary

After each successful build, the **Summary** page displays:
- 🐳 Image information (repository, version tags)
- 📝 Pull commands
- 🔗 Docker Hub link

### Docker Hub Check

Visit `https://hub.docker.com/r/yourusername/lobehub/tags` to view all published tags.

## 🛠 Common Issues

### Q1: Build fails with permission error pushing to Docker Hub

**A**: Please ensure:
1. `DOCKER_REGISTRY_USER` and `DOCKER_REGISTRY_PASSWORD` secrets are correctly configured
2. Docker Hub access token has **Read, Write** permissions
3. `REGISTRY_IMAGE` in `.github/workflows/auto-docker-build.yml` is changed to your repository

### Q2: How to disable auto-build for certain branches?

**A**: Edit `.github/workflows/auto-docker-build.yml`, modify `on.push.branches`:

```yaml
on:
  push:
    branches:
      - main  # Keep only main branch
      # - next  # Comment out unwanted branches
```

### Q3: How to modify version number format?

**A**: Edit the `Generate version tag` step in the workflow file, modify the `VERSION_TAG` generation logic.

For example, use date as the main version number:

```bash
VERSION_TAG="${BUILD_DATE}.${BUILD_NUMBER}"
```

### Q4: ARM64 architecture build fails

**A**: ARM64 builds require GitHub-hosted ARM runner (`ubuntu-24.04-arm`). If your account doesn't have access, you can:

1. Build only AMD64 architecture:

```yaml
strategy:
  matrix:
    include:
      - platform: linux/amd64
        os: ubuntu-latest
```

2. Or use QEMU emulation (slower):

```yaml
- name: Set up QEMU
  uses: docker/setup-qemu-action@v3
```

### Q5: How to pass custom parameters during build?

**A**: Modify the Dockerfile to add `ARG` directives, then add `build-args` in the workflow:

```yaml
build-args: |
  SHA=${{ steps.version.outputs.short_sha }}
  CUSTOM_ARG=value
```

## 📚 Related Resources

- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Push Action](https://github.com/docker/build-push-action)
- [LobeChat Official Documentation](https://lobehub.com/docs)

## 🤝 Contributing

If you find any issues or have improvement suggestions, feel free to:
- Submit an Issue
- Create a Pull Request
- Participate in discussions

## 📄 License

This project follows the MIT License. See [LICENSE](../LICENSE) file for details.
