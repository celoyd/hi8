# hi8

Tools for making animations from Himawari-8 P-Tree data.

This is the workflow I’m using for new https://glittering.blue movies.

Code here is late alpha quality at best! Documentation is probably wrong!

## Background on Himawari-8

Todo: explain at least:
- general purpose of Himawari-8
- AHI’s bands
- The green thing
- Perspective/projection
- The modes (full disk, Japan, etc.)
- Swaths and equinox

## Prerequisites

To get data you’ll need to sign up at [the P-Tree Secretariat](http://www.eorc.jaxa.jp/ptree/registration_top.html). They are kind and hardworking people; don’t abuse their service. (A lot of the code can be adapted to run code from the simpler [tiled PNG endpoint](http://himawari8.nict.go.jp). The downloads are faster but the images are more quantized and the greens are off: see “The green thing” above.)

To run the code you’ll want roughly these system packages:

- libHDF5
- imagemagick (:/)

These python libraries:

- rasterio
- netCDF

And [rayg’s `himawari`](https://gitlab.ssec.wisc.edu/rayg/himawari).

## Running the code

Who knows?
