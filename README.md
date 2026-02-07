# pdf-compressor

A simple Bash script that compresses PDF files using [Ghostscript](https://www.ghostscript.com/).

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

### Verify installation

```bash
gs --version
```

You should see a version number like `10.02.1`. If you get `command not found`, ensure Ghostscript is on your PATH.

## Usage

```bash
./compress-pdf.sh <input.pdf> [quality]
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

```bash
# Compress with default ebook quality (150 dpi)
./compress-pdf.sh report.pdf

# Compress for minimal file size
./compress-pdf.sh report.pdf screen

# Compress for print
./compress-pdf.sh report.pdf printer
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
