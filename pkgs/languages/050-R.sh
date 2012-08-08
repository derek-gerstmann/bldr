#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ver_list=("2.15.1")
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

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://cran.ms.unimelb.edu.au/src/base/R-2/$pkg_file"
pkg_opts="configure"
pkg_reqs="zlib/latest bzip2/latest tcl/latest tk/latest cairo/latest libpng/latest libjpeg/latest gsl/latest lapack/latest"
pkg_uses="$pkg_reqs"

pkg_cfg="$pkg_cfg --with-system-zlib"
pkg_cfg="$pkg_cfg --with-system-bzlib"
pkg_cfg="$pkg_cfg --with-system-xz"
pkg_cfg="$pkg_cfg --with-blas"
pkg_cfg="$pkg_cfg --with-lapac"
pkg_cfg="$pkg_cfg --with-cairo"
pkg_cfg="$pkg_cfg --with-jpeglib"
pkg_cfg="$pkg_cfg --with-libpng"
pkg_cfg="$pkg_cfg --with-cairo=$BLDR_LOCAL_PATH/graphics/cairo/latest"
pkg_cfg="$pkg_cfg --with-tcl-config=$BLDR_LOCAL_PATH/languages/tcl/latest/include"
pkg_cfg="$pkg_cfg --with-tk-config=$BLDR_LOCAL_PATH/languages/tk/latest/include"

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

for pkg_vers in ${pkg_ver_list}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://cran.ms.unimelb.edu.au/src/base/R-2/$pkg_file"

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
done
