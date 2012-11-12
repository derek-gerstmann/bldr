#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="openmpi"

pkg_default="1.6.3"
pkg_variants=("1.6.3")

pkg_info="The Open MPI Project is an open source MPI-2 implementation that is developed and maintained by a consortium of academic, research, and industry partners."

pkg_desc="The Open MPI Project is an open source MPI-2 implementation that is developed and 
maintained by a consortium of academic, research, and industry partners. 

Open MPI is therefore able to combine the expertise, technologies, and resources from all 
across the High Performance Computing community in order to build the best MPI library available. 

Open MPI offers advantages for system and software vendors, application developers and computer 
science researchers."

pkg_opts="configure skip-xcode-config enable-static enable-shared"
pkg_reqs="zlib papi "
if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
    pkg_reqs+="ftb valgrind "
    pkg_uses="$pkg_reqs torque gfortran"
else
    pkg_uses="$pkg_reqs gfortran"
fi

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                    \
    --category    "$pkg_ctry"       \
    --name        "$pkg_name"       \
    --version     "$pkg_default"    \
    --requires    "$pkg_reqs"       \
    --uses        "$pkg_uses"       \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg="--enable-btl-openib-failover "
pkg_cfg+="--enable-mpi-f77 "
pkg_cfg+="--enable-mpi-f90 "
pkg_cfg+="--enable-mpi-thread-multiple "
pkg_cfg+="--enable-heterogeneous "

if [[ $BLDR_SYSTEM_IS_OSX == false ]]
then
    pkg_cfg+="--with-valgrind=\"$BLDR_VALGRIND_BASE_PATH\" "
fi

#
# Disable vampire trace avoids build errors on OSX:
#
# - Building OpenMPI > v1.6.x on OSX causes error due to missing GCC internal
#   '__builtin_expect' directives when compiling with LLVM-GCC
#
if [[ $BLDR_SYSTEM_IS_OSX == true ]] 
then
    pkg_cfg+="--disable-vt "
else
    pkg_cfg+="--with-ftb=\"$BLDR_FTB_BASE_PATH\" "
    pkg_cfg+="--with-tm=\"$BLDR_TORQUE_BASE_PATH\" "
fi

if [[ $BLDR_SYSTEM_IS_LINUX == true ]] 
then
     pkg_cflags+="-I/usr/include/infiniband "    
     pkg_cflags+="-I/usr/include/infiniband/opensm "    
     pkg_cfg+="--with-libltdl=external "
     pkg_cfg+="--with-psm=no "
     pkg_cfg+="--with-gnu-ld "
     pkg_cfg+="--with-threads=posix "
     pkg_cfg+="--enable-openib-dynamic-sl "
     pkg_cfg+="--enable-openib-rdmacm "
     pkg_cfg+="--enable-openib-connectx-xrc "
     pkg_cfg+="--enable-mca-no-build=psm "
     pkg_cfg+="--disable-mmap-shmem "
     pkg_cfg+="--with-openib=/usr "

     if [[ -d "/usr/local/cuda" ]]
     then
         pkg_cfg+="-with-cuda "
     fi

#     if [[ -d "/opt/mellanox/mxm/lib" ]]
#     then
#          pkg_cfg+="--with-mxm=/opt/mellanox/mxm "
#     fi
#     if [[ -d "/opt/mellanox/fca/lib" ]]
#     then
#          pkg_cfg+="--with-fca=/opt/mellanox/fca "
#     fi
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
     pkg_file="$pkg_name-$pkg_vers.tar.bz2"
     pkg_urls="http://www.open-mpi.org/software/ompi/v1.6/downloads/$pkg_file"

     bldr_register_pkg                \
         --category    "$pkg_ctry"    \
         --name        "$pkg_name"    \
         --version     "$pkg_vers"    \
         --default     "$pkg_default" \
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

