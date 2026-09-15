# 阿米娅 · 寰宇独奏 — Codex Pet

**把阿米娅带到你的 Codex 桌面。由用户提供创意与角色参考，OpenAI Codex 完成动画制作、验证、安装与发布工程。**

这是一份已经制作好的 **Codex v2 自定义宠物**。下载后即可安装，无须运行图像生成、配置 API Key 或安装 Python / Node.js。

[下载 v1.0.2 完整安装包](https://github.com/White-Pan/amiya-universe-solo-codex-pet/releases/download/v1.0.2/amiya-universe-solo-v1.0.2.zip) · [查看所有版本](https://github.com/White-Pan/amiya-universe-solo-codex-pet/releases)

| 待机 | 工作中 | 16 方向注视 |
| :---: | :---: | :---: |
| ![待机](assets/idle.gif) | ![思考与工作](assets/working.gif) | ![注视方向](assets/look.gif) |

## 下载与安装

需要支持 **v2 自定义宠物**的 Codex 桌面应用。此仓库是宠物资源包，不包含 Codex 应用本身。

1. 在仓库页面选择 **Code → Download ZIP**，或下载 **Releases** 中的完整安装包。
2. **完整解压**到任意目录。不要在压缩包内部直接运行脚本，也不要只下载 `pet.json`。
3. 按你的系统安装：

### Windows

双击 **`install.cmd`**，或在解压目录打开 PowerShell：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
```

**请复制上面的完整命令，不要直接运行 `./install.ps1` 或 `.\install.ps1`**：系统签名策略可能提示“未进行数字签名 / 无法加载文件”。也可以双击 `install.cmd`，它已包含相同启动参数。

`ExecutionPolicy Bypass` 仅用于该次 PowerShell 进程，不修改系统执行策略。安装无需管理员权限，不会联网下载依赖。

若旧版安装提示 `ConvertFrom-Json` 并出现中文乱码，请下载 v1.0.1 或更新版本并重新解压。这是旧安装脚本的编码读取问题，已修复。

### macOS / Linux

```sh
sh install.sh
```

需要系统提供 `shasum` 或 `sha256sum`。脚本可复制资源，但实际使用仍取决于你的系统是否有支持该格式的 Codex 桌面应用。Windows 安装已在隔离目录中测试；未在原生 macOS / Linux 上实测。

### 手动安装

将 `pet/` 内的两个文件放到以下位置：

```text
~/.codex/pets/amiya-universe-solo/
├── pet.json
└── spritesheet.webp
```

Windows 默认对应 `%USERPROFILE%\.codex\pets\amiya-universe-solo\`。如果你设置了 `CODEX_HOME`，请使用 `$CODEX_HOME/pets/amiya-universe-solo/`；两个安装脚本都会优先遵循该环境变量。

安装后打开 Codex 的宠物选择界面，选择 **阿米娅·寰宇独奏**。如果暂未显示，完全退出并重新打开 Codex。不同应用版本的入口名称可能不同。本项目不修改应用设置，也不会自动切换你当前的宠物。

### 更新与卸载

重复安装相同文件不会创建多余备份。如果检测到不同版本，脚本默认停止；显式更新会先备份原来的两个文件：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -Update
```

```sh
sh install.sh --update
```

备份位于该宠物目录下的 `backups/`。卸载时只需移走或删除 `amiya-universe-solo` 目录，不要删除整个 `pets` 目录。

## 离线预览

双击 **`preview.html`**，可切换全部 9 组动作，并开启“随鼠标注视”查看 16 个方向。预览不需要启动服务器、不连接网络，也不读取你的 Codex 配置。GitHub 文件页显示的是 HTML 源码，请下载解压后打开。

## Codex 在这个项目中做了什么？

这个项目不是只让 AI 画一张图，而是由 **Codex 作为制作与工程协作者**，把角色参考整理成真正能使用的桌面宠物。

| 环节 | Codex 的具体贡献 |
| --- | --- |
| 参考处理 | 读取用户提供的 WebM，挑选关键帧，提取兔耳、帽子、眼睛、服装与配色等稳定特征。 |
| 形象与动画 | 使用内置图像生成能力与 hatch-pet 工作流，建立主形象并制作各状态动画；不依赖使用者重新生成。 |
| 状态语义 | 单独制作 `running` 工作状态：思考、专注与手部动作。它与左右移动动画不同，这一独立设计已保留。 |
| 注视动作 | 制作四个主方向参考，再生成两组连贯注视帧，检查朝向、角色大小、脚下位置与衔接。 |
| 质量检查 | 执行逐帧与图集检查、透明边缘处理、方向盲测和独立视觉复核，修正错向与裁切问题。 |
| 交付工程 | 编写离线预览、跨平台安装脚本、校验和、文档及公开发布目录，排除个人文件。 |

项目发起与维护：[White-Pan](https://github.com/White-Pan)。用户负责提出创意、提供角色参考、决定复用与保留哪些成果，以及批准最终发布。**Codex 是制作工具与协作助手，不是阿米娅角色或原始美术的创作者。**

## 动画与规格

| 状态 | 内容 | 帧数 |
| --- | --- | ---: |
| `idle` | 待机、呼吸与眨眼 | 6 |
| `running-right` | 向右移动 | 8 |
| `running-left` | 向左移动 | 8 |
| `waving` | 挥手 | 4 |
| `jumping` | 蓄力、跳起与落地 | 5 |
| `failed` | 失落反应 | 8 |
| `waiting` | 等待回应或批准 | 6 |
| `running` | 工作与思考，非移动 | 6 |
| `review` | 查看结果 | 6 |
| 注视 | 顺时针 16 方向 | 16 |

- 格式：透明 WebP，`spriteVersionNumber: 2`。
- 图集：**1536 × 2288**；8 列 × 11 行；每格 **192 × 208**。
- 主方向：000° 向上、090° 向右、180° 向下、270° 向左。
- 已通过最终格式、尺寸、透明边缘检查及三份独立盲测的主方向判定。
- 已知小差异：067.5° / 292.5° 的抬头幅度较轻，两半圈交界处帽子轮廓变化略明显，跳跃时帽子看起来稍大。这些已经视觉复核并保留，不代表全套动作逐像素一致。

## 仓库内容与隐私

```text
pet/               可直接安装的 pet.json 与 spritesheet.webp
assets/            README 中的最终预览图片
install.cmd        Windows 双击入口
install.ps1        Windows 安装与备份更新
install.sh         macOS / Linux 资源安装与备份更新
preview.html       离线动作和注视预览
checksums.sha256   成品文件完整性校验
NOTICE.md          角色来源与使用说明
```

原始 WebM、抽帧、生成草稿、失败版本、对话记录、完整 QA 日志、个人路径、账号凭据和本机配置均不在此仓库中。`.gitignore` 使用顶层白名单，并额外忽略常见私用文件。仓库不包含遥测、联网安装器或自动上传功能。

## 角色与来源

这是基于《明日方舟》阿米娅「寰宇独奏」形象制作的**非官方同人宠物**，不代表角色权利方或 OpenAI 官方发布。角色、名称、服装及原始美术的相关权利归各自权利人。本仓库公开可下载，不代表对第三方角色素材授予商业使用许可；详情见 [NOTICE.md](NOTICE.md)。
