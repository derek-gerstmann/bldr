#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="tracing"
pkg_name="tau"
pkg_vers="2.21.4"

pkg_info="TAU is a program and performance analysis tool framework."

pkg_desc="TAU is a program and performance analysis tool framework being developed 
for the DOE Office of Science, ASC initiatives at LLNL, the ZeptoOS project at ANL, 
and the Los Alamos National Laboratory. TAU provides a suite of static and dynamic 
tools that provide graphical user interaction and inter-operation to form an integrated 
analysis environment for parallel Fortran, C++, C, Java, and Python applications. 

In particular, a robust performance profiling facility available in TAU has been applied 
extensively in the ACTS toolkit. Also, recent advancements in TAU's code analysis 
capabilities have allowed new static tools to be developed, such as an automatic 
instrumentation tool. These two features of the TAU framework are described below."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://tau.uoregon.edu/tau.tgz"
pkg_opts="configure"
pkg_reqs=""
pkg_reqs="$pkg_reqs papi/latest"
pkg_reqs="$pkg_reqs pdt/latest"
pkg_reqs="$pkg_reqs vtf/latest"
pkg_reqs="$pkg_reqs otf/latest"
pkg_reqs="$pkg_reqs scalasca/latest"
pkg_reqs="$pkg_reqs python/2.7.3"
pkg_reqs="$pkg_reqs openmpi/1.6"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg --category    "$pkg_ctry"    \
                 --name        "$pkg_name"    \
                 --version     "$pkg_vers"    \
                 --requires    "$pkg_reqs"    \
                 --uses        "$pkg_uses"    \
                 --options     "$pkg_opts"

####################################################################################################

pkg_cfg="-pthread"
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg="--enable-static --enable-shared --enable-all-mpi-wrappers"
pkg_cfg="$pkg_cfg -pthread"
pkg_cfg="$pkg_cfg -papithreads"
pkg_cfg="$pkg_cfg -mpi"
pkg_cfg="$pkg_cfg -mpiinc=\"$BLDR_OPENMPI_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -mpilib=\"$BLDR_OPENMPI_LIB_PATH\""
pkg_cfg="$pkg_cfg -papi=\"$BLDR_PAPI_BASE_PATH\""
pkg_cfg="$pkg_cfg -otf=\"$BLDR_OTF_BASE_PATH\""
pkg_cfg="$pkg_cfg -vtf=\"$BLDR_VTF_BASE_PATH\""
pkg_cfg="$pkg_cfg -pdt=\"$BLDR_PDT_BASE_PATH\""
pkg_cfg="$pkg_cfg -scalasca=\"$BLDR_SCALASCA_BASE_PATH\""
pkg_cfg="$pkg_cfg -pythoninc=\"$BLDR_PYTHON_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg -pythonlib=\"$BLDR_PYTHON_LIB_PATH\""

if [ -d "/usr/local/cuda" ]
then
     pkg_cfg="$pkg_cfg -cuda=/usr/local/cuda"
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

# if [ $BLDR_SYSTEM_IS_OSX == true ]
# then
#      bldr_log_warning "$pkg_name isn't supported on MacOSX.  Skipping..."
#      bldr_log_split
# else
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
# fi

