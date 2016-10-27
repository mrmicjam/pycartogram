#!/usr/bin/env python
from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext
import numpy


libraries = ['fftw3', 'm']

setup(
    name='pycartogram',
    description='A python interface to a C cartogram library.',
    author="Micah Jamison",
    author_email='dataconcise@gmail.com',
    license='MIT',
    cmdclass={'build_ext': build_ext},
    ext_modules=[Extension("_pycartogram",
                           sources=["src/pycartogram.pyx", 'src/cart-1.2.2/main.c', 'src/cart-1.2.2/cart.c', 'src/cartogram.c'],
                           include_dirs=[numpy.get_include(), "src/cart-1.2.2"],
                           libraries=libraries,
                           define_macros=[('NOPROGRESS', 1), ],
                           extra_compile_args=["-O7"]
                           ), ],
    py_modules=['pycartogram', ],
    install_requires=['numpy', ]
)
