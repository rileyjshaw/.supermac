# Define deheic function (source this file from .functions or bash_profile)
deheic() {
  local usage
  usage() {
    cat <<'EOF'
Usage: deheic [N]
  Convert most recent N .heic files in ~/Downloads to optimized .jpg (mozjpeg q=90), delete originals.
  Defaults to N=1.
EOF
  }

  case "${1-}" in
    -h|--help) usage; return 0 ;;
    "") n=1 ;;
    *) n="$1" ;;
  esac

  [[ "$n" =~ ^[0-9]+$ ]] || { echo "N must be a positive integer" >&2; return 2; }

  command -v magick >/dev/null || { echo "need imagemagick (brew install imagemagick)" >&2; return 127; }
  command -v cjpeg  >/dev/null || { echo "need mozjpeg (brew install mozjpeg)" >&2; return 127; }

  local dir="$HOME/Downloads" f base tmp out
  local -a files
  shopt -s nullglob nocaseglob

  mapfile -t files < <(ls -1t "$dir"/*.heic 2>/dev/null | head -n "$n" || true)
  (( ${#files[@]} )) || { echo "no .heic files found"; return 1; }

  for f in "${files[@]}"; do
    base="${f%.*}"
    out="${base}.jpg"

    magick "$f" ppm:- | cjpeg -quality 82 -progressive -optimize > "$out"

    if [[ ! -s "$out" ]]; then
      echo "Conversion failed: $(basename "$f")" >&2
      return 1
    fi
    rm -f -- "$f"
    echo "Converted: $(basename "$f") -> $(basename "$out")"
  done
}
