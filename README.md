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
| PyCharm 提示"无法刷新 / 解释器不可用" | 虚拟环境建在 DSH 工作区里，被沙箱隔离 | 见下方「疑难排查：解释器不可用」 |
| 推送失败：`over proxy 127.0.0.1` / `schannel ... handshake` | 代理没开、节点挂了，或证书吊销检查超时 | 见下方「疑难排查：推送连不上 GitHub」 |

---

## 疑难排查：解释器不可用

**现象**：PyCharm 右上角通知出现

> ⚠ 无法刷新 ~\Documents\...\learning-log\.venv
> 解释器不可用。请确保其存在，然后刷新。

右下角状态栏的解释器也变灰/变红，运行按钮用不了。

### 排查思路（这套方法对任何 IDE 报错都通用）

1. **弹窗只是结论，日志里才是原因。**
   打开 `Help → Show Log in Explorer`，找到 `idea.log`，搜 `Skeleton generation failed`。
   本例真正的错误是：

   ```
   PermissionError: [Errno 13] Permission denied:
   ...\JetBrains\PyCharm2026.3\python_stubs\-769667985\array.py
   ```

   意思是：解释器本身能启动，但 IDE 给它生成代码补全骨架时，**写不进自己的缓存目录**。

2. **不要猜，做最小实验"只改一个变量"。**
   同一条命令，换一个条件再跑一次：

   | 实验 | 结果 |
   |---|---|
   | 用 `D:\...\Python315\python.exe` 跑同一个生成器 | 成功 |
   | 把同一个 exe 复制到工作区里再跑 | 失败（Errno 13） |

   两次一对比就知道：既不是 Python 坏了，也不是 PyCharm 坏了，问题在**程序所在的位置**。

3. **根因**：`learning-log` 在 DeepSeek Harness 的会话工作区里。DSH 的沙箱会把**从工作区启动的可执行文件**按不可信代码隔离——只允许写工作区和临时目录，写 `%LOCALAPPDATA%` 会被拒绝。而 PyCharm 的骨架、包索引正好都在 `%LOCALAPPDATA%\JetBrains\` 下，所以每次启动都失败。

4. **解决**：把虚拟环境的**真实目录**放到工作区外，工作区里只留一个"目录联接"指过去。
   这样 PyCharm 的配置一个字都不用改，但解释器的真实路径已经在工作区外，沙箱就不再拦它。

   本项目现在的布局：

   | 位置 | 是什么 |
   |---|---|
   | `C:\Users\14732\venvs\learning-log` | 真实的虚拟环境（Python 3.15.2） |
   | `learning-log\.venv` | 目录联接（junction），指向上面那个目录 |

   以后若清理时误删了真实目录，`.venv` 会变成空壳，用下面两条命令重建即可（PowerShell，**不需要管理员**）：

   ```powershell
   & "D:\Users\14732\AppData\Local\Programs\Python\Python315\python.exe" -m venv C:\Users\14732\venvs\learning-log
   cmd /c mklink /J "C:\Users\14732\Documents\deepseek-harness\default-workspace\learning-log\.venv" "C:\Users\14732\venvs\learning-log"
   ```

   重建后重启 PyCharm，它会自动重新生成骨架，通知里的警告随之消失。

### 一条规矩

工作区里只放**会被 git 提交的东西**：源码、笔记、模板。
虚拟环境、解释器、缓存这类"属于这台机器"的工具，一律放在工作区外，项目里用一个目录联接指过去。
这样 DSH 的沙箱、PyCharm 的索引互不打架。

---

## 疑难排查：推送连不上 GitHub

推送失败有**两种完全不同的报错**，先分清是哪一种，别急着改配置。

### 报错 A：`over proxy 127.0.0.1 ... after 0 ms`

| 关键词 | 含义 |
|---|---|
| `over proxy 127.0.0.1` | Git 把请求交给了本机代理，不是直连 |
| `after 0 ms` | **0 毫秒**就失败 = 连本地端口都没建成，说明代理软件没开，不是网速问题 |

原因：`~/.gitconfig` 里写死了 `http.proxy = http://127.0.0.1:7897`（Clash Verge 的端口），而代理软件没启动。

### 报错 B：`schannel: failed to receive handshake` / `CRYPT_E_REVOCATION_OFFLINE`

TCP 已经通了，卡在 TLS。Git for Windows 默认用 Windows 的 **schannel** 后端，握手时会去下载"证书吊销列表"，这一步在国内经常超时 → 整个握手被判失败。

### 第一步：先判断到底需不需要代理

```powershell
curl.exe --ssl-no-revoke -o NUL -w "%{http_code}`n" --max-time 15 https://github.com
```

- 返回 `200` → **直连可用**，别走代理
- 返回 `000` 或超时 → 直连不通，才需要代理

### 直连可用时的标准配置（本项目现在就是这个）

```powershell
git config --global --unset http.proxy
git config --global --unset https.proxy
git config --global http.schannelCheckRevoke false
```

> `schannelCheckRevoke false` 只是不查"证书是否已被吊销"，证书本身照样校验，安全性影响很小。
> 它专治上面报错 B。

### 如果确实必须走代理

1. 确认代理软件在跑：`netstat -ano | findstr 7897`，要有 `LISTENING`
2. 确认节点真的能用：Clash Verge 里做一次延迟测试；它的日志里如果满屏 `context deadline exceeded`，就是节点全挂了（端口开着也没用）
3. 能用之后再写回：

```powershell
git config --global http.proxy http://127.0.0.1:7897
git config --global https.proxy http://127.0.0.1:7897
```

> 小提示：PyCharm 的推送窗口右下角有「在控制台中显示详细信息」，点它能看到完整的 Git 输出，
> 比弹窗里那半句话有用得多——和上面「解释器不可用」那一节是同一个思路：**找原始报错，再逐个排除**。

---

## 几条规矩

1. **公开仓库不要放密码、token、API key。** 一旦提交，历史里就删不干净了。
2. **当天没学也提交一行** "今天休息"。连续记录比完美记录重要。
3. **代码跑通再提交**。半成品可以提交，但要写清楚哪里没完成。
4. 到第 30 天，把 `notes/` 里的内容挑几篇整理成一篇月度总结，这比日志本身更有价值。
