# kaitai web ide 本地部署指南

## 基础环境准备

1. ### 下载并解压 Node.js

从windos环境中下载node.js，拷贝到linux环境中。解压文件，将解压后的文件夹重命名为 nodejs。

2. ### 配置个人环境变量

```bash
# 编辑 bash 配置文件
vi ~/.bashrc
```

在文件末最后一行添加：

```bash
export PATH=$HOME/nodejs/bin:$PATH
```

保存退出（`:wq`）后，刷新配置并验证：

```bash
source ~/.bashrc
node -v
npm -v
```

## 获取代码与依赖安装

1. ### 克隆webide源代码

```bash
cd ~
git clone https://github.com/kaitai-io/kaitai_struct_webide.git
```

2. ### 安装前端依赖

```bash
cd kaitai_struct_webide
npm install
```

3. ### 替换formats和samples

清空默认文件夹中内容

4. ### 编译服务与 SSH 隧道访问

身处无图形界面的远程服务器，需要通过 MobaXterm 的 SSH 隧道功能，将服务器内部的服务端口安全地映射到 Windows 本地。

**1. 编译并启动本地服务器**

每次修改或上传了新的 `.ksy`​ 格式文件 / 二进制样本后，**必须**使用带 `--compile` 参数的命令启动服务，以重新生成文件索引：

```bash
node serve.js --compile
```

 *(看到* *​`Listening on 8000`​*​ *提示后，保持终端不要关闭。)*

**2. 在 MobaXterm 中建立 SSH 隧道**

1. 点击 MobaXterm 顶部菜单栏的 ​**Tunneling**。
2. 点击 **New SSH tunnel** -\> 选择 ​**Local port forwarding**。
3. 按以下规则填写映射：

   - **左侧**  **​`<Local machine>`​** ​ **:**  Forwarded port 填入 `8000`。
   - **中间**  **​`<SSH server>`​** ​ **:**  填入你的服务器 IP、用户名和 22 端口。
   - **右侧**  **​`<Remote server>`​** ​ **:**  Remote server 填入 `127.0.0.1`​，Remote port 填入 `8000`。
4. 保存规则，并在列表界面点击 **Start** 图标（变亮且显示黄色钥匙即为开启成功）。

**3. 在本地浏览器访问 IDE**

打开 Windows 上的任意浏览器（Chrome / Edge 等），在地址栏输入：

```
http://127.0.0.1:8000
```

‍
