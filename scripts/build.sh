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
  echo "                                                                        " >&2
  echo "SYNOPSIS                                                                " >&2
  echo "  build.sh [OPTIONS] [pkgs]                                             " >&2
  echo "                                                                        " >&2
  echo "OPTIONS                                                                 " >&2
  echo "  -c package category (or subdirectory) to build                        " >&2
  echo "  -h show help (this)                                                   " >&2
  echo "                                                                        " >&2
  echo "EXAMPLE                                                                 " >&2
  echo "  build.sh -c system                                                    " >&2
  echo "                                                                        " >&2
}

####################################################################################################

pkg_names=""

# translate long options to short
for arg
do
    delim=""
    case "$arg" in
       --help) args="${args}-h ";;
       --verbose) args="${args}-v ";;
       --version) args="${args}-V ";;
       --category) args="${args}-c ";;
       # pass through anything else
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           args="${args}${delim}${arg}${delim} ";;
    esac
done

# reset the translated args
eval set -- $args

# now we can process with getopt
while getopts ":hdvVc:" opt; do
    case $opt in
        V)  bldr_echo "BLDR $BLDR_VERSION_STR" && exit 1;;
        h)  usage && exit 1;;
        d)  export BLDR_DEBUG=true;;
        v)  export BLDR_VERBOSE=true;;
        c)  pkg_names="$pkg_names:$OPTARG";;
        \?) usage && exit 1;;
        :)  echo "ERROR: '-$OPTARG' requires an argument!  See --help!" && exit 1 ;;
        *)  echo "ERROR: '-$OPTARG' is an unrecognized option! See --help!" && exit 1 ;;
    esac
done

####################################################################################################

bldr_build_pkgs "$pkg_names" $*

####################################################################################################
