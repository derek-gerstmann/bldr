#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="1.6"
pkg_vers_list=("$pkg_vers" "1.6.1")
pkg_ctry="distributed"
pkg_name="openmpi"

pkg_info="The Open MPI Project is an open source MPI-2 implementation that is developed and maintained by a consortium of academic, research, and industry partners."

pkg_desc="The Open MPI Project is an open source MPI-2 implementation that is developed and 
maintained by a consortium of academic, research, and industry partners. 

Open MPI is therefore able to combine the expertise, technologies, and resources from all 
across the High Performance Computing community in order to build the best MPI library available. 

Open MPI offers advantages for system and software vendors, application developers and computer 
science researchers."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://www.open-mpi.org/software/ompi/v1.6/downloads/$pkg_file"
pkg_opts="configure skip-xcode-config"
pkg_reqs="zlib/latest papi/latest"
if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
     pkg_reqs="$pkg_reqs ftb/latest valgrind/latest"
fi
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


pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-btl-openib-failover"
pkg_cfg="$pkg_cfg --enable-static"
pkg_cfg="$pkg_cfg --enable-shared"
pkg_cfg="$pkg_cfg --enable-heterogeneous"
pkg_cfg="$pkg_cfg --enable-mpi-thread-multiple"
pkg_cfg="$pkg_cfg --with-tm=\"$BLDR_TORQUE_BASE_PATH\""

#
# Disable vampire trace avoids build errors on OSX:
#
# - Building OpenMPI > v1.6.x on OSX causes error due to missing GCC internal
#   '__builtin_expect' directives when compiling with LLVM-GCC
#
if [[ $BLDR_SYSTEM_IS_OSX == true ]] 
then
    pkg_cfg="$pkg_cfg --disable-vt "
else
    pkg_cfg="$pkg_cfg --with-ftb=\"$BLDR_FTB_BASE_PATH\""
    pkg_cfg="$pkg_cfg --with-valgrind=\"$BLDR_VALGRIND_BASE_PATH\""
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]] 
then
     pkg_cflags="$pkg_cflags -fPIC"
     pkg_cflags="$pkg_cflags -I/usr/include/infiniband"    
     pkg_cflags="$pkg_cflags -I/usr/include/infiniband/opensm"    
     pkg_cfg="$pkg_cfg --with-libltdl=external"
     pkg_cfg="$pkg_cfg --with-psm=no"
     pkg_cfg="$pkg_cfg --with-gnu-ld"
     pkg_cfg="$pkg_cfg --with-threads=posix"
     pkg_cfg="$pkg_cfg --enable-openib-dynamic-sl"
     pkg_cfg="$pkg_cfg --enable-openib-rdmacm"
     pkg_cfg="$pkg_cfg --enable-openib-connectx-xrc"
     pkg_cfg="$pkg_cfg --enable-mca-no-build=psm"
     pkg_cfg="$pkg_cfg --disable-mmap-shmem"
     pkg_cfg="$pkg_cfg --with-openib=/usr"
     if [[ -d "/opt/mellanox/mxm/lib" ]]
     then
          pkg_cfg="$pkg_cfg --with-mxm=/opt/mellanox/mxm"
     fi
     if [[ -d "/opt/mellanox/fca/lib" ]]
     then
          pkg_cfg="$pkg_cfg --with-fca=/opt/mellanox/fca"
     fi
fi

####################################################################################################
# build and install pkg as local module
####################################################################################################

for omp_vers in "${pkg_vers_list[@]}"
do
     pkg_file="$pkg_name-$omp_vers.tar.bz2"
     pkg_urls="http://www.open-mpi.org/software/ompi/v1.6/downloads/$pkg_file"

     bldr_build_pkg --category    "$pkg_ctry"    \
                    --name        "$pkg_name"    \
                    --version     "$omp_vers"    \
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

