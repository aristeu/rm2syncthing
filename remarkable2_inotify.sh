#!/bin/bash
RM2=$HOME/remarkable2;
OUTPUT=$HOME/output;

inotifywait --event MOVED_TO --recursive --monitor --format "%w%f" --include ".*\.rm\$" $RM2 | while read path; do
	dir=$(dirname $path);
	if [ ! -d $dir ]; then
		 continue;
	fi;
	meta=${dir}.metadata;
	name=$(grep visibleName $meta | cut -f 4 -d '"' | sed -e "s/\ /_/g");
	python3 -m rmrl ${dir}/ >${OUTPUT}/${name}-exported.pdf;
	convert -define png:color-type=6 -background white -alpha remove -alpha off ${OUTPUT}/${name}-exported.pdf PNG32:${OUTPUT}/${name}.png;
	echo ${OUTPUT}/${name}.png;
done
