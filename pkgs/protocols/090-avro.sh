#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="avro"
pkg_vers="1.7.1"

pkg_info="Apache Avro is a data serialisation system."

pkg_desc="Apache Avro is a data serialisation system.

Avro relies on schemas. When Avro data is read, the schema used when writing 
it is always present. This permits each datum to be written with no per-value 
overheads, making serialization both fast and small. This also facilitates use 
with dynamic, scripting languages, since data, together with its schema, is 
fully self-describing.

When Avro data is stored in a file, its schema is stored with it, so that files 
may be processed later by any program. If the program reading the data expects 
a different schema this can be easily resolved, since both schemas are present.

When Avro is used in RPC, the client and server exchange schemas in the connection 
handshake. (This can be optimized so that, for most calls, no schemas are actually 
transmitted.) Since both client and server both have the other's full schema, 
correspondence between same named fields, missing fields, extra fields, etc. 
can all be easily resolved.

Avro schemas are defined with JSON . This facilitates implementation in languages 
that already have JSON libraries."

pkg_file="$pkg_name-cpp-$pkg_vers.tar.gz"
pkg_urls="http://mirror.overthewire.com.au/pub/apache/$pkg_name/$pkg_name-$pkg_vers/cpp/$pkg_file;http://mirror.nexcess.net/apache/$pkg_name/$pkg_name-$pkg_vers/cpp/$pkg_file"
pkg_opts="cmake"
pkg_reqs="zlib/latest boost/latest"
pkg_uses="$pkg_reqs"


####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_vers"    \
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""

pkg_cflags="-I$BLDR_BOOST_INCLUDE_PATH"
pkg_ldflags="-L$BLDR_BOOST_LIB_PATH:-lboost_program_options"

pkg_cfg="-DMAKESTATIC=1:-DLINKSTATIC=1"
pkg_cfg="$pkg_cfg:-DZLIB_INCLUDE_DIR=\"$BLDR_LOCAL_PATH/compression/zlib/latest/include\""
pkg_cfg="$pkg_cfg:-DZLIB_LIBRARY=\"$BLDR_ZLIB_LIB_PATH/libz.a\""
pkg_cfg="$pkg_cfg:-DBoost_NO_SYSTEM_PATHS=ON"
pkg_cfg="$pkg_cfg:-DBoost_NO_BOOST_CMAKE=ON"
pkg_cfg="$pkg_cfg:-DBoost_DIR=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBoost_INCLUDE_DIR=\"$BLDR_BOOST_BASE_PATH/include\""
pkg_cfg="$pkg_cfg:-DBOOST_ROOT=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg:-DBOOST_INCLUDEDIR=\"$BLDR_BOOST_BASE_PATH/include\""

####################################################################################################
# build and install pkg as local module
####################################################################################################

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

####################################################################################################
