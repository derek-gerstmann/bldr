#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="languages"
pkg_name="R"

pkg_info="R is a free software environment for statistical computing and graphics."

pkg_desc="R is a free software environment for statistical computing and graphics.

R is an integrated suite of software facilities for data manipulation, calculation and 
graphical display. Among other things it has:

-- an effective data handling and storage facility,
-- a suite of operators for calculations on arrays, in particular matrices,
-- a large, coherent, integrated collection of intermediate tools for data analysis,
-- graphical facilities for data analysis and display either directly at the computer 
or on hardcopy, and ...
-- a well developed, simple and effective programming language (called S) which includes 
conditionals, loops, user defined recursive functions and input and output facilities. 

(Indeed most of the system supplied functions are themselves written in the S language.)

The term 'environment' is intended to characterize it as a fully planned and coherent 
system, rather than an incremental accretion of very specific and inflexible tools, 
as is frequently the case with other data analysis software.

R is very much a vehicle for newly developing methods of interactive data analysis. 
It has developed rapidly, and has been extended by a large collection of packages. 
However, most programs written in R are essentially ephemeral, written for a single 
piece of data analysis."

pkg_vers_dft="2.15.1"
pkg_ver_list=("$pkg_vers")

pkg_opts="configure enable-static enable-shared"
pkg_reqs="$pkg_reqs zlib"
pkg_reqs="$pkg_reqs bzip2"
pkg_reqs="$pkg_reqs tcl"
pkg_reqs="$pkg_reqs tk"
pkg_reqs="$pkg_reqs pcre"
pkg_reqs="$pkg_reqs gettext"
pkg_reqs="$pkg_reqs libiconv"
pkg_reqs="$pkg_reqs libicu"
pkg_reqs="$pkg_reqs libpng"
pkg_reqs="$pkg_reqs libjpeg"
pkg_reqs="$pkg_reqs gsl"
pkg_reqs="$pkg_reqs cairo"
pkg_reqs="$pkg_reqs gfortran"
pkg_reqs="$pkg_reqs lapack"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers_dft"\
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="$pkg_cfg --with-system-zlib"
pkg_cfg="$pkg_cfg --with-system-bzlib"
pkg_cfg="$pkg_cfg --with-system-xz"
pkg_cfg="$pkg_cfg --with-system-pcre"
pkg_cfg="$pkg_cfg --with-jpeglib"
pkg_cfg="$pkg_cfg --with-libpng"
pkg_cfg="$pkg_cfg --with-blas"
pkg_cfg="$pkg_cfg --with-lapack"
pkg_cfg="$pkg_cfg --with-ICU"
pkg_cfg="$pkg_cfg --with-tcltk"
pkg_cfg="$pkg_cfg --disable-R-framework"
pkg_cfg="$pkg_cfg --without-aqua"
pkg_cfg="$pkg_cfg --with-libintl-prefix=\"$BLDR_GETTEXT_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-cairo=\"$BLDR_CAIRO_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-tcl-config=\"$BLDR_TCL_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-tk-config=\"$BLDR_TK_BASE_PATH\""

####################################################################################################
# build and install pkg as local module
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://cran.ms.unimelb.edu.au/src/base/R-2/$pkg_file"

    bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_vers_dft"\
          --info        "$pkg_info"    \
          --description "$pkg_desc"    \
          --file        "$pkg_file"    \
          --url         "$pkg_urls"    \
          --uses        "$pkg_uses"    \
          --requires    "$pkg_reqs"    \
          --options     "$pkg_opts"    \
          --cflags      "$pkg_cflags"  \
          --ldflags     "$pkg_ldflags" \
          --config      "$pkg_cfg"     \
          --config-path "$pkg_cfg_path"
done

####################################################################################################
