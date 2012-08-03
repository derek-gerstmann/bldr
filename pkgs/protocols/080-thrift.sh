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
pkg_opts="configure force-serial-build -EPYTHONPATH+=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/python/lib/python2.7/site-packages"
pkg_reqs="bison/latest flex/latest boost/latest openssl/latest libevent/latest python/2.7.3 glib/latest"
pkg_uses="m4/latest autoconf/latest automake/latest libtool/latest zlib/latest $pkg_reqs"
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="--with-c_glib --with-ruby=no --with-php=no"
pkg_cfg="$pkg_cfg --with-boost=$BLDR_LOCAL_PATH/developer/boost/latest"
pkg_cfg="$pkg_cfg --with-libevent=$BLDR_LOCAL_PATH/system/libevent/latest"
pkg_cfg="$pkg_cfg --with-zlib=$BLDR_LOCAL_PATH/internal/zlib/latest"
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

