# pdf-compressor

Simple scripts to compress PDF files using [Ghostscript](https://www.ghostscript.com/). Available in both Bash (macOS/Linux) and PowerShell (Windows).

## Installing Ghostscript

### macOS

```bash
brew install ghostscript
```

### Ubuntu / Debian

```bash
sudo apt update && sudo apt install ghostscript
```

### Fedora / RHEL

```bash
sudo dnf install ghostscript
```

### Arch Linux

```bash
sudo pacman -S ghostscript
```

### Windows

Download the installer from https://www.ghostscript.com/releases/gsdnld.html and make sure to check **"Add to PATH"** during installation.

Or via a package manager:

```powershell
choco install ghostscript
# or
winget install --id ArtifexSoftware.GhostScript
```

### Verify installation

```bash
gs --version
```

On Windows (if not installed via Chocolatey):

```powershell
gswin64c --version
```

## Usage

### Bash (macOS / Linux)

```bash
./compress-pdf.sh <input.pdf> [quality]
```

### PowerShell (Windows)

```powershell
.\compress-pdf.ps1 <input.pdf> [-Quality <level>]
```

The compressed file is saved alongside the original with `- compressed` appended to the filename.

### Quality levels

| Level      | DPI | Use case                        |
|------------|-----|---------------------------------|
| `screen`   | 72  | Smallest size, low quality      |
| `ebook`    | 150 | Good balance for digital reading (default) |
| `printer`  | 300 | High quality for printing       |
| `prepress` | 300 | Production, color-preserving    |

### Examples

**Bash:**

```bash
./compress-pdf.sh report.pdf
./compress-pdf.sh report.pdf screen
```

**PowerShell:**

```powershell
.\compress-pdf.ps1 report.pdf
.\compress-pdf.ps1 report.pdf -Quality screen
```

### Sample output

```
Compressing: report.pdf
Quality:     /ebook
Output:      report - compressed.pdf

Original:    88MB
Compressed:  11MB
Reduction:   88%
```
