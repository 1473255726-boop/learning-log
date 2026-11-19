#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$User
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

function Ok($m)   { Write-Host "[OK] $m" -ForegroundColor Green }
function Info($m) { Write-Host $m -ForegroundColor Cyan }
function Warn($m) { Write-Host "[!] $m" -ForegroundColor Yellow }
function Bad($m)  { Write-Host "[X] $m" -ForegroundColor Red }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Bad "这台电脑上还没装 Git，装好之后才能继续。"
    Write-Host ""
    Info "接下来会打开下载页面，点页面上的 Download for Windows 即可。"
    Write-Host "安装时一路点 Next，最后点 Install。装完重启本窗口再运行一次。"
    Write-Host ""
    Start-Process "https://git-scm.com/download/win"
    Read-Host "装好之后按回车退出"
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   learning-log 一键初始化" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$existingRemote = git remote get-url origin 2>$null
if ($existingRemote -match 'github\.com[:/]([^/]+)/') {
    $User = $Matches[1]
    Ok "已从远程地址识别用户名：$User"
}

if (-not $User) {
    $User = (Read-Host "输入你的 GitHub 用户名").Trim()
}
if (-not $User) { Bad "用户名不能为空"; exit 1 }

if (-not (git config --global user.email 2>$null)) {
    $localEmail = git config --local user.email 2>$null
    if ($localEmail) {
        git config --global user.email $localEmail
        Ok "已把邮箱写入全局配置：$localEmail"
    } else {
        $email = (Read-Host "输入你的邮箱（注册 GitHub 用的那个）").Trim()
        git config --global user.email $email
        Ok "已设置邮箱"
    }
}

if (-not (git config --global user.name 2>$null)) {
    $localName = git config --local user.name 2>$null
    if ($localName) {
        git config --global user.name $localName
        Ok "已把名字写入全局配置：$localName"
    } else {
        $name = (Read-Host "输入你的显示名（拼音或英文名）").Trim()
        git config --global user.name $name
        Ok "已设置名字"
    }
}

git config --global init.defaultBranch main
git config --global core.quotepath false

if (-not (Test-Path (Join-Path $repo '.git'))) {
    git init | Out-Null
    Ok "已创建本地仓库"
} else {
    Ok "本地仓库已存在"
}
git branch -M main 2>$null | Out-Null

$url = "https://github.com/$User/learning-log.git"

if (-not (git remote 2>$null)) {
    git remote add origin $url
    Ok "已关联远程地址"
} else {
    $current = git remote get-url origin 2>$null
    if ($current -ne $url) {
        git remote set-url origin $url
        Warn "远程地址已更新为 $url"
    } else {
        Ok "远程地址已正确"
    }
}

git add -A
git commit -m "chore: 初始化学习日志" 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) { Ok "已生成首次提交" } else { Warn "没有新内容需要提交" }

function Test-RemoteExists([string]$u) {
    $old = $env:GIT_TERMINAL_PROMPT
    $env:GIT_TERMINAL_PROMPT = '0'
    try {
        git ls-remote $u 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    } finally {
        $env:GIT_TERMINAL_PROMPT = $old
    }
}

Write-Host ""
if (Test-RemoteExists $url) {
    Ok "GitHub 上已存在 $User/learning-log"
} else {
    Warn "GitHub 上还没有这个仓库，需要你先点几下创建。"
    Write-Host ""
    Info "马上会打开创建页面，仓库名已经替你填好了。"
    Write-Host "你只需要："
    Write-Host "   1. 确认 Repository name 是 learning-log"
    Write-Host "   2. 确保 Public 被选中"
    Write-Host "   3. 不要勾 Add a README file / .gitignore / license"
    Write-Host "   4. 点最下面的绿色按钮 Create repository" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "按回车打开创建页面"
    Start-Process "https://github.com/new?name=learning-log&visibility=public"
    Write-Host ""
    while (-not (Test-RemoteExists $url)) {
        $ans = Read-Host "创建好了就按回车检测（输入 q 退出）"
        if ($ans -eq 'q') {
            Bad "已退出。以后装好仓库，再运行一次 setup.cmd 即可。"
            exit 1
        }
        Start-Sleep -Milliseconds 800
    }
    Ok "检测到仓库 $User/learning-log"
}

Write-Host ""
Info "开始推送。如果弹出浏览器让你登录 GitHub，点授权即可，只需一次。"
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Bad "推送失败。最常见的原因是创建仓库时勾了 Add a README file。"
    Write-Host "   解决办法：去 GitHub 删掉这个仓库，重新创建时什么都不要勾，" -ForegroundColor Yellow
    Write-Host "   然后再次运行 setup.cmd。" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Ok "全部完成！"
Write-Host "打开看看：https://github.com/$User/learning-log" -ForegroundColor Cyan
