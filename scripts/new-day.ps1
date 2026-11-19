#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$Open
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$today = Get-Date -Format 'yyyy-MM-dd'

$noteDir  = Join-Path $repo 'notes'
$codeDir  = Join-Path $repo "python\$today"
$notePath = Join-Path $noteDir "$today.md"
$template = Join-Path $repo 'templates\daily.md'

foreach ($d in @($noteDir, $codeDir)) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }
}

if (-not (Test-Path $notePath)) {
    $content = Get-Content -Raw -Encoding UTF8 $template
    $content = $content.Replace('{{DATE}}', $today)
    [System.IO.File]::WriteAllText($notePath, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[OK] 已创建 notes\$today.md" -ForegroundColor Green
} else {
    Write-Host "[..] 今天已有日记：notes\$today.md" -ForegroundColor Yellow
}

Write-Host "[OK] 代码目录：python\$today\" -ForegroundColor Green
Write-Host ""
Write-Host "今天要做的：" -ForegroundColor Cyan
Write-Host "  1. 打开 notes\$today.md 写学习日志"
Write-Host "  2. 在 python\$today\ 里写代码"
Write-Host "     learn_01_xxx.py      跟教程写的"
Write-Host "     exercise_01_xxx.py   练习题"
Write-Host ""
Write-Host "写完后在 PyCharm 里按 Ctrl+K 提交，再按 Ctrl+Shift+K 推送。" -ForegroundColor Cyan

if ($Open) {
    $code = Get-Command code -ErrorAction SilentlyContinue
    if ($code) {
        & $code.Source $notePath | Out-Null
    } else {
        Start-Process $notePath
    }
}
