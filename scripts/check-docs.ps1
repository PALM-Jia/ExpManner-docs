$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

if (Test-Path ".\.venv\Scripts\python.exe") {
    $python = ".\.venv\Scripts\python.exe"
} else {
    $python = "python"
}

& $python -m mkdocs build --strict
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

git diff --check
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$scanFiles = @(
    "README.md",
    "mkdocs.yml",
    ".github/pull_request_template.md"
) + (Get-ChildItem -Path "docs" -Recurse -File -Filter "*.md" | ForEach-Object { $_.FullName })

$forbiddenPhrases = @(
    "Status:",
    "Getting Started",
    "Installation",
    "Concepts",
    "Model Interface",
    "Dataset Guide",
    "Result Management",
    "First Benchmark",
    "Custom Model",
    "Examples",
    "API Reference",
    "Contributing",
    "Citation",
    "Security",
    "Public guide",
    "Minimum usable"
)

$sensitivePatterns = @(
    "C:\\Users\\",
    "MATLAB Drive",
    "gho_[A-Za-z0-9_]+",
    "BEGIN [A-Z ]*PRIVATE KEY",
    "api[_-]?key\s*=",
    "access[_-]?key\s*=",
    "password\s*=",
    "token\s*="
)

$violations = New-Object System.Collections.Generic.List[string]
foreach ($file in $scanFiles) {
    $path = [string]$file
    $content = Get-Content -Raw -LiteralPath $path
    foreach ($phrase in $forbiddenPhrases) {
        if ($content.Contains($phrase)) {
            $violations.Add("${path}: contains forbidden English UI phrase '$phrase'")
        }
    }
    foreach ($pattern in $sensitivePatterns) {
        if ($content -match $pattern) {
            $violations.Add("${path}: matches sensitive pattern '$pattern'")
        }
    }
}

if ($violations.Count -gt 0) {
    $violations | ForEach-Object { Write-Error $_ }
    exit 1
}

$linkErrors = New-Object System.Collections.Generic.List[string]
$markdownFiles = Get-ChildItem -Path "docs" -Recurse -File -Filter "*.md"
foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    $matches = [regex]::Matches($content, "\[[^\]]+\]\(([^)]+)\)")
    foreach ($match in $matches) {
        $target = $match.Groups[1].Value.Trim()
        if ($target -match "^(https?://|mailto:|#)") {
            continue
        }
        $withoutAnchor = ($target -split "#", 2)[0]
        if ($withoutAnchor -eq "" -or $withoutAnchor -match "^<") {
            continue
        }
        $resolved = Resolve-Path -LiteralPath (Join-Path $file.DirectoryName $withoutAnchor) -ErrorAction SilentlyContinue
        if (-not $resolved) {
            $linkErrors.Add("$($file.FullName): broken local link '$target'")
        }
    }
}

if ($linkErrors.Count -gt 0) {
    $linkErrors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Documentation checks passed."
