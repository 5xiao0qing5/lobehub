# 工作流管理 - 快速参考

## 🚀 最快的方法

### 方法 1: 使用管理脚本（推荐）⭐

```bash
# 1. 给脚本添加执行权限
chmod +x scripts/manage-workflows.sh

# 2. 列出所有工作流
./scripts/manage-workflows.sh list

# 3. 只保留 auto-docker-build.yml，禁用其他所有
./scripts/manage-workflows.sh disable-all-except auto-docker-build.yml

# 4. 如果需要恢复
./scripts/manage-workflows.sh enable-all
```

### 方法 2: 使用 GitHub Web UI

1. 访问仓库 → **Actions** 标签
2. 点击左侧要禁用的工作流
3. 点击右上角 **⋯** → **Disable workflow**

## 📋 常用命令

### 禁用特定类别

```bash
# 禁用所有 Claude AI 工作流（6个）
./scripts/manage-workflows.sh disable-category claude

# 禁用所有 Issue 管理工作流（4个）
./scripts/manage-workflows.sh disable-category issue

# 禁用所有桌面应用工作流
./scripts/manage-workflows.sh disable-category desktop

# 禁用所有测试工作流
./scripts/manage-workflows.sh disable-category test
```

### 禁用单个工作流

```bash
./scripts/manage-workflows.sh disable test.yml
./scripts/manage-workflows.sh disable e2e.yml
./scripts/manage-workflows.sh disable lighthouse.yml
```

### 启用工作流

```bash
# 启用单个
./scripts/manage-workflows.sh enable test.yml.disabled

# 启用所有
./scripts/manage-workflows.sh enable-all
```

## 🎯 推荐配置

### 配置 1: 仅 Docker 构建（最小化）

```bash
# 只保留 Docker 构建工作流
./scripts/manage-workflows.sh disable-all-except auto-docker-build.yml
```

### 配置 2: Docker + 基础测试

```bash
# 保留 Docker 构建和测试
./scripts/manage-workflows.sh disable-all-except \
    auto-docker-build.yml \
    test.yml
```

### 配置 3: 禁用资源密集型工作流

```bash
# 禁用测试和 Claude AI
./scripts/manage-workflows.sh disable-category test
./scripts/manage-workflows.sh disable-category claude
```

## 📊 工作流分类

| 类别 | 数量 | 说明 |
|-----|------|------|
| `claude-*.yml` | 6 个 | Claude AI 自动化 |
| `issue-*.yml` | 4 个 | Issue 管理 |
| `*desktop*.yml` | 6 个 | 桌面应用构建 |
| `test*.yml`, `e2e.yml` | 3 个 | 测试工作流 |

## ⚡ 一键命令

```bash
# 只保留 Docker 构建
./scripts/manage-workflows.sh disable-all-except auto-docker-build.yml

# 禁用所有 AI 和 Issue 管理
./scripts/manage-workflows.sh disable-category claude
./scripts/manage-workflows.sh disable-category issue

# 查看结果
./scripts/manage-workflows.sh list
```

## 🔄 恢复默认

```bash
# 启用所有工作流
./scripts/manage-workflows.sh enable-all

# 确认
./scripts/manage-workflows.sh list
```

## 💡 提示

1. **测试前备份**: 
   ```bash
   git checkout -b backup-workflows
   git push origin backup-workflows
   ```

2. **查看禁用效果**: 访问 GitHub Actions 页面查看

3. **节省资源**: 禁用定时任务可以大幅节省 Actions minutes

4. **渐进式禁用**: 先禁用一部分，观察几天，再决定是否继续

## 📚 详细文档

查看完整文档：`docs/WORKFLOW_MANAGEMENT_CN.md`
