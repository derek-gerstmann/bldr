#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="numerics"
pkg_name="eigen"
pkg_vers="3.1.1"

pkg_info="Eigen is a C++ template library for linear algebra: vectors, matrices, and related algorithms. It is versatile, fast, elegant and works on many platforms (OS/Compilers)."

pkg_desc="Eigen is a C++ template library for linear algebra: vectors, matrices, 
and related algorithms. It is versatile, fast, elegant and works on many platforms 
(OS/Compilers).

Eigen is versatile.
* It supports all matrix sizes, from small fixed-size matrices to arbitrarily large dense matrices, and even sparse matrices.
* It supports all standard numeric types, including std::complex, integers, and is easily extensible to custom numeric types.
* It supports various matrix decompositions and geometry features.
* Its ecosystem of unsupported modules provides many specialized features such as non-linear optimization, matrix functions, a polynomial solver, FFT, and much more.

Eigen is fast.
* Expression templates allow to intelligently remove temporaries and enable lazy evaluation, when that is appropriate.
* Explicit vectorization is performed for SSE 2/3/4, ARM NEON, and AltiVec instruction sets, with graceful fallback to non-vectorized code.
* Fixed-size matrices are fully optimized: dynamic memory allocation is avoided, and the loops are unrolled when that makes sense.
* For large matrices, special attention is paid to cache-friendliness.

Eigen is reliable.
* Algorithms are carefully selected for reliability. Reliability trade-offs are clearly documented and extremely safe decompositions are available.
* Eigen is thoroughly tested through its own test suite (over 500 executables), the standard BLAS test suite, and parts of the LAPACK test suite.
* Eigen is elegant.

The API is extremely clean and expressive while feeling natural to C++ programmers, thanks to expression templates.

Implementing an algorithm on top of Eigen feels like just copying pseudocode.

Eigen has good compiler support as we run our test suite against many compilers to guarantee reliability and work around any compiler bugs. Eigen also is standard C++98 and maintains very reasonable compilation times."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://bitbucket.org/$pkg_name/$pkg_name/get/$pkg_file"
pkg_opts="cmake"
pkg_uses=""
pkg_reqs=""
pkg_cfg=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################
# build and install pkg as local module
####################################################################################################

bldr_build_pkg --category    "$pkg_ctry"    \
               --name        "$pkg_name"    \
               --version     "$pkg_vers"    \
               --info        "$pkg_info"    \
               --description "$pkg_desc"    \
               --file        "$pkg_file"    \
               --url         "$pkg_urls"    \
               --uses        "$pkg_uses"    \
               --requires    "$pkg_reqs"    \
               --options     "$pkg_opts"    \
               --cflags      "$pkg_cflags"  \
               --ldflags     "$pkg_ldflags" \
               --config      "$pkg_cfg"


