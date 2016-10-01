#!/usr/bin/env zsh

# ./day.sh year month_number morning_day evening_day zoom_level

# Strictly alpha: for example, does not know how to handle
# month edges or unscheduled missing images.

set -eu

year=$1
mo=$2
df=$3
dt=$4
scale=$5

mkdir -p raw color gapfilled interpolated

parallel -j8 --header : 'python hi8-fetch.py "{yr}-{mo}-{dy} {hr}:{tenmin}0:00" {scale} raw/{yr}-{mo}-{dy}T{hr}{tenmin}000.png' ::: yr $year ::: mo $mo ::: dy $df ::: hr {14..23} ::: tenmin {0..5} ::: scale $scale

parallel -j8 --header : 'python hi8-fetch.py "{yr}-{mo}-{dy} {hr}:{tenmin}0:00" {scale} raw/{yr}-{mo}-{dy}T{hr}{tenmin}000.png' ::: yr $year ::: mo $mo ::: dy $dt ::: hr {00..14} ::: tenmin {0..5} ::: scale $scale

parallel --header : 'rm raw/{yr}-{mo}-{dy}T{hr}{tenmin}000.png' ::: yr $year ::: mo $mo ::: dy $df ::: hr 14 ::: tenmin {0..4}

parallel --header : 'rm raw/{yr}-{mo}-{dy}T{hr}{tenmin}000.png' ::: yr $year ::: mo $mo ::: dy $dt ::: hr 14 ::: tenmin {4..5}

cp raw/* gapfilled

convert -average gapfilled/${year}-${mo}-${dt}T143000.png gapfilled/${year}-${mo}-${df}T145000.png gapfilled/${year}-${mo}-${df}T144000.png

convert -average gapfilled/${year}-${mo}-${dt}T023000.png gapfilled/${year}-${mo}-${dt}T025000.png gapfilled/${year}-${mo}-${dt}T024000.png


# look for nulls and empties
#
# this only catches single-tile nulls:
# for x in *.png; do
#     ( echo $(sha1 $x) | grep -q 142dc29d84424bbd305c14168454024a1f758047 ) && echo "$x is empty!"; exit; )
# done

#parallel 'convert -gamma 1.3 -channel B -gamma 0.9 -channel G -gamma 0.975 +channel -sigmoidal-contrast 3,33% {} color/{/}' ::: gapfilled/*
parallel 'convert -gamma 1.333 -channel B -gamma 0.9 -channel G -gamma 0.975 +channel -sigmoidal-contrast 3,33% {} color/{/}' ::: gapfilled/*

# for the 4-channel process:
# -level 0.03% -gamma 1.5 -sigmoidal-contrast 8,8.5% -modulate 100,185 -channel B -gamma 0.6 -channel G -gamma 0.825 +channel

cp color/* interpolated

python betwixt.py interpolated | parallel --colsep ' ' convert -average {1} {2} {3}

movie=${year}-${mo}-${df}.mp4

ffmpeg -y -f image2 -pattern_type glob -i 'interpolated/*.png' -c:v libx264 -preset slow -b:v 24000k -pass 1 -c:a libfdk_aac -b:a 0k -f mp4 -r 24 -profile:v high -level 4.2 -pix_fmt yuv420p -movflags +faststart /dev/null && \
ffmpeg -f image2 -pattern_type glob -i 'interpolated/*.png' -c:v libx264 -preset slow -b:v 24000k -pass 2 -c:a libfdk_aac -b:a 0k -r 24 -profile:v high -level 4.2 -pix_fmt yuv420p -movflags +faststart $movie