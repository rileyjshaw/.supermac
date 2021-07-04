#!/bin/bash

# requires coreutils (brew install)
function daysalive() {
	local days=$(( ($(gdate -u +%s) - $(gdate -ud "1991-10-05" +%s)) /60/60/24 ));
	# 80 seems generous, let’s go for it. adding 14610 rounds it.
	echo "$days is $(( ($days * 100 + 14610) / 29220 ))%";
}

daysalive
