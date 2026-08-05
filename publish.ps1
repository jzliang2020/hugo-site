param(
    [string]$Message,
    [switch]$Draft
)

$ErrorActionPreference = "Stop"

function Step($Text) {
    Write-Host ""
    Write-Host "==> $Text" -ForegroundColor Cyan
}

function Check-Tools {
    if (-not (Get-Command hugo -ErrorAction SilentlyContinue)) {
        throw "Hugo was not found in PATH. Install Hugo or reopen PowerShell after adding it to PATH."
    }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git was not found in PATH."
    }
}

function Build-Site {
    param([switch]$IncludeDraft)

    Step "Build site"
    $hugoArgs = @("--cleanDestinationDir", "--minify")
    if ($IncludeDraft) {
        $hugoArgs += "-D"
    }

    hugo @hugoArgs

    if (Test-Path ".\CNAME") {
        Copy-Item -LiteralPath ".\CNAME" -Destination ".\docs\CNAME" -Force
    }

    Step "Published content"
    hugo list all | Where-Object { $_ -notmatch "draft:true" }
}

function Preview-Site {
    param([switch]$IncludeDraft)

    Step "Start preview server"
    $hugoArgs = @("server", "--disableFastRender")
    if ($IncludeDraft) {
        $hugoArgs += "-D"
    }

    Write-Host "Open http://localhost:1313/" -ForegroundColor Green
    hugo @hugoArgs
}

function Commit-And-Push {
    param([string]$CommitMessage)

    if (-not $CommitMessage) {
        $CommitMessage = "$(Get-Date -Format 'yyyy-MM-dd') update"
    }

    Step "Git status"
    git status --short

    Step "Commit changes"
    git add .
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "No changes to commit." -ForegroundColor Yellow
    }
    else {
        git commit -m $CommitMessage
    }

    Step "Push to origin main"
    git push origin main
}

function Show-Menu {
    Write-Host ""
    Write-Host "Hugo Blog Helper" -ForegroundColor Green
    Write-Host "1. Preview draft site        hugo server -D"
    Write-Host "2. Build production site     hugo --cleanDestinationDir --minify"
    Write-Host "3. Build, commit and push"
    Write-Host "4. Git status"
    Write-Host "5. Preview production site   hugo server"
    Write-Host "0. Exit"
    Write-Host ""
}

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repo
Check-Tools

if ($Message -or $Draft) {
    Build-Site -IncludeDraft:$Draft
    Commit-And-Push -CommitMessage $Message
    exit 0
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Choose"

    switch ($choice) {
        "1" {
            Preview-Site -IncludeDraft
        }
        "2" {
            Build-Site
            Read-Host "Done. Press Enter to continue"
        }
        "3" {
            $msg = Read-Host "Commit message (press Enter for default)"
            Build-Site
            Commit-And-Push -CommitMessage $msg
            Read-Host "Done. Press Enter to continue"
        }
        "4" {
            Step "Git status"
            git status --short
            Read-Host "Press Enter to continue"
        }
        "5" {
            Preview-Site
        }
        "0" {
            exit 0
        }
        default {
            Write-Host "Unknown choice: $choice" -ForegroundColor Yellow
        }
    }
}
