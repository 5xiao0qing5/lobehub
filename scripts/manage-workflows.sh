#!/bin/bash

# GitHub Actions 工作流管理脚本
# 用于批量禁用/启用 GitHub Actions 工作流

set -e

WORKFLOWS_DIR=".github/workflows"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# 检查工作流目录
check_workflows_dir() {
    if [ ! -d "$REPO_ROOT/$WORKFLOWS_DIR" ]; then
        print_error "工作流目录不存在: $REPO_ROOT/$WORKFLOWS_DIR"
        exit 1
    fi
    cd "$REPO_ROOT/$WORKFLOWS_DIR"
}

# 列出所有工作流
list_workflows() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    📋 工作流列表"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    print_info "启用的工作流 (*.yml):"
    echo ""
    if ls *.yml 2>/dev/null | grep -q .; then
        for file in *.yml; do
            echo "  ✓ $file"
        done
    else
        echo "  (无)"
    fi
    
    echo ""
    print_warning "禁用的工作流 (*.yml.disabled):"
    echo ""
    if ls *.yml.disabled 2>/dev/null | grep -q .; then
        for file in *.yml.disabled; do
            echo "  ✗ $file"
        done
    else
        echo "  (无)"
    fi
    echo ""
}

# 禁用单个工作流
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

# 启用单个工作流
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
    
    original_name="${workflow%.disabled}"
    mv "$workflow" "$original_name"
    print_success "已启用: $original_name"
}

# 禁用所有工作流（除了保留列表）
disable_all_except() {
    local keep_list=("$@")
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    🚫 批量禁用工作流"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    if [ ${#keep_list[@]} -gt 0 ]; then
        print_info "将保留以下工作流:"
        for keep_file in "${keep_list[@]}"; do
            echo "  ○ $keep_file"
        done
        echo ""
    fi
    
    local disabled_count=0
    local kept_count=0
    
    for file in *.yml; do
        [ ! -f "$file" ] && continue
        
        # 检查是否在保留列表中
        keep=false
        for keep_file in "${keep_list[@]}"; do
            if [ "$file" = "$keep_file" ]; then
                keep=true
                break
            fi
        done
        
        if [ "$keep" = false ]; then
            disable_workflow "$file"
            ((disabled_count++))
        else
            print_info "保留: $file"
            ((kept_count++))
        fi
    done
    
    echo ""
    print_success "完成！已禁用 $disabled_count 个工作流，保留 $kept_count 个工作流"
    echo ""
}

# 启用所有已禁用的工作流
enable_all() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                    ✓ 批量启用工作流"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    local enabled_count=0
    
    for file in *.yml.disabled; do
        [ ! -f "$file" ] && continue
        enable_workflow "$file"
        ((enabled_count++))
    done
    
    if [ $enabled_count -eq 0 ]; then
        print_info "没有需要启用的工作流"
    else
        echo ""
        print_success "完成！已启用 $enabled_count 个工作流"
    fi
    echo ""
}

# 禁用特定类别的工作流
disable_category() {
    local category=$1
    local pattern=""
    local description=""
    
    case $category in
        claude)
            pattern="claude-*.yml"
            description="Claude AI 相关"
            ;;
        issue)
            pattern="issue-*.yml"
            description="Issue 管理"
            ;;
        desktop)
            pattern="*desktop*.yml"
            description="桌面应用"
            ;;
        test)
            pattern="test*.yml e2e.yml lighthouse.yml"
            description="测试相关"
            ;;
        *)
            print_error "未知类别: $category"
            print_info "支持的类别: claude, issue, desktop, test"
            return 1
            ;;
    esac
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "                禁用 $description 工作流"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    local disabled_count=0
    
    for file in $pattern; do
        if [ -f "$file" ]; then
            disable_workflow "$file"
            ((disabled_count++))
        fi
    done
    
    if [ $disabled_count -eq 0 ]; then
        print_info "没有找到匹配的工作流"
    else
        echo ""
        print_success "完成！已禁用 $disabled_count 个 $description 工作流"
    fi
    echo ""
}

# 显示帮助信息
show_help() {
    cat << EOF

GitHub Actions 工作流管理脚本

用法:
    $0 [命令] [选项]

命令:
    list                        列出所有工作流（启用和禁用）
    
    disable <workflow>          禁用单个工作流
                                示例: $0 disable test.yml
    
    enable <workflow>           启用单个工作流
                                示例: $0 enable test.yml.disabled
    
    disable-all-except [files]  禁用所有工作流，除了指定的文件
                                示例: $0 disable-all-except auto-docker-build.yml
    
    enable-all                  启用所有已禁用的工作流
    
    disable-category <类别>     禁用特定类别的工作流
                                类别: claude, issue, desktop, test
                                示例: $0 disable-category claude
    
    help                        显示此帮助信息

示例:
    # 列出所有工作流
    $0 list
    
    # 禁用单个工作流
    $0 disable test.yml
    
    # 只保留 auto-docker-build.yml，禁用其他所有工作流
    $0 disable-all-except auto-docker-build.yml
    
    # 禁用所有 Claude AI 相关工作流
    $0 disable-category claude
    
    # 启用所有已禁用的工作流
    $0 enable-all

EOF
}

# 主函数
main() {
    # 检查参数
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    check_workflows_dir
    
    case "$1" in
        list)
            list_workflows
            ;;
        disable)
            if [ -z "$2" ]; then
                print_error "请指定要禁用的工作流"
                echo "用法: $0 disable <workflow.yml>"
                exit 1
            fi
            disable_workflow "$2"
            ;;
        enable)
            if [ -z "$2" ]; then
                print_error "请指定要启用的工作流"
                echo "用法: $0 enable <workflow.yml.disabled>"
                exit 1
            fi
            enable_workflow "$2"
            ;;
        disable-all-except)
            shift
            disable_all_except "$@"
            ;;
        enable-all)
            enable_all
            ;;
        disable-category)
            if [ -z "$2" ]; then
                print_error "请指定要禁用的类别"
                echo "用法: $0 disable-category <claude|issue|desktop|test>"
                exit 1
            fi
            disable_category "$2"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"
