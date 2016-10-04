#!/usr/bin/env python

# weight.py input1.tif w1:w2 input2.tif output.tif
# Make a weighted average of input{1,2}.tif (both single-band)
# with weight per the w1:w2 ratio. Example:
# weight.py green.tif 7:1 nir.tif synthesized-green.tif

import rasterio as rio
from sys import argv
import numpy as np

weight = map(float, argv[2].split(':'))

with rio.open(argv[1]) as A:
  a = A.read(1).astype(np.uint32)
  meta = A.meta

with rio.open(argv[3]) as B:
  b = B.read(1).astype(np.uint32)

weighted = (
    (a*weight[0] + b*weight[1]) / (weight[0]+weight[1])
  ).astype(meta['dtype'])

meta['compress'] = 'lzw'

with rio.open(argv[4], 'w', **meta) as dst:
  dst.write(weighted, 1)
