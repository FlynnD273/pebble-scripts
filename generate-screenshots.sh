#!/usr/bin/env bash

pebble build

if [[ ! -d screenshots ]]; then
  mkdir screenshots
fi

function scr() {
  pebble install --emulator "$1"
  sleep 1
  pebble screenshot ./screenshots/"$1".png
  pebble kill
}

scr aplite
scr basalt
scr chalk
scr diorite
scr emery
scr flint
