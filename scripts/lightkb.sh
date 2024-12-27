#!/usr/bin/env bash

dk=7

set -e

if [ "$1" = "" ]; then
  path=/sys/class/leds/input$dk::scrolllock
else
  path=/sys/class/leds/input$1::scrolllock
fi

while sleep 0.1; do
  echo 1 >"$path/brightness"
done
