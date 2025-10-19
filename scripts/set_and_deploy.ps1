Param(
  [string]$Repo = "MI804-png/webprogramming_with_lilla",
  [string]$Branch = "main",
  [string]$GitHubToken = ""
)

function Require-Tool($name, $url) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    Write-Error "$name is not installed. Install from $url"
    exit 1
  }
}

Require-Tool python "https://www.python.org/downloads/"
Require-Tool gh "https://cli.github.com/"

if (-not $GitHubToken) {
  $GitHubToken = Read-Host "GitHub Personal Access Token (classic, repo scope)"
}

$secrets = @(
  'SSH_HOST','SSH_PORT','SSH_USER','DB_HOST','DB_PORT','DB_USER','DB_PASS','DB_NAME','SESSION_SECRET','APP_PORT'
)

$values = @{}
foreach ($s in $secrets) {
  if ($s -eq 'DB_PASS') {
    $values[$s] = Read-Host -AsSecureString "$s" | ForEach-Object { [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($_)) }
  } else {
    $values[$s] = Read-Host "$s"
  }
}

$env:GITHUB_TOKEN = $GitHubToken
Set-Location -Path (Split-Path $MyInvocation.MyCommand.Path)

foreach ($k in $values.Keys) {
  if ($values[$k]) {
    Write-Host "Setting secret $k" -ForegroundColor Yellow
    python .\set_repo_secret.py $Repo $k "$($values[$k])"
  }
}

Write-Host "Triggering deploy and docs workflows" -ForegroundColor Cyan
gh workflow run deploy.yml --repo $Repo -f branch=$Branch
gh workflow run docs-pdf.yml --repo $Repo

Write-Host "Done. Monitor GitHub Actions for progress." -ForegroundColor Green
