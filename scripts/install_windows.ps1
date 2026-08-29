$ErrorActionPreference = "Stop"

$InstallRoot = if ($env:MARKITDOWN_HOME) { $env:MARKITDOWN_HOME } else { Join-Path $env:LOCALAPPDATA "MarkItDown-Python314" }
$VenvDir = Join-Path $InstallRoot "venv"
$StateDir = Join-Path $InstallRoot "state"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$PackageDir = Join-Path $RepoRoot "packages\markitdown"
$LauncherDir = Join-Path $env:LOCALAPPDATA "Programs\MarkItDown\bin"
$Launcher = Join-Path $LauncherDir "markitdown.cmd"

function Write-Info([string]$Message) {
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Ok([string]$Message) {
    Write-Host "OK: $Message" -ForegroundColor Green
}

function Write-Warn([string]$Message) {
    Write-Host "WARNING: $Message" -ForegroundColor Yellow
}

function Fail([string]$Message) {
    throw $Message
}

function Test-Python314([string]$PythonExe) {
    if (-not $PythonExe -or -not (Test-Path -LiteralPath $PythonExe)) {
        return $false
    }

    try {
        & $PythonExe -c "import sys; raise SystemExit(0 if sys.version_info[:2] == (3, 14) else 1)" 2>$null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
}

function Resolve-PythonFromCommand([string]$CommandName, [string[]]$Arguments) {
    $command = Get-Command $CommandName -ErrorAction SilentlyContinue
    if (-not $command) {
        return $null
    }

    try {
        $output = & $command.Source @Arguments 2>$null
        if ($LASTEXITCODE -ne 0) {
            return $null
        }
        $candidate = ($output | Select-Object -First 1).Trim()
        if (Test-Python314 $candidate) {
            return $candidate
        }
    }
    catch {
        return $null
    }

    return $null
}

function Find-Python314 {
    if ($env:MARKITDOWN_PYTHON) {
        if (Test-Python314 $env:MARKITDOWN_PYTHON) {
            return (Resolve-Path -LiteralPath $env:MARKITDOWN_PYTHON).Path
        }
        Fail "MARKITDOWN_PYTHON is set, but it is not a Python 3.14 interpreter: $env:MARKITDOWN_PYTHON"
    }

    # Python Install Manager / Python launcher.
    $candidate = Resolve-PythonFromCommand "py" @("-3.14", "-c", "import sys; print(sys.executable)")
    if ($candidate) { return $candidate }

    # Common command aliases.
    foreach ($name in @("python3.14", "python")) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd -and (Test-Python314 $cmd.Source)) {
            return $cmd.Source
        }
    }

    # Common per-user locations used by the traditional CPython installer.
    $commonCandidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Python\Python314\python.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\Python\Python314-arm64\python.exe"),
        (Join-Path $env:LOCALAPPDATA "Python\bin\python3.14.exe")
    )

    foreach ($path in $commonCandidates) {
        if (Test-Python314 $path) {
            return $path
        }
    }

    return $null
}

function Install-Python314 {
    $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
    if (-not $winget) {
        return $false
    }

    Write-Info "Python 3.14 was not found. Installing Python 3.14 with WinGet..."
    & $winget.Source install --id Python.Python.3.14 -e --scope user --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warn "WinGet could not install Python 3.14 automatically."
        return $false
    }

    return $true
}

function Add-UserPath([string]$Directory) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($null -eq $userPath) { $userPath = "" }

    $entries = @($userPath -split ";" | Where-Object { $_ -and $_.Trim() })
    $alreadyPresent = $entries | Where-Object { $_.TrimEnd("\") -ieq $Directory.TrimEnd("\") }

    if (-not $alreadyPresent) {
        Write-Info "Adding $Directory to your user PATH..."
        $newPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $Directory } else { "$userPath;$Directory" }
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    }

    if (-not (($env:Path -split ";") | Where-Object { $_.TrimEnd("\") -ieq $Directory.TrimEnd("\") })) {
        $env:Path = "$env:Path;$Directory"
    }
}

try {
    if (-not (Test-Path -LiteralPath (Join-Path $PackageDir "pyproject.toml"))) {
        Fail "Could not find packages\markitdown\pyproject.toml. Run this installer from the complete repository."
    }

    $Python314 = Find-Python314
    if (-not $Python314) {
        if (Install-Python314) {
            $Python314 = Find-Python314
        }
    }

    if (-not $Python314) {
        Fail "Python 3.14 is required and was not found. Install Python 3.14 from python.org, then run Install MarkItDown Windows.cmd again."
    }

    $version = & $Python314 --version 2>&1
    Write-Ok "Using $version at $Python314"

    Write-Info "Creating the private application environment..."
    New-Item -ItemType Directory -Force -Path $InstallRoot, $StateDir | Out-Null
    if (Test-Path -LiteralPath $VenvDir) {
        Remove-Item -LiteralPath $VenvDir -Recurse -Force
    }
    & $Python314 -m venv $VenvDir
    if ($LASTEXITCODE -ne 0) { Fail "Could not create the Python environment." }

    $VenvPython = Join-Path $VenvDir "Scripts\python.exe"
    if (-not (Test-Path -LiteralPath $VenvPython)) {
        Fail "The Python environment was created, but python.exe was not found."
    }

    Write-Info "Updating Python packaging tools..."
    & $VenvPython -m pip install --upgrade pip setuptools wheel
    if ($LASTEXITCODE -ne 0) { Fail "Could not update pip/setuptools/wheel." }

    Write-Info "Installing MarkItDown and all optional converters..."
    $PackageSpec = "${PackageDir}[all]"
    & $VenvPython -m pip install --upgrade $PackageSpec
    if ($LASTEXITCODE -ne 0) { Fail "Could not install MarkItDown." }

    Write-Info "Installing the global markitdown command..."
    New-Item -ItemType Directory -Force -Path $LauncherDir | Out-Null
    $launcherContent = @"
@echo off
REM MARKITDOWN_PYTHON314_LAUNCHER
"$VenvPython" -m markitdown %*
"@
    Set-Content -LiteralPath $Launcher -Value $launcherContent -Encoding ASCII

    Set-Content -LiteralPath (Join-Path $StateDir "launcher-path.txt") -Value $Launcher -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $StateDir "source-path.txt") -Value $RepoRoot -Encoding UTF8

    Add-UserPath $LauncherDir

    Write-Info "Running a self-test..."
    & $Launcher --help | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail "The markitdown self-test failed." }

    Write-Ok "MarkItDown installed successfully."
    Write-Host ""
    Write-Host "Global command: $Launcher"
    Write-Host "Private environment: $VenvDir"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host '  markitdown "%USERPROFILE%\Downloads\file.pdf" -o "%USERPROFILE%\Downloads\read.md"'
    Write-Host "  markitdown --help"
    Write-Host ""
    Write-Host "The command is available in this installer window now. Open a new Command Prompt or PowerShell window before using it elsewhere."
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
