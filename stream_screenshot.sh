#!/bin/sh

cd /app
rm -f screenshot.jpg
convert -size $SCREENSHOT_SIZE -background grey28 -fill orange -gravity center -weight 1500 -pointsize 60 label:"$SCREENSHOT_NOT_UPDATED_MSG" no-recent-screenshot.jpg
./capture_screenshot.sh &

while true; do
	if [ -f screenshot.jpg ]; then
		if [ $(($(date +%s) - $(date +%s -r "screenshot.jpg"))) -gt 1 ]; then
			mv screenshot.jpg streaming.jpg
			convert -resize $SCREENSHOT_SIZE^ streaming.jpg streaming.jpg
		fi
	fi
	if [ -f streaming.jpg ]; then
		cat streaming.jpg
	fi
	sleep $((60/STREAM_FPM))
done | streameye -t $((STREAM_TIMEOUT/3*2)) -q
