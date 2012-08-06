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
  echo "  -h show help (this).                                                  " >&2
  echo "  -v use maximum verbosity for log output.                              " >&2
  echo "  -V report BLDR version.                                               " >&2
  echo "  -c category of packages to build (use more than once to provide a list of categories)." >&2
  echo "  -n name of package to build (use more than once to provide a list of names)." >&2
  echo "  -o options to use for build (use more than once to provide a list of options)." >&2
  echo "                                                                        " >&2
  echo "EXAMPLES                                                                " >&2
  echo "  build.sh -c graphics -n glew        [ build the 'GLEW' package under the 'graphics' category ] " >&2
  echo "  build.sh -c internal -c system      [ build all packages under the 'internal' and 'system' categories ] " >&2
  echo "  build.sh -n m4 -o force-rebuild     [ force a rebuild of any package called 'm4' in any category ] " >&2
  echo "                                                                        " >&2
}

####################################################################################################

pkg_ctry=""
pkg_name=""
pkg_opts=""
pkg_args=""

####################################################################################################

# translate long options to short
for arg
do
    delim=""
    case "$arg" in
       --help) pkg_args="${pkg_args}-h ";;
       --verbose) pkg_args="${pkg_args}-v ";;
       --version) pkg_args="${pkg_args}-V ";;
       --category) pkg_args="${pkg_args}-c ";;
       --name) pkg_args="${pkg_args}-n ";;
       --options) pkg_args="${pkg_args}-o ";;
       # pass through anything else
       *) [[ "${arg:0:1}" == "-" ]] || delim="\""
           pkg_args="${pkg_args}${delim}${arg}${delim} ";;
    esac
done

# reset the translated args
eval set -- $pkg_args

# now we can process with getopt
while getopts ":hdvVc:n:o:" opt; do
    case $opt in
        V)  bldr_echo "BLDR $BLDR_VERSION_STR" && exit 1;;
        h)  usage && exit 1;;
        d)  export BLDR_DEBUG=true;;
        v)  export BLDR_VERBOSE=true;;
        c)  pkg_ctry="$pkg_ctry:$OPTARG" ;;
        n)  pkg_name="$pkg_name:$OPTARG" ;;
        o)  pkg_opts="$pkg_opts:$OPTARG" ;;
        \?) usage && exit 1;;
        :)  echo "ERROR: '-$OPTARG' requires an argument!  See --help!" && exit 1 ;;
        *)  echo "ERROR: '-$OPTARG' is an unrecognized option! See --help!" && exit 1 ;;
    esac
done

####################################################################################################

bldr_build_pkgs --category "$pkg_ctry" --name "$pkg_name" --options "$pkg_opts" ${pkg_args}

####################################################################################################
