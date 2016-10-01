#!/bin/zsh

# a good 40% of this should be in python

set -e
set -x

year=$1
mo=$2
dy=$3
hr=$4
tm=$5
bd=$6
#dst_path=$8

if [ $bd = "03" ]; then
    rs="05"
else
    rs="10";
fi

tmp=~/work/$$
mkdir $tmp
start_dir=$(pwd)
cd $tmp

dst="$year$mo$dy-$hr$tm$tl-B$bd";

for sw in {01..10}; do
    dirs="ftp://ftp.ptree.jaxa.jp/jma/hsd/${year}${mo}/${dy}/${hr}";
    datepart="HS_H08_${year}${mo}${dy}_${hr}${tm}_";
    endpart="B${bd}_FLDK_R${rs}_S${sw}10.DAT.bz2";
    filename="$datepart$endpart";
    url="$dirs/$filename";

    hi $url;
    python himawari/py/hsd2nc.py $filename "${dst}-${sw}.nc";
    rm $filename
    
    if [ $bd -eq "03" ]; then
        gdal_translate -outsize 50% 50% NETCDF:"${dst}-${sw}.nc":RAD "${dst}-${sw}.tif"
    else
        gdal_translate NETCDF:"${dst}-${sw}.nc":RAD "${dst}-${sw}.tif"
    fi
    
    python tozero.py ${dst}-${sw}.tif ${dst}-${sw}-zeroed.tif
    convert -rotate 180 -flop "${dst}-${sw}-zeroed.tif" "${dst}-${sw}.tif"
done

rm *-zeroed.tif

montage -mode concatenate -tile 1x ${dst}-*.tif $dst.tif;
cd $start_dir;
mv $tmp/$dst.tif .;
