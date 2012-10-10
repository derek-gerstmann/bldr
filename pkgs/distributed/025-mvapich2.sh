#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="mvapich2"

pkg_default="1.9a"
pkg_variants=("1.8.1" "1.9a")

pkg_info="MVAPICH2 aka MPI-2 over OpenFabrics-IB, OpenFabrics-iWARP, PSM, uDAPL and TCP/IP."

pkg_desc="MVAPICH2 aka MPI-2 over OpenFabrics-IB, OpenFabrics-iWARP, PSM, uDAPL and TCP/IP

This is an MPI-2 implementation (conforming to MPI 2.2 standard) which includes all 
MPI-1 features. It is based on MPICH2 and MVICH. The latest release is MVAPICH2 1.8 
(includes MPICH2 1.4.1p1). It is available under BSD licensing."

pkg_opts="configure skip-fetch skip-compile skip-install skip-migrate keep-existing-install "
pkg_reqs=""
pkg_uses="$pkg_reqs"

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""

####################################################################################################
# register each pkg version with bldr
####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
     bldr_log_status "$pkg_name $pkg_vers is not building on OSX right now.  Skipping ..."
     bldr_log_split
else
     let pkg_idx=0
     for pkg_vers in ${pkg_variants[@]}
     do
          pkg_site=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers
          if [[ -d $pkg_site ]]; then
	      bldr_remove_dir $pkg_site
          fi
          bldr_make_dir $pkg_site
	  bldr_log_split

          pkg_sup=${pkg_support[$pkg_idx]}
          pkg_file="$pkg_name-$pkg_vers.tgz"
          pkg_urls="http://mvapich.cse.ohio-state.edu/download/mvapich2/$pkg_file"
          pkg_reqs="mvapich2-runtime/$pkg_vers "
	  pkg_reqs+="mvapich2-mpiexec/$pkg_vers "
          pkg_uses="$pkg_reqs"

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

         let pkg_idx++
     done
fi

####################################################################################################


