#!/usr/bin/env bash

names=(
	_
	display_base
	display_knob
	control_base
	control_knob
)

for i in $(seq 1 4);
do
	[ -d imgs ] || mkdir imgs 
	printf "\n%s/4 exporting %s\n" "$i" "${names[i]}"
	openscad -o imgs/${names[i]}.svg -D "part=$i" SVG_export.scad
done
