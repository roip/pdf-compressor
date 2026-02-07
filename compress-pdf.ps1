<#
.SYNOPSIS
    Compress a PDF file using Ghostscript.

.DESCRIPTION
    Wraps Ghostscript to compress PDFs with configurable quality levels.
    Output is saved alongside the input file with " - compressed" appended.

.PARAMETER InputFile
    Path to the PDF file to compress.

.PARAMETER Quality
    Compression quality level: screen (72 dpi), ebook (150 dpi, default),
    printer (300 dpi), or prepress (300 dpi, color-preserving).

.EXAMPLE
    .\compress-pdf.ps1 report.pdf
    .\compress-pdf.ps1 report.pdf -Quality screen
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$InputFile,

    [Parameter(Position = 1)]
    [ValidateSet("screen", "ebook", "printer", "prepress")]
    [string]$Quality = "ebook"
)

$ErrorActionPreference = "Stop"

# Resolve to absolute path
$InputFile = Resolve-Path $InputFile

if (-not (Test-Path $InputFile)) {
    Write-Error "File not found: $InputFile"
    exit 1
}

# Find Ghostscript executable
$gsExe = $null
foreach ($candidate in @("gswin64c", "gswin32c", "gs")) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
        $gsExe = $candidate
        break
    }
}

if (-not $gsExe) {
    Write-Error @"
Ghostscript not found. Install it via one of:
  choco install ghostscript
  winget install --id ArtifexSoftware.GhostScript
  https://www.ghostscript.com/releases/gsdnld.html
"@
    exit 1
}

$dir = Split-Path $InputFile
$base = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
$outputFile = Join-Path $dir "$base - compressed.pdf"

$originalSize = (Get-Item $InputFile).Length

Write-Host "Compressing: $InputFile"
Write-Host "Quality:     /$Quality"
Write-Host "Output:      $outputFile"
Write-Host ""

$gsArgs = @(
    "-sDEVICE=pdfwrite",
    "-dCompatibilityLevel=1.4",
    "-dPDFSETTINGS=/$Quality",
    "-dNOPAUSE", "-dBATCH",
    "-sOutputFile=$outputFile",
    $InputFile.ToString()
)

Write-Host "Running: $gsExe $($gsArgs -join ' ')"
Write-Host ""

& $gsExe $gsArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "Ghostscript failed with exit code $LASTEXITCODE"
    exit 1
}

$compressedSize = (Get-Item $outputFile).Length
$reduction = [math]::Round((1 - $compressedSize / $originalSize) * 100)

function Format-FileSize($bytes) {
    if ($bytes -ge 1GB) { return "{0:N1}GB" -f ($bytes / 1GB) }
    if ($bytes -ge 1MB) { return "{0:N0}MB" -f ($bytes / 1MB) }
    if ($bytes -ge 1KB) { return "{0:N0}KB" -f ($bytes / 1KB) }
    return "${bytes}B"
}

Write-Host "Original:    $(Format-FileSize $originalSize)"
Write-Host "Compressed:  $(Format-FileSize $compressedSize)"
Write-Host "Reduction:   ${reduction}%"
