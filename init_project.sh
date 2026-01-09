#!/usr/bin/env bash

echo "Init .gitignore:"
tee .gitignore << EOF
node_modules
build
.lock*
EOF
echo

echo "Init compile commands:"
../create_compile_commands.sh "$1"
