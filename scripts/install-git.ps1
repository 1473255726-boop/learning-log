#Requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Ok($m)   { Write-Host "[OK] $m" -ForegroundColor Green }
function Info($m) { Write-Host $m -ForegroundColor Cyan }
function Bad($m)  { Write-Host "[X] $m" -ForegroundColor Red }

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   下载并安装 Git" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

if (Get-Command git -ErrorAction SilentlyContinue) {
    Ok "Git 已经装好了：$((git --version))"
    Write-Host ""
    Info "不需要再装。直接运行 setup.cmd 就行。"
    exit 0
}

$url = $null
$size = 0

Info "正在查询最新版本..."
try {
    $r = Invoke-RestMethod -Uri 'https://api.github.com/repos/git-for-windows/git/releases/latest' `
        -Headers @{ 'User-Agent' = 'learning-log-setup' } -TimeoutSec 60
    $asset = $r.assets | Where-Object { $_.name -match '^Git-[\d\.]+-64-bit\.exe$' } | Select-Object -First 1
    if ($asset) {
        $url = $asset.browser_download_url
        $size = $asset.size
        Ok "找到版本 $($r.tag_name)"
    }
} catch {
    Write-Host "查询失败：$($_.Exception.Message)" -ForegroundColor DarkGray
}

if (-not $url) {
    Bad "自动获取下载地址失败（可能是网络问题）。"
    Write-Host ""
    Info "改用浏览器手动下载，马上打开页面："
    Start-Process "https://git-scm.com/download/win"
    Write-Host "下载完成后双击安装包，一路点 Next。"
    exit 1
}

$out = Join-Path $env:TEMP $asset.name
if (Test-Path $out) { Remove-Item $out -Force }

Write-Host ""
Info "正在下载：$($asset.name)（约 $([math]::Round($size/1MB)) MB）"
Write-Host "文件较大，可能需要一到两分钟，请不要关闭窗口。" -ForegroundColor DarkGray
Write-Host ""

try {
    Invoke-WebRequest -Uri $url -OutFile $out -TimeoutSec 900
} catch {
    Bad "下载失败：$($_.Exception.Message)"
    Write-Host ""
    Info "改用浏览器手动下载："
    Start-Process "https://git-scm.com/download/win"
    exit 1
}

$actual = (Get-Item $out).Length
if ($size -gt 0 -and $actual -lt ($size * 0.9)) {
    Bad "下载的文件不完整（$([math]::Round($actual/1MB)) MB / $([math]::Round($size/1MB)) MB）"
    exit 1
}
Ok "下载完成"

Write-Host ""
Info "正在打开安装程序..."
Write-Host "接下来在弹出的窗口里一路点 Next，最后点 Install，然后点 Finish。" -ForegroundColor Yellow
Write-Host ""

Start-Process -FilePath $out

Write-Host "安装完成后：" -ForegroundColor Cyan
Write-Host "  1. 关掉本窗口"
Write-Host "  2. 关掉 PyCharm（如果开着）"
Write-Host "  3. 双击 scripts\setup.cmd"
exit 0
