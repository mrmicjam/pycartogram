import unittest
import numpy as np

import pycartogram


class TestPop(unittest.TestCase):
    def test_pop_inter(self):
        data_file = open("../src/cart-1.2.2/uspop.dat", 'r')
        data = np.loadtxt(data_file, dtype=np.float64)
        data = np.swapaxes(data, 0, 1)
        data = np.ascontiguousarray(data, dtype=np.float64)
        pycarto = pycartogram.Cartogram(*data.shape)

        pycarto.generate_warp(data)
        new_x, new_y = pycarto.interp(100, 100)

        self.assertNotEqual(new_x, 100)
        self.assertNotEqual(new_y, 100)

if __name__ == '__main__':
    unittest.main()
