#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_vers="0.9.0"
pkg_ctry="distributed"
pkg_name="mesos"

pkg_info="Apache Mesos is a cluster manager that provides efficient resource isolation and sharing across distributed applications, or frameworks."

pkg_desc="Apache Mesos is a cluster manager that provides efficient resource isolation and 
sharing across distributed applications, or frameworks. It can run Hadoop, MPI, Hypertable, 
Spark (a new framework for low-latency interactive and iterative jobs), and other applications.
 Mesos is open source in the Apache Incubator."

pkg_opts="configure skip-auto-compile-flags"
pkg_reqs="python/2.7.3 cppunit/latest"

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    pkg_opts="$pkg_opts use-config-script=configure.macosx"

elif [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    pkg_opts="$pkg_opts use-config-scripts=configure"
    pkg_reqs="$pkg_reqs libunwind/latest"

else
    pkg_opts="$pkg_opts use-config-scripts=configure"
fi

pkg_uses="$pkg_uses"

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
pkg_cfg=""
pkg_cfg="$pkg_cfg --with-webui"
pkg_cfg="$pkg_cfg --with-included-zookeeper"
pkg_cfg="$pkg_cfg --with-python-headers=\"$BLDR_PYTHON_INCLUDE_PATH\""
pkg_cfg="$pkg_cfg PYTHON=\"$BLDR_PYTHON_BIN_PATH/python\""

####################################################################################################

if [[ $BLDR_SYSTEM_IS_OSX == true ]]
then
    export JAVA_HEADERS="/System/Library/Frameworks/JavaVM.framework/Versions/A/Headers"
    export JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers"
else
    if [[ -d "/usr/java/default" ]]
    then
        pkg_cfg="$pkg_cfg JAVA_HOME=\"/usr/java/default\""
    fi
fi

####################################################################################################
# build and install each pkg version as local module
####################################################################################################

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="http://apache.mirror.uber.com.au/incubator/mesos/mesos-0.9.0-incubating/mesos-0.9.0-incubating.tar.gz"
bldr_build_pkg                   \
    --category    "$pkg_ctry"    \
    --name        "$pkg_name"    \
    --version     "$pkg_vers"    \
    --info        "$pkg_info"    \
    --description "$pkg_desc"    \
    --file        "$pkg_file"    \
    --url         "$pkg_urls"    \
    --uses        "$pkg_uses"    \
    --requires    "$pkg_reqs"    \
    --options     "$pkg_opts"    \
    --patch       "$pkg_patch"   \
    --cflags      "$pkg_cflags"  \
    --ldflags     "$pkg_ldflags" \
    --config      "$pkg_cfg"

####################################################################################################
# build and install the trunk as a local module
####################################################################################################

# pkg_vers="trunk"
# pkg_file="$pkg_name-$pkg_vers.tar.gz"
# pkg_urls="git://git.apache.org/mesos.git"
# pkg_opts="$pkg_opts force-bootstrap no-bootstrap-prefix"
# bldr_build_pkg                   \
#     --category    "$pkg_ctry"    \
#     --name        "$pkg_name"    \
#     --version     "$pkg_vers"    \
#     --info        "$pkg_info"    \
#     --description "$pkg_desc"    \
#     --file        "$pkg_file"    \
#     --url         "$pkg_urls"    \
#     --uses        "$pkg_uses"    \
#     --requires    "$pkg_reqs"    \
#     --options     "$pkg_opts"    \
#     --patch       "$pkg_patch"   \
#     --cflags      "$pkg_cflags"  \
#     --ldflags     "$pkg_ldflags" \
#     --config      "$pkg_cfg"
