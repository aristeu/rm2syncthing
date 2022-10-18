#!/bin/bash
RM2=$HOME/remarkable2;
OUTPUT=$HOME/output;

for i in ${RM2}/*.metadata; do
	dir=${RM2}/$(basename $i .metadata);
	if [ ! -d $dir ]; then
		 continue;
	fi;
	name=$(grep visibleName $i | cut -f 4 -d '"' | sed -e "s/\ /_/g");
	lastmodified=$(grep lastModified $i | cut -f 4 -d '"');
	if [ -f ${RM2}/${name}.lastModified -a "$(<${RM2}/${name}.lastModified)" = "$lastmodified" ]; then
		continue;
	fi
	python3 -m rmrl ${dir}/ > ${OUTPUT}/${name}-exported.pdf;
#	convert -define png:color-type=6 ${name}-exported.pdf PNG32:${name}.png;
	convert -define png:color-type=6 -background white -alpha remove -alpha off ${OUTPUT}/${name}-exported.pdf PNG32:${OUTPUT}/${name}.png;
	echo "$lastmodified" >${RM2}/${name}.lastModified;
done
