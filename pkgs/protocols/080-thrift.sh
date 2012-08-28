#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="protocols"
pkg_name="thrift"
pkg_vers="0.8.0"

pkg_info="The Apache Thrift software framework provides scalable cross-language services development tools."

pkg_desc="The Apache Thrift software framework, for scalable cross-language services 
development, combines a software stack with a code generation engine to build services 
that work efficiently and seamlessly between C++, Java, Python, PHP, Ruby, Erlang, Perl, 
Haskell, C#, Cocoa, JavaScript, Node.js, Smalltalk, OCaml and Delphi and other languages."

pkg_file="$pkg_name-$pkg_vers.tar.gz"
pkg_urls="https://dist.apache.org/repos/dist/release/$pkg_name/$pkg_vers/$pkg_file"
pkg_opts="configure force-serial-build -EPYTHONPATH+=$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/python/lib/python2.7/site-packages"
pkg_reqs="pkg-config/latest"
pkg_reqs="$pkg_reqs bison/latest"
pkg_reqs="$pkg_reqs flex/latest"
pkg_reqs="$pkg_reqs boost/latest"
pkg_reqs="$pkg_reqs openssl/latest"
pkg_reqs="$pkg_reqs libevent/latest"
pkg_reqs="$pkg_reqs python/2.7.3"
pkg_reqs="$pkg_reqs glib/latest"
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
pkg_cflags="-I$BLDR_OPENSSL_INCLUDE_PATH"
pkg_ldflags="-L$BLDR_OPENSSL_LIB_PATH"

pkg_cfg="--with-c_glib --with-ruby=no --with-php=no --with-erlang=no"
pkg_cfg="$pkg_cfg --with-boost=\"$BLDR_BOOST_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-libevent=\"$BLDR_LIBEVENT_BASE_PATH\""
pkg_cfg="$pkg_cfg --with-zlib=\"$BLDR_ZLIB_BASE_PATH\""
pkg_cfg="$pkg_cfg PY_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/python"
pkg_cfg="$pkg_cfg JAVA_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/java"
pkg_cfg="$pkg_cfg PERL_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/perl"
pkg_cfg="$pkg_cfg PHP_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/php"
pkg_cfg="$pkg_cfg PHP_CONFIG_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/php/etc"

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

