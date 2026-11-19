# learning-log

每天的 Python 学习日志 + 当天写的代码和练习。一年后，这就是一份能直接拿给面试官看的成长档案。

## 目录结构

```
learning-log/
├─ notes/                    # 每天一篇 Markdown 日志
│  └─ 2026-11-19.md
├─ python/                   # 每天一个文件夹，放当天的代码和练习
│  └─ 2026-11-19/
│     ├─ learn_01_hello.py
│     └─ exercise_01_temperature.py
├─ projects/                 # 完整的小项目，一个项目一个文件夹
├─ templates/
│  └─ daily.md               # 日志模板
└─ scripts/
   ├─ new-day.cmd            # 每天双击：生成今天的日志和代码文件夹
   ├─ setup.cmd              # 只运行一次：连接 GitHub
   └─ push.cmd               # 可选：命令行提交推送（PyCharm 里用快捷键更方便）
```

---

## 一次性配置（两步）

### 第 1 步：安装 Git

PyCharm 的提交按钮最终调用的就是它，所以必须先装。

**双击 `scripts\install-git.cmd`**，它会自动查找最新版本、下载、并打开安装程序。

安装窗口弹出后，一路点 **Next → Install → Finish**，不用改任何选项。

装完后**关掉所有终端窗口和 PyCharm**，再重新打开。

> 如果自动下载失败（网络问题），脚本会打开 <https://git-scm.com/download/win>，手动下载双击即可。

验证：开始菜单搜 PowerShell，输入 `git --version`，能看到版本号就成功了。

### 第 2 步：双击 `scripts\setup.cmd`

按提示输入：

1. **GitHub 用户名**（没有账号先去 <https://github.com> 注册）
2. **邮箱**（注册 GitHub 用的那个）
3. **显示名**（拼音或英文名均可）

然后脚本会打开 GitHub 的新建仓库页面，仓库名已经填好了。你只需要：

- 确认名字是 `learning-log`
- 确认选中的是 **Public**
- **不要**勾选 `Add a README file`、`.gitignore`、`license`
- 点最下面的绿色 **Create repository**

回到命令行窗口，按一次回车，脚本会自动完成剩下的推送。

> 第一次推送可能会弹出浏览器让你登录 GitHub，点 **Authorize** 即可，以后不会再问。

成功后打开 `https://github.com/你的用户名/learning-log` 就能看到全部内容。

---

## 每天怎么用

### 1. 生成今天的文件夹

双击 `scripts\new-day.cmd`，会自动：

- 创建 `notes\2026-11-20.md`（当天的日志）
- 创建 `python\2026-11-20\`（当天的代码目录）

### 2. 写日志 + 写代码

在 **PyCharm** 里打开这个文件夹，左边文件树会刷新出来。

- 日志按模板填：学了什么、写了什么、卡在哪、明天做什么
- 代码放 `python\当天日期\`，命名规则见 [python/README.md](python/README.md)

### 3. 提交并推送

在 PyCharm 里：

| 快捷键 | 作用 |
|---|---|
| `Ctrl+K` | 提交（写一句说明，比如 `day 3: 循环和列表`） |
| `Ctrl+Shift+K` | 推送 |
| `Ctrl+T` | 拉取 |
| `Alt+9` | 查看提交历史 |

也可以双击 `scripts\push.cmd`，它会自动完成提交和推送。

---

## 提交信息怎么写

一行说清"这一天做了什么"，比 `update`、`fix` 这种有意义得多。

| 好的写法 | 为什么 |
|---|---|
| `day 1: 环境搭建，print 和变量` | 有编号、有主题 |
| `day 5: 练习题 10 道，卡在 while 循环` | 连困难都记下来了 |
| `day 12: 完成猜数字小游戏` | 有明确产出 |

到第 100 天回看，这一列就是你的成长时间线。

---

## 常见问题

| 现象 | 原因 | 解决 |
|---|---|---|
| `git` 不是内部或外部命令 | 装完没重开窗口 | 关掉所有终端和 PyCharm 再开 |
| push 报 `Support for password authentication was removed` | 用了账号密码 | 等浏览器弹窗，点授权 |
| `Updates were rejected` | 云端有本地没有的提交 | 先 `git pull --rebase origin main` |
| setup 提示推送失败 | 建仓库时勾了 Add a README | 删掉仓库重建，什么都别勾 |
| PyCharm 里 Git 选项是灰的 | PyCharm 没识别到 Git | 重启 PyCharm，或 `Ctrl+Alt+S` → Version Control → Git 里指定路径 |
| 中文文件名显示成 `\346\226\207` | Git 默认转义 | `git config --global core.quotepath false` |

---

## 几条规矩

1. **公开仓库不要放密码、token、API key。** 一旦提交，历史里就删不干净了。
2. **当天没学也提交一行** "今天休息"。连续记录比完美记录重要。
3. **代码跑通再提交**。半成品可以提交，但要写清楚哪里没完成。
4. 到第 30 天，把 `notes/` 里的内容挑几篇整理成一篇月度总结，这比日志本身更有价值。
