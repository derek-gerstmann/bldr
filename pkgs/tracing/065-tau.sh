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

pkg_vers_dft="2.21.4"
pkg_vers_list=("$pkg_vers_dft")

pkg_opts="configure enable-static enable-shared"
pkg_reqs=""
pkg_reqs="$pkg_reqs papi"
pkg_reqs="$pkg_reqs pdt"
pkg_reqs="$pkg_reqs vtf"
pkg_reqs="$pkg_reqs otf"
pkg_reqs="$pkg_reqs scalasca"
pkg_reqs="$pkg_reqs python"
pkg_reqs="$pkg_reqs openmpi"
pkg_reqs="$pkg_reqs gfortran"
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_vers_dft"   \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cfg="-pthread"
pkg_cfg_path=""
pkg_cflags=""
pkg_ldflags=""

####################################################################################################

pkg_cfg="--enable-all-mpi-wrappers"
pkg_cfg="$pkg_cfg -pthread"
pkg_cfg="$pkg_cfg -papithreads"
pkg_cfg="$pkg_cfg -cc=mpicc"
pkg_cfg="$pkg_cfg -c++=mpicxx"
pkg_cfg="$pkg_cfg -fortran=mpif90"
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
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_vers_list[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="http://tau.uoregon.edu/tau.tgz"

    bldr_register_pkg                \
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
