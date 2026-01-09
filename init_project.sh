#!/usr/bin/env bash

tee .gitignore << EOF
node_modules
build
EOF
../create_compile_commands.sh $1
