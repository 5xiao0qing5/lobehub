#!/usr/bin/env bash

# GitHub Actions 工作流管理脚本 (工业增强版)
# 核心策略：
# 不修改文件名，而是写入“仅手动触发”的空壳 workflow，
# 避免 Git merge 时的 rename/delete 冲突。

set -euo pipefail

############################################
# 路径
############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKFLOWS_DIR="$REPO_ROOT/.github/workflows"

############################################
# Flags
############################################

FORCE=false
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --yes) FORCE=true ;;
        --dry-run) DRY_RUN=true ;;
    esac
done

############################################
# 颜色
############################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

############################################
# 工具函数
############################################

increment() {
    COUNT=$((COUNT + 1))
}

check_workflows_dir() {
    if [ ! -d "$WORKFLOWS_DIR" ]; then
        print_error "工作流目录不存在: $WORKFLOWS_DIR"
        exit 1
    fi
}

confirm_action() {
    if [ "$FORCE" = true ]; then
        return
    fi

    echo ""
    print_warning "此操作将修改工作流文件内容。"

    if [ "$DRY_RUN" = true ]; then
        print_info "当前为 dry-run，仅预览，不会修改文件。"
        return
    fi

    read -r -p "⚠ 确认继续吗？(yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        print_warning "操作已取消"
        exit 0
    fi
}

############################################
# 获取 workflow 文件（极稳版本）
############################################

get_workflow_files() {
    mapfile -t FILES < <(
        find "$WORKFLOWS_DIR" \
            -maxdepth 1 \
            -type f \
            \( -name "*.yml" -o -name "*.yaml" \) \
            -print
    )
}

############################################
# 判断是否禁用
############################################

is_disabled() {
    local file=$1
    grep -q "name: Disabled Workflow" "$file" 2>/dev/null
}

############################################
# 写入 disabled workflow
############################################

write_disabled_workflow() {
    local workflow=$1

    if [ "$DRY_RUN" = true ]; then
        print_info "[dry-run] 将屏蔽: $(basename "$workflow")"
        return
    fi

    cat > "$workflow" <<EOF
name: Disabled Workflow ($(basename "$workflow"))
on:
  workflow_dispatch:

jobs:
  disabled:
    runs-on: ubuntu-latest
    steps:
      - run: echo "This workflow is disabled on this branch."
EOF
}

############################################
# 核心操作
############################################

disable_workflow() {
    local workflow=$1

    if [ ! -f "$workflow" ]; then
        print_error "文件不存在: $workflow"
        return
    fi

    if is_disabled "$workflow"; then
        print_info "跳过: $(basename "$workflow") 已被屏蔽"
        return
    fi

    write_disabled_workflow "$workflow"
    print_success "已屏蔽: $(basename "$workflow")"
}

enable_workflow() {
    local workflow=$1

    if [ ! -f "$workflow" ]; then
        print_error "文件不存在: $workflow"
        return
    fi

    if ! is_disabled "$workflow"; then
        print_info "跳过: $(basename "$workflow") 看起来未被屏蔽"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[dry-run] 将恢复: $(basename "$workflow")"
        return
    fi

    git checkout HEAD -- "$workflow"
    print_success "已恢复: $(basename "$workflow")"
}

############################################
# 列表
############################################

list_workflows() {

    get_workflow_files

    echo ""
    echo "══════════════════════════════════════"
    echo "            📋 工作流列表"
    echo "══════════════════════════════════════"
    echo ""

    if [ ${#FILES[@]} -eq 0 ]; then
        print_info "没有找到 workflow 文件"
        return
    fi

    local enabled=0
    local disabled=0

    for file in "${FILES[@]}"; do
        if is_disabled "$file"; then
            echo -e "  ${RED}✗ $(basename "$file") (已屏蔽)${NC}"
            disabled=$((disabled + 1))
        else
            echo -e "  ${GREEN}✓ $(basename "$file") (启用中)${NC}"
            enabled=$((enabled + 1))
        fi
    done

    echo ""
    print_info "统计: 启用 $enabled / 已屏蔽 $disabled"
}

############################################
# 批量操作
############################################

disable_all() {

    get_workflow_files
    confirm_action

    COUNT=0

    for file in "${FILES[@]}"; do
        disable_workflow "$file"
        increment
    done

    echo ""
    print_success "操作完成，共处理 $COUNT 个文件"
}

enable_all() {

    get_workflow_files

    COUNT=0

    for file in "${FILES[@]}"; do
        if is_disabled "$file"; then
            enable_workflow "$file"
            increment
        fi
    done

    if [ "$COUNT" -eq 0 ]; then
        print_info "没有发现被屏蔽的文件"
    else
        print_success "已恢复 $COUNT 个文件"
    fi
}

disable_all_except() {

    shift
    local keep_list=("$@")

    get_workflow_files
    confirm_action

    COUNT=0

    for file in "${FILES[@]}"; do

        local base
        base=$(basename "$file")

        local keep=false
        for k in "${keep_list[@]}"; do
            if [[ "$base" == "$k" ]]; then
                keep=true
                break
            fi
        done

        if [ "$keep" = true ]; then
            print_info "保留: $base"
            is_disabled "$file" && enable_workflow "$file"
        else
            disable_workflow "$file"
            increment
        fi
    done

    print_success "操作完成，共处理 $COUNT 个文件"
}

############################################
# Help
############################################

show_help() {
cat << EOF

GitHub Actions 零冲突管理脚本 (工业增强版)

用法:
  $0 list
  $0 disable file.yml
  $0 enable file.yml

  $0 disable-all [--yes]
  $0 disable-all-except keep.yml
  $0 enable-all

选项:
  --yes      跳过确认
  --dry-run  仅预览，不修改文件 (强烈推荐先运行)

示例:

  # 强烈推荐的安全操作流程
  $0 disable-all --dry-run
  $0 disable-all --yes

EOF
}

############################################
# main
############################################

main() {

    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    check_workflows_dir

    case "$1" in
        list) list_workflows ;;
        disable) disable_workflow "$WORKFLOWS_DIR/$2" ;;
        enable) enable_workflow "$WORKFLOWS_DIR/$2" ;;
        disable-all) disable_all ;;
        disable-all-except) disable_all_except "$@" ;;
        enable-all) enable_all ;;
        help|--help|-h) show_help ;;
        *)
            print_error "未知命令: $1"
            show_help
            exit 1
        ;;
    esac
}

main "$@"
