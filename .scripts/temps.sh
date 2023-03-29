#!/bin/sh

CPU_TEMP=$(sensors | grep Tctl | awk '{ print $2 }' | tr -d '+°C')
GPU_TEMP=$(sensors | grep GPU | awk '{ print $2 }' | tr -d '+°C')

echo " $CPU_TEMP $GPU_TEMP"
