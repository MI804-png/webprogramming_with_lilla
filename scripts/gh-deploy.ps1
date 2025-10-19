Param(
    [string]$Repo = "MI804-png/webprogramming_with_lilla",
    [string]$Branch = "main"
)

function Require-GhCLI {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Error "GitHub CLI (gh) is not installed. Install from https://cli.github.com/ and login with 'gh auth login'."
        exit 1
    }
}

Require-GhCLI

Write-Host "Setting GitHub Actions secrets for repo: $Repo" -ForegroundColor Cyan

$secrets = @{
    SSH_HOST       = Read-Host "SSH_HOST (server IP/host)"
    SSH_PORT       = Read-Host "SSH_PORT (default 22)"
    SSH_USER       = Read-Host "SSH_USER (Linux username)"
    DB_HOST        = Read-Host "DB_HOST (default 127.0.0.1)"
    DB_PORT        = Read-Host "DB_PORT (default 3306)"
    DB_USER        = Read-Host "DB_USER"
    DB_PASS        = Read-Host -AsSecureString "DB_PASS (input hidden)" | ForEach-Object { [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)) }
    DB_NAME        = Read-Host "DB_NAME (default company_db)"
    SESSION_SECRET = Read-Host "SESSION_SECRET (long random)"
    APP_PORT       = Read-Host "APP_PORT (default 3000)"
}

foreach ($k in $secrets.Keys) {
    $v = $secrets[$k]
    if ([string]::IsNullOrWhiteSpace($v)) { continue }
    Write-Host "Setting secret $k" -ForegroundColor Yellow
    echo $v | gh secret set $k --repo $Repo | Out-Null
}

Write-Host "Triggering deploy workflow on branch $Branch" -ForegroundColor Cyan
gh workflow run deploy.yml --repo $Repo -f branch=$Branch

Write-Host "Triggering docs PDF build" -ForegroundColor Cyan
gh workflow run docs-pdf.yml --repo $Repo

Write-Host "Done. Monitor workflows in GitHub Actions for progress." -ForegroundColor Green
