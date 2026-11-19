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
function IsToken($t) { return ($t -match '^(ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+)$') }

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
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   最后一步：拿到令牌 -> 推送" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "现在会自动打开 GitHub 令牌页面。" -ForegroundColor Cyan
Write-Host ""
Write-Host "  在网页上：" -ForegroundColor Yellow
Write-Host "    1. 滚到最底部，点绿色按钮  Generate token"
Write-Host "    2. 页面顶部会出现一串 ghp_ 开头的字符"
Write-Host "    3. 点那串字符右边的【复制图标】（两个方块叠在一起）"
Write-Host ""
Write-Host "  回到本窗口：" -ForegroundColor Yellow
Write-Host "    4. 按 Ctrl+V 粘贴，然后回车"
Write-Host ""
Write-Host "  （剪贴板里有令牌的话，直接回车也可以）" -ForegroundColor DarkGray
Write-Host ""

Start-Process $url

$token = $null
for ($i = 1; $i -le 5; $i++) {
    Write-Host ""
    $answer = Read-Host "粘贴令牌后回车（第 $i 次）"
    $answer = ([string]$answer).Trim()

    if (IsToken $answer) { $token = $answer; break }

    $clip = ''
    try { $clip = ([string](Get-Clipboard -Raw)).Trim() } catch { }
    if (IsToken $clip) {
        $token = $clip
        Ok "已从剪贴板读到令牌"
        break
    }

    if ($answer) {
        Bad "你输入的内容不是令牌。开头是：[$($answer.Substring(0,[Math]::Min(15,$answer.Length)))]"
    } else {
        Bad "没有收到内容。"
    }
    Write-Host "  令牌的样子是：ghp_ 开头，后面一长串字母数字，大约 40 位。" -ForegroundColor DarkGray
    Write-Host "  如果页面已经关了，令牌就找不回来了，需要重新点 Generate token。" -ForegroundColor DarkGray
}

if (-not $token) {
    Write-Host ""
    Bad "多次都没有拿到令牌，已退出。重新运行本脚本即可再试。"
    exit 1
}

Ok "拿到令牌（$($token.Substring(0,4))...，共 $($token.Length) 位）"

$payload = "protocol=https`nhost=github.com`nusername=$user`npassword=$token`n`n"
$payload | git -C $repo -c credential.helper=wincred credential approve
Ok "令牌已保存到 Windows 凭据管理器"

Write-Host ""
Info "正在推送..."
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
