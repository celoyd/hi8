# hi8

Tools for making animations from Himawari-8 P-Tree data.

![lil](https://cloud.githubusercontent.com/assets/148985/19018388/b47a300e-8813-11e6-8e5a-4b80fa1160f4.jpeg)

This is the workflow I’m using for new https://glittering.blue movies. It’s overkill for most purposes: it downloads roughly 12 gigabytes per second of video. An easier method, with lower but still delightful image quality, is to download from the tiled PNG endpoint [as outlined in this gist](https://github.com/celoyd/hi8.git).

Code here is late alpha quality at best! It will not run out of the box yet. Documentation is barely started and probably wrong!

## Background on Himawari-8

Todo: explain at least:
- general purpose of Himawari-8
- AHI’s bands
- The green thing
- Perspective/projection
- The modes (full disk, Japan, etc.)
- Swaths and equinox

## Prerequisites

To get data you’ll need to sign up at [the P-Tree Secretariat](http://www.eorc.jaxa.jp/ptree/registration_top.html). They are kind and hardworking people; don’t abuse their service.

To run the code you’ll want roughly these system packages:

- libHDF5
- imagemagick (:/)
- libffi-dev

These python libraries:

- rasterio
- netCDF
- numpy
- cffi

And [rayg’s `himawari`](https://gitlab.ssec.wisc.edu/rayg/himawari).

## Running the code

Who knows?
