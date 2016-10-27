import numpy as np

import _pycartogram


class Cartogram(object):
    def __init__(self, width, height):

        self.width = width
        self.height = height
        self.gridx = self.gridy = None

    def generate_warp(self, grid_data):
        output_size = ((self.height + 1), (self.width + 1))
        self.gridx = np.full(output_size, None, dtype=np.float64)
        self.gridy = np.full(output_size, None, dtype=np.float64)
        _pycartogram.generate_warp(grid_data, self.gridx, self.gridy)
        self.gridx = np.swapaxes(self.gridx, 0, 1)
        self.gridy = np.swapaxes(self.gridy, 0, 1)

    def interp(self, x, y):
        assert all([self.gridx is not None, self.gridy is not None])
        return _pycartogram.interp(self.gridx, self.gridy, self.width, self.height, x, y)
