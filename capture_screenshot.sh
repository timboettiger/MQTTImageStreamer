#!/bin/sh

cd /app
while true; do
	if [ -f screenshot.jpg ]; then
        break
	else
		mosquitto_sub -C 1 -W $STREAM_TIMEOUT -h $MQTT_BROKER -t $MQTT_TOPIC > screenshot.png
		if [ -s screenshot.png ]; then
        	convert screenshot.png screenshot.jpg
		else
			rm -f screenshot.png
        	cp no-recent-screenshot.jpg screenshot.jpg
		fi
	fi
	sleep 4
done
