# Python 学习代码

每天一个文件夹，文件夹名就是日期。当天学的、练的全放进去。

```
python/
└─ 2026-11-20/
   ├─ learn_01_hello.py
   ├─ learn_02_variables.py
   └─ exercise_01_temperature.py
```

## 命名约定

| 前缀 | 用途 | 例子 |
|---|---|---|
| `learn_序号_主题.py` | 跟着教程/书写的代码 | `learn_03_loops.py` |
| `exercise_序号_题目.py` | 练习题 | `exercise_02_fizzbuzz.py` |
| `note.py` | 临时试验、想到就写 | `note.py` |

规则只有一条：**一个文件只放一个主题**。这样三个月后回看还能看懂。

## 文件头写一行注释

```python
# 2026-11-20 练习：for 循环 + 累加
```

日期 + 在练什么。以后你自己就是靠这行回忆起来的。

## 不要提交的东西

- 虚拟环境目录 `.venv/`（已在 `.gitignore` 里排除）
- `__pycache__/`（同上）
- 密码、token、API key —— 永远不要写进代码再提交
