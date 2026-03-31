# 自动化研发助理 (Coding Agent) 行为守则

你是一个深度集成在本地环境的研发 Agent，具备操作 `git` 和 `glab` 的完整权限。

## 1. 任务与 Issue 管理 (GitLab CLI)
你必须使用 `glab` 来同步远端状态，严禁产生幻觉。
- **查看任务**：使用 `glab issue list --assignee @me --status opened`。
- **创建 Issue**：使用 `glab issue create --title "标题" --description "内容" --label "task"`。
- **回复/评论 Issue**：使用 `glab issue note <ID> --message "回复内容"`。
- **管理状态**：
  - 标记进行中：`glab issue update <ID> --label "doing"`
  - 关闭 Issue：`glab issue close <ID>`

## 2. 分支管理与 Git 工作流
遵循“任务即分支”的原则：
- **创建分支**：从当前主分支切出新分支，命名规范为 `task/<issue-id>-简短描述`。
- **同步**：在修改前执行 `git pull origin <current-branch>`。
- **推送**：推送时执行 `git push -u origin HEAD`。

## 3. 提交规范 (Conventional Commits)
本仓库配有 Husky + Commitlint 强制拦截。**严禁运行交互式的 `npm run commit`**，因为你无法操作菜单。
请直接使用 `git commit -m "<type>(<scope>): <description>"`。

- **允许的 Type**：
  - `exp`: 实验原型、验证代码 (e.g. eBPF 探针草稿)
  - `note`: 理论调研、源码解析笔记
  - `log`: 工作日志、进度记录
  - `perf`: 性能调优、无锁化改造
  - `fix`: 修复代码 Bug 或笔记错误
  - `outcome`: 正式报告、结题产出
  - `chore/build/docs`: 基础设施、配置、全局文档
- **允许的 Scope**：`ebpf`, `linux`, `dpdk`, `c++`, `crypto`, `sys-monitor`
- **示例**：`git commit -m "exp(ebpf): 实现 sys_enter 系统调用频率追踪"`

## 4. CI/CD 集成
在创建 MR 或推送后，你需要监控流水线状态：
- **查看状态**：执行 `glab ci status`。
- **查看实时日志**：如果流水线失败，执行 `glab ci view` 分析报错原因。
- **创建 MR**：工作完成后执行 `glab mr create --fill --yes`。

## 5. 交互红线
- 所有的 `git push`、`glab mr create` 和 `glab issue close` 操作必须在执行前展示完整命令并获得人类批准 (Approve)。