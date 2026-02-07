#!/usr/bin/env bash
set -euo pipefail

QUALITY="${2:-ebook}"
VALID_QUALITIES="screen ebook printer prepress"

usage() {
    cat <<EOF
Usage: $(basename "$0") <input.pdf> [quality]

Compress a PDF using Ghostscript.

Quality levels:
  screen    - 72 dpi  (smallest, low quality)
  ebook     - 150 dpi (default, good for digital reading)
  printer   - 300 dpi (high quality for printing)
  prepress  - 300 dpi (production, color-preserving)

Output is saved alongside the input file with " - compressed" appended.
EOF
    exit 1
}

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

INPUT="$1"

if [[ ! -f "$INPUT" ]]; then
    echo "Error: file not found: $INPUT" >&2
    exit 1
fi

if ! echo "$VALID_QUALITIES" | grep -qw "$QUALITY"; then
    echo "Error: invalid quality '$QUALITY'. Choose from: $VALID_QUALITIES" >&2
    exit 1
fi

DIR="$(dirname "$INPUT")"
BASE="$(basename "$INPUT" .pdf)"
OUTPUT="${DIR}/${BASE} - compressed.pdf"

ORIGINAL_SIZE=$(stat --printf="%s" "$INPUT" 2>/dev/null || stat -f%z "$INPUT")

echo "Compressing: $INPUT"
echo "Quality:     /$QUALITY"
echo "Output:      $OUTPUT"
echo ""

gs -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS="/$QUALITY" \
   -dNOPAUSE -dQUIET -dBATCH \
   -sOutputFile="$OUTPUT" \
   "$INPUT"

COMPRESSED_SIZE=$(stat --printf="%s" "$OUTPUT" 2>/dev/null || stat -f%z "$OUTPUT")
RATIO=$(awk "BEGIN { printf \"%.0f\", (1 - $COMPRESSED_SIZE / $ORIGINAL_SIZE) * 100 }")

echo "Original:    $(numfmt --to=iec "$ORIGINAL_SIZE")B"
echo "Compressed:  $(numfmt --to=iec "$COMPRESSED_SIZE")B"
echo "Reduction:   ${RATIO}%"
