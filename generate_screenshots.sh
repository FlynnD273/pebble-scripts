#!/usr/bin/env bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--delay)
      DELAY="$2"
      shift
      shift
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

DELAY=${DELAY:-1}

set -- "${POSITIONAL_ARGS[@]}"

pebble kill
pebble wipe
pebble build

if [[ ! -d screenshots ]]; then
  mkdir screenshots
fi

function scr() {
  pebble install --emulator "$1"
  sleep "$DELAY"
  pebble screenshot ./screenshots/"$1".png
  pebble kill
}

if [ ! "$1" ]; then
	for platform in $(jq -r '.pebble.targetPlatforms | @sh' package.json); do
		scr "${platform//\'/}"
	done
else
	while [[ $# -gt 0 ]]; do
		scr "$1"
		shift
	done
fi
