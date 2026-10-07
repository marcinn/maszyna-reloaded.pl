#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly DEFAULT_LOGO="${SCRIPT_DIR}/assets/maszyna-reloaded-logo.png"
readonly LABEL_FONT="${SCRIPT_DIR}/assets/fonts/Kanit-SemiBold.ttf"
readonly BUILD_FONT="${SCRIPT_DIR}/assets/fonts/Kanit-Bold.ttf"

usage() {
  cat <<'EOF'
Dodaje w lewym dolnym rogu logo MaSzyna Reloaded i numer wydania.

Użycie:
  scripts/stamp-release-image.sh --build YYYYmmdd-HHMM [opcje] OBRAZ

Opcje:
  -b, --build BUILD    numer buildu, np. 20261007-1333 (wymagany)
  -o, --output PLIK    plik wynikowy; domyślnie OBRAZ-stamped.EXT
      --logo PLIK      własny plik logo PNG
  -f, --force          pozwól zastąpić istniejący plik wynikowy
  -h, --help           pokaż tę pomoc

Przykład:
  scripts/stamp-release-image.sh \
    --build 20261007-1333 \
    ~/Screenshots/zrzut.png
EOF
}

die() {
  printf 'Błąd: %s\n' "$*" >&2
  exit 1
}

build=""
input=""
output=""
logo="$DEFAULT_LOGO"
force=0

while (($#)); do
  case "$1" in
    -b|--build)
      (($# >= 2)) || die "opcja $1 wymaga wartości"
      build="$2"
      shift 2
      ;;
    -o|--output)
      (($# >= 2)) || die "opcja $1 wymaga wartości"
      output="$2"
      shift 2
      ;;
    --logo)
      (($# >= 2)) || die "opcja $1 wymaga wartości"
      logo="$2"
      shift 2
      ;;
    -f|--force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      (($# == 1)) || die "podaj dokładnie jeden obraz wejściowy"
      input="$1"
      shift
      ;;
    -*)
      die "nieznana opcja: $1"
      ;;
    *)
      [[ -z "$input" ]] || die "podaj dokładnie jeden obraz wejściowy"
      input="$1"
      shift
      ;;
  esac
done

[[ "$build" =~ ^[0-9]{8}-[0-9]{4}$ ]] || \
  die "numer buildu musi mieć format YYYYmmdd-HHMM"
[[ -n "$input" ]] || die "brak obrazu wejściowego"
[[ -f "$input" ]] || die "nie znaleziono obrazu: $input"
[[ -f "$logo" ]] || die "nie znaleziono logo: $logo"
[[ -f "$LABEL_FONT" ]] || die "nie znaleziono fontu: $LABEL_FONT"
[[ -f "$BUILD_FONT" ]] || die "nie znaleziono fontu: $BUILD_FONT"
command -v magick >/dev/null 2>&1 || \
  die "wymagany jest ImageMagick 7 (polecenie: magick)"

if [[ -z "$output" ]]; then
  input_dir="$(dirname -- "$input")"
  input_name="$(basename -- "$input")"
  if [[ "$input_name" == *.* && "$input_name" != .* ]]; then
    input_stem="${input_name%.*}"
    input_ext=".${input_name##*.}"
  else
    input_stem="$input_name"
    input_ext=".png"
  fi
  output="${input_dir}/${input_stem}-stamped${input_ext}"
fi

[[ "$input" != "$output" ]] || die "plik wynikowy nie może być obrazem wejściowym"
if [[ -e "$output" && "$force" -ne 1 ]]; then
  die "plik wynikowy już istnieje: $output (użyj --force, aby go zastąpić)"
fi

output_dir="$(dirname -- "$output")"
[[ -d "$output_dir" ]] || die "katalog wynikowy nie istnieje: $output_dir"

read -r image_width image_height < <(
  magick identify -format '%w %h\n' -- "$input"
)
((image_width > 0 && image_height > 0)) || die "nie udało się odczytać wymiarów obrazu"

# Wymiary są proporcjonalne do szerokości obrazu; wartości bazowe odpowiadają 1920 px.
logo_width=$((image_width * 23 / 100))
margin=$((image_width * 5 / 200))
gap_large=$((image_width / 160))
logo_lift=$((image_width * 19 / 1920))
gap_small=$((image_width / 480))
label_size=$((image_width / 120))
build_size=$((image_width / 30))
label_kerning=$((image_width / 640))

# Dolne granice zachowują czytelność również dla mniejszych zrzutów.
((logo_width >= 220)) || logo_width=220
((margin >= 20)) || margin=20
((gap_large >= 8)) || gap_large=8
((logo_lift >= 10)) || logo_lift=10
((gap_small >= 3)) || gap_small=3
((label_size >= 12)) || label_size=12
((build_size >= 32)) || build_size=32
((label_kerning >= 1)) || label_kerning=1

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/maszyna-release-stamp.XXXXXX")"
trap 'rm -rf -- "$tmp_dir"' EXIT

logo_layer="${tmp_dir}/logo.png"
label_layer="${tmp_dir}/label.png"
build_layer="${tmp_dir}/build.png"
text_layer="${tmp_dir}/text.png"
stamp_layer="${tmp_dir}/stamp.png"

magick "$logo" -strip -trim +repage -resize "${logo_width}x" "$logo_layer"

magick \
  -background none \
  -fill '#8bc7ff' \
  -stroke '#000000b0' \
  -strokewidth 1 \
  -font "$LABEL_FONT" \
  -pointsize "$label_size" \
  -kerning "$label_kerning" \
  label:'PRE-ALPHA BUILD' \
  -trim +repage \
  "$label_layer"

magick \
  -background none \
  -fill white \
  -stroke '#000000d0' \
  -strokewidth 2 \
  -font "$BUILD_FONT" \
  -pointsize "$build_size" \
  label:"$build" \
  -trim +repage \
  "$build_layer"

magick \
  -gravity east \
  -background none \
  "$label_layer" \
  -size "1x${gap_small}" xc:none \
  "$build_layer" \
  -append \
  "$text_layer"

magick \
  -gravity west \
  -background none \
  "$logo_layer" \
  -size "${logo_width}x$((gap_large + logo_lift))" xc:none \
  "$text_layer" \
  -append \
  "$stamp_layer"

magick \
  "$input" \
  "$stamp_layer" \
  -gravity southwest \
  -geometry "+${margin}+${margin}" \
  -composite \
  "$output"

printf 'Zapisano: %s\n' "$output"
