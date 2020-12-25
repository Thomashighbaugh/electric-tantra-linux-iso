#!/bin/bash

rofi -no-lazy-grab -show drun \
	-display-drun "Applications " -drun-display-format "{name}" \
	-hide-scrollbar true \
	-show-icons -icon-theme "chhinamasta" \
	-theme ./themes/sidetab.rasi
