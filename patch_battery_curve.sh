#!/usr/bin/env bash

usage() {
	echo "This script patches the battery curve for firmware binaries."
	echo
	cat << EOF
REQUIRED ARGUMENTS

  -i	Input file path to firmware *.pbz file
  -c	The new voltage curve. Should have 13 values

OPTIONAL ARGUMENTS

  -o	Output file path
  -y	Skip confirmation dialogs
EOF
	exit 0
}

input=""
output=""
yes=""

while getopts i:o:c:yh opt; do
	case "$opt" in
		i)
			input="$OPTARG"
			;;
		o)
			output="$OPTARG"
			;;
		y)
			yes=true
			;;
		c)
			read -r -a new_voltages <<< "$OPTARG"
			;;
		h | *)
			usage
			;;
	esac
done

if [ ! "$input" ] || [ ! "${new_voltages[0]}" ] || [ "${#new_voltages[@]}" != 13 ]; then
	echo "Invalid usage."
	usage
fi


if [ ! "$output" ]; then
	output="${input%.pbz}_patched.pbz"
fi

BATTERY_CRITICAL_VOLTAGE_DISCHARGING_TINTIN=3100
BATTERY_CRITICAL_VOLTAGE_DISCHARGING=3300
percents=(0 2 5 10 20 30 40 50 60 70 80 90 100)
# new_voltages=(3300 3490 3615 3655 3700 3735 3760 3800 3855 3935 4025 4120 4230)

num_to_hex() {
	printf '%04x' "$1" | tac -rs ..
}

search=""
replace=""

for i in "${!percents[@]}"; do
	percent="$(num_to_hex "${percents[i]}")"
	if [ -z "$search" ]; then
		batt="$(num_to_hex "$BATTERY_CRITICAL_VOLTAGE_DISCHARGING")"
		batt_tintin="$(num_to_hex "$BATTERY_CRITICAL_VOLTAGE_DISCHARGING_TINTIN")"
		search+="$percent($batt|$batt_tintin)"
	else
		search+="$percent""[0-9a-f][0-9a-f][0-9a-f][0-9a-f]"
	fi
	replace+="$percent$(num_to_hex "${new_voltages[i]}")"
done

if [ -f "$output" ] && [ ! $yes ]; then
	echo -n "File $output already exists. Overwrite? (Y/n): "
	read -r confirm
	if [ "$confirm" ] || [ "$confirm" != "y" ] || [ "$confirm" != "Y" ]; then
		exit
	fi
fi
xxd -p -c 0 < "$input" | sed -E "0,/$search/{s//$replace/}" | xxd -r -p -c 0 > "$output"
