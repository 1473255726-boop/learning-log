#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repo = Split-Path -Parent $PSScriptRoot
$user = '1473255726-boop'
$url  = 'https://github.com/settings/tokens/new?scopes=repo&description=learning-log'

function Ok($m)   { Write-Host "[OK] $m" -ForegroundColor Green }
function Info($m) { Write-Host $m -ForegroundColor Cyan }
function Bad($m)  { Write-Host "[X] $m" -ForegroundColor Red }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Bad "找不到 Git，请先安装。"
    exit 1
}

git -C $repo rev-parse --verify origin/main 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Ok "已经推送过了，不需要再操作。"
    Write-Host "https://github.com/$user/learning-log" -ForegroundColor Cyan
    exit 0
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   连接 GitHub 并推送" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Info "第 1 步：马上自动打开 GitHub 的令牌页面"
Info "第 2 步：滚到页面底部，点绿色 Generate token"
Info "第 3 步：生成后点令牌右边的复制图标"
Info "第 4 步：回到这个窗口，按一次回车"
Write-Host ""
Start-Process $url
Write-Host ""
Read-Host "复制好令牌后，按回车"

$token = ''
for ($i = 1; $i -le 5; $i++) {
    $clip = ''
    try { $clip = [string](Get-Clipboard -Raw) } catch { }
    $token = $clip.Trim()

    if ($token -match '^(ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+)$') {
        break
    }

    $head = ''
    if ($token.Length -gt 12) { $head = $token.Substring(0, 12) + '...' } else { $head = $token }
    Bad "剪贴板里没有令牌。当前内容开头是：[$head]"
    $ans = Read-Host "请在网页上点一次复制图标，然后按回车重试（输入 q 退出）"
    if ($ans -eq 'q') { exit 1 }
}

if ($token -notmatch '^(ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+)$') {
    Bad "多次读取失败，已退出。"
    exit 1
}

Ok "已从剪贴板读到令牌（长度 $($token.Length)）"

$payload = "protocol=https`nhost=github.com`nusername=$user`npassword=$token`n`n"
$payload | git -C $repo -c credential.helper=wincred credential approve
Ok "令牌已保存到 Windows 凭据管理器（以后不用再登录）"

Write-Host ""
Info "开始推送..."
Write-Host ""
git -C $repo push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Ok "推送成功！"
    Write-Host "https://github.com/$user/learning-log" -ForegroundColor Cyan
} else {
    Write-Host ""
    Bad "推送失败，请把上面的输出整段发给我。"
}
