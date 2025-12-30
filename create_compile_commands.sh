#!/usr/bin/env bash

platform=basalt
if [ "$1" != "" ]; then
	platform="$1"
fi
armIncludes="$(realpath "$(pebble sdk include-path "$platform")/../../../../toolchain/arm-none-eabi/arm-none-eabi/include/")"
platformIncludes="$(pebble sdk include-path "$platform")"

tee compile_commands.json <<EOF
[
	{
		"directory": "$PWD",
		"arguments": [
			"gcc",
			"-I$armIncludes",
			"-I$platformIncludes",
			"-Ibuild/include/",
			"-Iinclude/",
			"-Ibuild/basalt/"
		],
		"file": "*.*"
	}
]
EOF
