#!/bin/sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
codex_dir=${CODEX_HOME:-"$HOME/.codex"}
update=false
case "${1:-}" in
  '') ;;
  --update) update=true ;;
  *) echo 'Usage: sh install.sh [--update]' >&2; exit 2 ;;
esac
hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d ' ' -f 1
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d ' ' -f 1
  else echo 'SHA-256 tool not found (sha256sum or shasum required).' >&2; exit 1
  fi
}
expected_hash() { awk -v name="pet/$1" '$2 == name {print tolower($1)}' "$script_dir/checksums.sha256"; }
for name in pet.json spritesheet.webp; do
  test -f "$script_dir/pet/$name" || { echo "Missing: $name" >&2; exit 1; }
  expected=$(expected_hash "$name")
  test -n "$expected" && test "$(hash_file "$script_dir/pet/$name")" = "$expected" || { echo "Checksum mismatch: $name" >&2; exit 1; }
done
destination="$codex_dir/pets/amiya-universe-solo"
for candidate in "$codex_dir/pets" "$destination"; do
  test ! -L "$candidate" || { echo "Refusing linked directory: $candidate" >&2; exit 1; }
done
different=false
for name in pet.json spritesheet.webp; do
  existing="$destination/$name"
  test ! -L "$existing" || { echo "Refusing linked file: $existing" >&2; exit 1; }
  if test -e "$existing"; then
    test -f "$existing" || { echo "Expected file: $existing" >&2; exit 1; }
    test "$(hash_file "$existing")" = "$(expected_hash "$name")" || different=true
  fi
done
if $different && ! $update; then echo 'A different version exists. Run sh install.sh --update to back it up and update.' >&2; exit 1; fi
mkdir -p "$destination"
if $different; then
  backup="$destination/backups/$(date -u +%Y%m%d-%H%M%S)-$$"
  mkdir "$backup" 2>/dev/null || { mkdir -p "$destination/backups"; mkdir "$backup"; }
  for name in pet.json spritesheet.webp; do test ! -f "$destination/$name" || cp -p "$destination/$name" "$backup/$name"; done
  printf 'Previous files backed up to: %s\n' "$backup"
fi
for name in pet.json spritesheet.webp; do cp "$script_dir/pet/$name" "$destination/$name"; done
printf 'Installed Amiya to: %s\nRestart Codex if needed, then select Amiya in the pet picker.\n' "$destination"
