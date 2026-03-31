这是一份完整、可直接复制粘贴的部署指南。请在 Antigravity IDE 中打开你的仓库根目录终端，依次执行以下步骤。

### 第一步：初始化与安装依赖

首先初始化 Node.js 环境，并一次性安装所有需要的依赖包（包括引导工具和校验拦截工具）。

Bash

```
# 1. 初始化 package.json (如果已存在则会跳过或更新)
npm init -y

# 2. 安装 Commitizen 交互式引导工具
npm install commitizen cz-customizable --save-dev

# 3. 安装 Commitlint 校验工具和规范配置
npm install @commitlint/cli commitlint-config-cz --save-dev

# 4. 安装 Husky Git 钩子工具
npm install husky --save-dev
```

------

### 第二步：配置 `package.json`

我们需要将 Commitizen 的配置和快捷命令合并到你的 `package.json` 中。你可以直接用下方的内容**替换或修改**你现有的 `package.json`（注意修改 `name` 等基础信息，重点是 `scripts` 和 `config` 字段）：

JSON

```
{
  "name": "my-research-repo",
  "version": "1.0.0",
  "description": "科研与技术笔记库",
  "scripts": {
    "commit": "git-cz",
    "prepare": "husky"
  },
  "devDependencies": {
    "@commitlint/cli": "^19.0.0",
    "commitizen": "^4.3.0",
    "commitlint-config-cz": "^0.13.3",
    "cz-customizable": "^7.0.0",
    "husky": "^9.0.0"
  },
  "config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    }
  }
}
```

------

### 第三步：创建交互提示配置文件 `.cz-config.js`

在仓库根目录新建一个文件名为 `.cz-config.js`，并将以下内容复制进去。这里已经为你配置好了 10 个核心类型以及你常用的底层技术栈作用域：

JavaScript

```
module.exports = {
  types: [
    { value: 'log',      name: 'log:      [日志] 记录工作进度、周报或实验过程' },
    { value: 'note',     name: 'note:     [笔记] 技术调研、源码解析或论文阅读' },
    { value: 'outcome',  name: 'outcome:  [成果] 提交正式报告、演示文档或产出物' },
    { value: 'exp',      name: 'exp:      [实验] 编写验证性原型、测试脚本或Demo' },
    { value: 'perf',     name: 'perf:     [性能] 底层优化、降低延迟或提升吞吐量' },
    { value: 'fix',      name: 'fix:      [修复] 修正笔记错误或实验脚本中的漏洞' },
    { value: 'refactor', name: 'refactor: [重构] 优化代码结构或重新整理笔记小节' },
    { value: 'build',    name: 'build:    [构建] 调整编译配置(CMake/Makefile)或依赖' },
    { value: 'docs',     name: 'docs:     [文档] 更新README、环境指南或项目说明' },
    { value: 'chore',    name: 'chore:    [杂项] 仓库日常维护、忽略文件或配置变更' }
  ],
  scopes: [
    { name: 'ebpf' },
    { name: 'linux' },
    { name: 'dpdk' },
    { name: 'c++' },
    { name: 'crypto' }
  ],
  messages: {
    type: '选择提交类型:',
    scope: '选择/输入范围(可选):',
    customScope: '请输入自定义的范围:',
    subject: '简短描述修改 (必填):',
    body: '详细背景说明 (可选，使用 "|" 换行):',
    confirmCommit: '确定提交以上信息？(y/n)'
  },
  skipQuestions: ['footer', 'breaking'],
  subjectLimit: 100
};
```

------

### 第四步：创建拦截校验配置文件 `commitlint.config.js`

在仓库根目录新建文件 `commitlint.config.js`，让校验工具读取你自定义的 10 个类型：

JavaScript

```
module.exports = {
  extends: ['cz'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'log', 'note', 'outcome', 'exp', 'perf', 
        'fix', 'refactor', 'build', 'docs', 'chore'
      ]
    ],
    'type-empty': [2, 'never'],
    'subject-empty': [2, 'never']
  }
};
```

------

### 第五步：初始化并配置 Husky (Git Hook)

这一步是为了在执行 git 提交时，自动唤起我们刚才配置的拦截校验。在终端中依次执行以下命令：

Bash

```
# 1. 初始化 husky 目录 (这会运行 package.json 里的 prepare 脚本)
npm run prepare

# 2. 写入 commit-msg 钩子脚本 (注意这里针对的是 Husky v9+ 版本的标准写法)
echo 'npx --no -- commitlint --edit "$1"' > .husky/commit-msg
```

------

### 第六步：测试工作流

现在，你的整个规范体系已经部署完毕。

**日常提交流程：**

1. 将修改的文件暂存：`git add .`

2. **不再使用** `git commit -m`，而是运行以下命令触发交互菜单：

   Bash

   ```
   npm run commit
   ```

3. 按照终端里的中文提示，用方向键选择类型（如 `note`），选择作用域（如 `ebpf`），然后输入描述，最后回车确认即可。

**防呆测试：**

你可以故意用原生的方式尝试提交一个不合规的信息来测试拦截功能：

Bash

```
git commit -m "update some notes"
```

如果一切配置正确，终端会抛出红色的报错信息，并阻止这次提交，提示你缺少相关的类型（Type）。