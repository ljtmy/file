# git和gitlab常用指令

## git常用指令

|**类别**|**常用指令**|**核心功能说明**|
| --| ------| --------------------------------------------|
|**基础配置**|​`git config --global user.name "YourName"`|设置全局提交者姓名（如：`xidian-student`）|
||​`git config --global user.email "Email"`|设置全局联系邮箱|
|**项目起步**|​`git init`|在当前目录初始化一个新的本地仓库|
||​`git clone <url>`|克隆远程仓库到本地（如：`cryptography-lib`仓库）|
|**变更追踪**|​`git status`|查看当前工作区和暂存区的状态|
||​`git add <file>`|将修改后的文件（如`ebpf_probe.c`）添加到暂存区|
||​`git commit -m "msg"`|将暂存区内容提交到本地仓库，并记录提交信息|
|**同步协作**|​`git pull origin <branch>`|拉取远程分支更新并与本地合并|
||​`git push origin <branch>`|将本地提交推送到远程服务器|
|**分支管理**|​`git branch`|查看所有本地分支|
||​`git checkout -b <name>`|创建并切换到新分支（如`feature/dpdk-optimization`）|
||​`git merge <branch>`|将指定分支的代码合并到当前分支|
|**历史与撤销**|​`git log --oneline`|以简短形式查看提交历史|
||​`git reset --soft HEAD~1`|撤销最近一次提交，但保留修改后的代码|
||​`git stash`|暂时寄存当前的修改，以便快速切换到其他任务|

‍

## gitlab常用指令

|**类别**|**常用指令**|**核心功能说明**|
| --| ------| ------------------------------------------------------|
|**身份鉴权**|​`glab auth login`|启动交互式登录，通过 Token 或浏览器授权|
||​`glab auth status`|验证当前 GitLab 账户的连通性与权限|
|**合并请求 (MR)**|​`glab mr list`|列出当前项目所有活跃的合并请求|
||​`glab mr view <ID>`|在终端中详细阅读某个 MR 的内容和评论|
||​`glab mr create`|交互式创建 MR（可指定目标分支和描述）|
||​`glab mr diff <ID>`|直接对比 MR 中的代码改动（适合 Claude 进行代码审查）|
||​`glab mr merge <ID>`|批准并执行合并操作|
|**任务追踪 (Issue)**|​`glab issue list`|查看当前项目开启的 Issue 列表|
||​`glab issue view <ID>`|查看特定 Issue 的详细需求描述|
||​`glab issue create`|快速提交一个新的 Bug 报告或功能建议|
|**流水线 (CI/CD)**|​`glab ci status`|实时查看当前分支流水线（Pipeline）的运行状态|
||​`glab ci view`|监控具体 Job 的执行情况与实时日志输出|
||​`glab ci trace <ID>`|追踪并显示指定 Job 的完整输出日志|
|**项目管理**|​`glab repo view`|在浏览器或终端中快速查看当前项目的主页详情|
||​`glab variable list`|查看项目中配置的环境变量（常用于 CI/CD 配置）|

‍
