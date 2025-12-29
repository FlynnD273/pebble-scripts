#!/usr/bin/env bash

for file in *.sh; do
	if [ "$file" == "link_all.sh" ]; then
		continue
	fi
	ln -s "pebble-scripts/$file" "../$file"
done
