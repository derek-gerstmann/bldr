#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="spatial"
pkg_name="ann"
pkg_vers="1.1.2"

pkg_info="ANN is a library written in C++, which supports data structures and algorithms for both exact and approximate nearest neighbor searching in arbitrarily high dimensions."

pkg_desc="ANN is a library written in C++, which supports data structures and algorithms 
for both exact and approximate nearest neighbor searching in arbitrarily high dimensions.

In the nearest neighbor problem a set of data points in d-dimensional space is given. 
These points are preprocessed into a data structure, so that given any query point q, 
the nearest or generally k nearest points of P to q can be reported efficiently. The 
distance between two points can be defined in many ways. ANN assumes that distances are 
measured using any class of distance functions called Minkowski metrics. These include 
the well known Euclidean distance, Manhattan distance, and max distance.

Based on our own experience, ANN performs quite efficiently for point sets ranging in 
size from thousands to hundreds of thousands, and in dimensions as high as 20. (For 
applications in significantly higher dimensions, the results are rather spotty, but 
you might try it anyway.)

The library implements a number of different data structures, based on kd-trees and 
box-decomposition trees, and employs a couple of different search strategies.

The library also comes with test programs for measuring the quality of performance of 
ANN on any particular data sets, as well as programs for visualizing the structure of 
the geometric data structures."

pkg_file="$pkg_name_$pkg_vers.tar.gz"
pkg_urls="http://www.cs.umd.edu/~mount/ANN/Files/$pkg_vers/$pkg_file"
pkg_opts="configure"
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


