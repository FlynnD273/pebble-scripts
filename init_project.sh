#!/usr/bin/env bash

echo "Init .gitignore:"
tee .gitignore << EOF
compile_commands.json
node_modules
build
.lock*
*.blend[0-9]
EOF
echo

echo "Init compile commands:"
../create_compile_commands.sh "$1"
