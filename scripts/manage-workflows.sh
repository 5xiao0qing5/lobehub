#!/bin/bash

# GitHub Actions 工作流管理脚本
# 用于批量禁用/启用 GitHub Actions 工作流

set -euo pipefail

WORKFLOWS_DIR=".github/workflows"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FORCE=false

# 检查是否带 --yes
for arg in "$@"; do
    if [[ "$arg" == "--yes" ]]; then
        FORCE=true
    fi
done

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

check_workflows_dir() {
    if [ ! -d "$REPO_ROOT/$WORKFLOWS_DIR" ]; then
        print_error "工作流目录不存在: $REPO_ROOT/$WORKFLOWS_DIR"
        exit 1
    fi
    cd "$REPO_ROOT/$WORKFLOWS_DIR"
}

confirm_action() {
    if [ "$FORCE" = true ]; then
        print_warning "已使用 --yes，跳过确认"
        return
    fi

    read -p "⚠ 确认要禁用所有工作流吗？(yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        print_warning "操作已取消"
        exit 0
    fi
}

list_workflows() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    📋 工作流列表"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    print_info "启用的工作流 (*.yml):"
    echo ""

    shopt -s nullglob
    enabled=( *.yml )
    disabled=( *.yml.disabled )

    if [ ${#enabled[@]} -eq 0 ]; then
        echo "  (无)"
    else
        for file in "${enabled[@]}"; do
            echo "  ✓ $file"
        done
    fi

    echo ""
    print_warning "禁用的工作流 (*.yml.disabled):"
    echo ""

    if [ ${#disabled[@]} -eq 0 ]; then
        echo "  (无)"
    else
        for file in "${disabled[@]}"; do
            echo "  ✗ $file"
        done
    fi
    echo ""
}

disable_workflow() {
    local workflow=$1

    if [ ! -f "$workflow" ]; then
        print_error "工作流不存在: $workflow"
        return 1
    fi

    if [[ "$workflow" == *.disabled ]]; then
        print_warning "工作流已经被禁用: $workflow"
        return 0
    fi

    mv "$workflow" "$workflow.disabled"
    print_success "已禁用: $workflow"
}

enable_workflow() {
    local workflow=$1

    if [ ! -f "$workflow" ]; then
        print_error "工作流不存在: $workflow"
        return 1
    fi

    if [[ "$workflow" != *.disabled ]]; then
        print_warning "工作流已经是启用状态: $workflow"
        return 0
    fi

    local original_name="${workflow%.disabled}"
    mv "$workflow" "$original_name"
    print_success "已启用: $original_name"
}

disable_all() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    🚫 禁用所有工作流"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    confirm_action

    shopt -s nullglob
    files=( *.yml )

    if [ ${#files[@]} -eq 0 ]; then
        print_info "没有找到需要禁用的工作流"
        return
    fi

    local disabled_count=0

    for file in "${files[@]}"; do
        disable_workflow "$file"
        disabled_count=$((disabled_count + 1))
    done

    echo ""
    print_success "完成！已禁用 $disabled_count 个工作流"
    echo ""
}

disable_all_except() {
    local keep_list=("$@")

    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    🚫 批量禁用工作流"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    shopt -s nullglob
    files=( *.yml )

    local disabled_count=0
    local kept_count=0

    for file in "${files[@]}"; do
        keep=false

        for keep_file in "${keep_list[@]}"; do
            if [ "$file" = "$keep_file" ]; then
                keep=true
                break
            fi
        done

        if [ "$keep" = false ]; then
            disable_workflow "$file"
            disabled_count=$((disabled_count + 1))
        else
            print_info "保留: $file"
            kept_count=$((kept_count + 1))
        fi
    done

    echo ""
    print_success "完成！已禁用 $disabled_count 个工作流，保留 $kept_count 个工作流"
    echo ""
}

enable_all() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    ✓ 批量启用工作流"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""

    shopt -s nullglob
    files=( *.yml.disabled )

    if [ ${#files[@]} -eq 0 ]; then
        print_info "没有需要启用的工作流"
        return
    fi

    local enabled_count=0

    for file in "${files[@]}"; do
        enable_workflow "$file"
        enabled_count=$((enabled_count + 1))
    done

    echo ""
    print_success "完成！已启用 $enabled_count 个工作流"
    echo ""
}

show_help() {
cat << EOF

GitHub Actions 工作流管理脚本

用法:
    $0 [命令] [选项]

命令:
    list
    disable <workflow>
    enable <workflow>

    disable-all [--yes]        禁用所有工作流
    disable-all-except [files]
    enable-all

示例:
    $0 disable-all --yes   (跳过确认，适合 CI)

EOF
}

main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    check_workflows_dir

    case "$1" in
        list) list_workflows ;;
        disable)
            [ $# -lt 2 ] && { print_error "请指定工作流"; exit 1; }
            disable_workflow "$2"
            ;;
        enable)
            [ $# -lt 2 ] && { print_error "请指定工作流"; exit 1; }
            enable_workflow "$2"
            ;;
        disable-all) disable_all ;;
        disable-all-except)
            shift
            disable_all_except "$@"
            ;;
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
