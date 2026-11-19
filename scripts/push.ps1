#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$Message
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[X] 找不到 Git。请先安装：winget install --id Git.Git -e" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path (Join-Path $repo '.git'))) {
    Write-Host "[X] 这个文件夹还不是 Git 仓库，请先完成一次性配置（见 README）。" -ForegroundColor Red
    exit 1
}

$today = Get-Date -Format 'yyyy-MM-dd'
if (-not $Message) { $Message = "log: $today" }

git add -A
$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Host "[..] 没有可提交的改动。今天写了吗？" -ForegroundColor Yellow
    exit 0
}

Write-Host "将要提交的文件："
$staged | ForEach-Object { Write-Host "   $_" }

git commit -m $Message
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

git push
if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] 推送失败，检查网络或 GitHub 登录状态。" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] 已推送到 GitHub：$Message" -ForegroundColor Green
