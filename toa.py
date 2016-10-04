#!/usr/bin/env python

import rasterio as rio
from sys import argv
import numpy as np

# Todo:
# - document scaleup
# - document where the conversions come from

scaleup_factor = 64

band_number = int(argv[2])

conversions = {
  1: {'add_offset': -7.54716705, 'scale_factor': 0.37735835},
  2: {'add_offset': -7.08207764, 'scale_factor': 0.35410388},
  3: {'add_offset': -6.10994941, 'scale_factor': 0.30549747},
  4: {'add_offset': -3.63950941, 'scale_factor': 0.18197547}
}

with rio.open(argv[1]) as src:
  meta = src.meta
  dn = src.read(1)

meta['dtype'] = np.uint16
meta['compress'] = 'lzw'

topleft = dn[0, 0]
dn[np.where(dn == topleft)] = 0

times = conversions[band_number]['scale_factor']
plus = conversions[band_number]['add_offset']

pn = (
  np.clip(
    (dn * times + plus) * scaleup_factor,
    0,
    np.iinfo(np.uint16).max)
  ).astype(np.uint16)

with rio.open(argv[3], 'w', **meta) as dst:
  dst.write(pn, 1)