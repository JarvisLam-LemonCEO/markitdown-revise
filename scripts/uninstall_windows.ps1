$ErrorActionPreference = "Stop"

$InstallRoot = if ($env:MARKITDOWN_HOME) { $env:MARKITDOWN_HOME } else { Join-Path $env:LOCALAPPDATA "MarkItDown-Python314" }
$LauncherDir = Join-Path $env:LOCALAPPDATA "Programs\MarkItDown\bin"
$Launcher = Join-Path $LauncherDir "markitdown.cmd"

function Write-Info([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host "OK: $Message" -ForegroundColor Green
}

function Remove-UserPath([string]$Directory) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ([string]::IsNullOrWhiteSpace($userPath)) {
        return
    }

    $entries = @($userPath -split ";" | Where-Object {
        $_ -and $_.Trim() -and ($_.TrimEnd("\") -ine $Directory.TrimEnd("\"))
    })
    [Environment]::SetEnvironmentVariable("Path", ($entries -join ";"), "User")
}

try {
    if (Test-Path -LiteralPath $Launcher) {
        $content = Get-Content -LiteralPath $Launcher -Raw -ErrorAction SilentlyContinue
        if ($content -match "MARKITDOWN_PYTHON314_LAUNCHER") {
            Write-Info "Removing the global markitdown command..."
            Remove-Item -LiteralPath $Launcher -Force
        }
    }

    if (Test-Path -LiteralPath $InstallRoot) {
        Write-Info "Removing the private MarkItDown environment..."
        Remove-Item -LiteralPath $InstallRoot -Recurse -Force
    }

    Write-Info "Removing the MarkItDown launcher directory from your user PATH..."
    Remove-UserPath $LauncherDir

    if ((Test-Path -LiteralPath $LauncherDir) -and -not (Get-ChildItem -LiteralPath $LauncherDir -Force | Select-Object -First 1)) {
        Remove-Item -LiteralPath $LauncherDir -Force
    }

    Write-Ok "MarkItDown was removed. Python 3.14 itself was left installed."
    Write-Host "Open a new Command Prompt or PowerShell window to refresh PATH."
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
