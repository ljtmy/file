# tmux配置文件

在你的 Linux 用户主目录下创建或编辑 `~/.tmux.conf` 文件

​`nano ~/.tmux.conf`

```plaintext
# ==========================
# tmux 个人优化配置文件
# ==========================

# --- 1. 基础体验优化 ---

# 开启 256 色彩支持 (确保 C++ 等代码的语法高亮在终端中正常显示)
set -g default-terminal "screen-256color"

# 开启鼠标支持 (极大地提升体验：允许用鼠标点击切换窗格、拖动调整窗格大小、滚动查看历史输出)
set -g mouse on

# 窗口和窗格的编号从 1 开始 (默认是 0，但在键盘上 0 太远了，1 开始更符合直觉)
set -g base-index 1
setw -g pane-base-index 1
# 窗口关闭后自动重新编号
set -g renumber-windows on

# 增加历史回滚行数 (默认只有 2000 行，增加到 50000 行，方便追溯超长的编译报错或 eBPF 内核监控日志)
set -g history-limit 50000

# 消除按 ESC 键的延迟 (对于经常使用 Vim/Neovim 编辑代码的人来说，这一行是救命的)
set -sg escape-time 0

# --- 2. 快捷键重映射 (Prefix 依然保持默认的 Ctrl+b) ---

# 使用更直观的符号来进行窗口分割 (原版是 % 和 ")
# 前缀键 + | 进行左右分割
# 前缀键 + - 进行上下分割
unbind '"'
bind - split-window -v
unbind %
bind | split-window -h

# 快速重新加载 tmux 配置文件 (前缀键 + r)
bind r source-file ~/.tmux.conf \; display-message "tmux 配置已重新加载完毕!"

# 在复制模式 (Prefix + [) 中开启 Vim 风格的快捷键 (可以使用 h, j, k, l 移动光标)
setw -g mode-keys vi

# --- 3. 状态栏 (Status Bar) 极简美化 ---

# 状态栏刷新频率设置为 1 秒
set -g status-interval 1

# 状态栏颜色设置 (黑底白字，简洁护眼)
set -g status-bg "#282a36"
set -g status-fg white

# 状态栏左侧：显示当前的 Session 名称 (绿色高亮)
set -g status-left-length 40
set -g status-left "#[fg=#50fa7b,bold] ❐ #S #[default]  "

# 状态栏右侧：显示当前时间和日期 (青色高亮)
set -g status-right "#[fg=#8be9fd] %Y-%m-%d %H:%M:%S "

# 当前激活的窗口标签高亮显示 (粉色背景)
setw -g window-status-current-format "#[bg=#ff79c6,fg=#282a36,bold] #I:#W "
# 未激活的窗口标签格式
setw -g window-status-format " #I:#W "
```

保存文件并退出编辑器后，在终端中运行以下命令让配置立即生效：

​`tmux source-file ~/.tmux.conf`
