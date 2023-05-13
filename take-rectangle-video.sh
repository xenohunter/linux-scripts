#!/bin/bash

script_dir="$(cd "$(dirname "$0")" && pwd)"
script_filename=$(basename "$0")
pid_temp_path="$script_dir/$script_filename.temp"

if [ -f "$pid_temp_path" ]; then
    pid=$(< "$pid_temp_path")
    kill $pid && rm $pid_temp_path
else
    target_dir=~/temp/video
    target_filename="video_$(date +'%Y-%m-%d_%H-%M-%S').webm"
    mkdir -p $target_dir

    slop=$(slop -f "%x %y %w %h %g %i") || exit 1
    read -r X Y W H G ID <<< $slop
    ffmpeg -hide_banner -loglevel error -f x11grab -s "$W"x"$H" -i :0.0+$X,$Y $target_dir/$target_filename &
    pid=$!
    echo $pid > $pid_temp_path
fi
