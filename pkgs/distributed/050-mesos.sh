#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="distributed"
pkg_name="mesos"

pkg_default="0.9.0"
pkg_variants=("0.9.0")
pkg_distribs=("mesos-0.9.0-incubating.tar.gz")
pkg_mirrors=("http://apache.mirror.uber.com.au/incubator/mesos/mesos-0.9.0-incubating")

pkg_info="Apache Mesos is a cluster manager that provides efficient resource isolation and sharing across distributed applications, or frameworks."

pkg_desc="Apache Mesos is a cluster manager that provides efficient resource isolation and 
sharing across distributed applications, or frameworks. It can run Hadoop, MPI, Hypertable, 
Spark (a new framework for low-latency interactive and iterative jobs), and other applications.
 Mesos is open source in the Apache Incubator."

pkg_opts="configure "
pkg_opts+="skip-auto-compile-flags "

pkg_reqs="python "
pkg_reqs+="cppunit "

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    pkg_opts+="use-config-script=configure.macosx "

elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    pkg_opts+="use-config-scripts=configure "
    pkg_reqs+="libunwind "

else
    pkg_opts+="use-config-scripts=configure "
fi

pkg_uses="$pkg_uses"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg                 \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_default" \
    --requires    "$pkg_reqs"    \
    --uses        "$pkg_uses"    \
    --options     "$pkg_opts"

####################################################################################################

pkg_cflags=""
pkg_ldflags=""

pkg_cfg=""
pkg_cfg+="--with-webui "
pkg_cfg+="--with-included-zookeeper "
pkg_cfg+="--with-python-headers=\"$BLDR_PYTHON_INCLUDE_PATH\" "
pkg_cfg+="PYTHON=\"$BLDR_PYTHON_BIN_PATH/python\" "

####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    export JAVA_HEADERS="/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers"
    export JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers"
else
    if [[ -d "/usr/java/default" ]]
    then
        pkg_cfg+="JAVA_HOME=\"/usr/java/default\" "
    fi
fi

####################################################################################################
# register each pkg version with bldr
####################################################################################################

let pkg_idx=0
for pkg_vers in ${pkg_variants[@]}
do
    pkg_file=${pkg_distribs[$pkg_idx]}
    pkg_host=${pkg_mirrors[$pkg_idx]}
    pkg_urls="$pkg_host/$pkg_urls"

    bldr_register_pkg                 \
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

####################################################################################################
