#!/bin/bash

# requires coreutils (brew install)
function daysalive() {
	echo $(( ($(gdate -u +%s) - $(gdate -ud "1991-10-05" +%s)) /60/60/24 ));
}

daysalive
