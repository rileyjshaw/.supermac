#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: deheic [N]
  Convert most recent N .heic files in ~/Downloads to optimized .jpg (mozjpeg q=90), delete originals.
  Defaults to N=1.
EOF
}

case "${1-}" in
  -h|--help) usage; exit 0 ;;
  "") n=1 ;;
  *) n="$1" ;;
esac

[[ "$n" =~ ^[0-9]+$ ]] || { echo "N must be a positive integer" >&2; exit 2; }

command -v magick >/dev/null || { echo "need imagemagick (brew install imagemagick)" >&2; exit 127; }
command -v cjpeg  >/dev/null || { echo "need mozjpeg (brew install mozjpeg)" >&2; exit 127; }

dir="$HOME/Downloads"
shopt -s nullglob nocaseglob

mapfile -t files < <(ls -1t "$dir"/*.heic 2>/dev/null | head -n "$n" || true)
(( ${#files[@]} )) || { echo "no .heic files found"; exit 1; }

for f in "${files[@]}"; do
  base="${f%.*}"
  tmp="${base}.tmp.jpg"
  out="${base}.jpg"

  # HEIC -> JPEG (high quality source)
  magick "$f" -quality 100 "$tmp"

  # JPEG -> optimized JPEG (lossy mozjpeg)
  cjpeg -quality 90 -progressive -optimize -outfile "$out" "$tmp"

  rm -f -- "$tmp" "$f"
  echo "Converted: $(basename "$f") -> $(basename "$out")"
done
