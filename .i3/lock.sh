
TMPBG=/tmp/screen.png
LOCK=$HOME/lock.png
LOCK=~/.i3/lock.png
RES=$(xrandr | grep '*' | sed -E "s/[^0-9]*([0-9]+)x([0-9]+).*/\1*\2/")
 
ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -filter_complex "boxblur=4:1:cr=2:ar=2,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $TMPBG -loglevel quiet
i3lock -u -i $TMPBG
rm $TMPBG
#scrot $TMPBG
#convert $TMPBG -scale 10% -scale 1000% $TMPBG
#[[ -f $1 ]] && convert $TMPBG $1 -gravity center -composite -matte $TMPBG
#i3lock -u -i $TMPBG
#rm $TMPBG

#!/usr/bin/env bash

#icon="/home/batrobin/.i3/lock.png"
#tmpbg='/tmp/screen.png'

#(( $# )) && { icon=$1; }

#scrot "$tmpbg"
#convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
#convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"
#i3lock -u -i "$tmpbg"
