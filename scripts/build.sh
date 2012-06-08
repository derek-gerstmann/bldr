#!/bin/bash

####################################################################################################
##
## License:    The MIT License
## 
## Copyright (c) 2012. Derek Gerstmann, The University of Western Australia.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.
##  
####################################################################################################

export PATH="./scripts:../scripts:./system:../system:$PATH"

####################################################################################################

source "bldr.sh"

####################################################################################################

usage () {
  echo "                                                                        " >&2
  echo "NAME                                                                    " >&2
  echo "  bldr build - starts an automated build for a set of BLDR packages     " >&2
  echo "SYNOPSIS                                                                " >&2
  echo "  build.sh [OPTIONS] [pkgs]                                             " >&2
  echo "OPTIONS                                                                 " >&2
  echo "  -c package category (or subdirectory) to build                        " >&2
  echo "  -h show help (this)                                                   " >&2
  echo "EXAMPLE                                                                 " >&2
  echo "  build.sh -c system                                                    " >&2
  echo "                                                                        " >&2
}

####################################################################################################

pkg_names=""
while getopts hc: OPTION
do
    case $OPTION in 
        c) pkg_names="$OPTARG:$pkg_names";;
        h) usage && exit 1;;
        ?) usage && exit 1;;
    esac
done

####################################################################################################

bldr_build_pkgs "$pkg_names" $*

####################################################################################################
