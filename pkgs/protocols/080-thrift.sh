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

pkg_info="The Apache Thrift software framework provides scalable cross-language services development tools."

pkg_desc="The Apache Thrift software framework, for scalable cross-language services 
development, combines a software stack with a code generation engine to build services 
that work efficiently and seamlessly between C++, Java, Python, PHP, Ruby, Erlang, Perl, 
Haskell, C#, Cocoa, JavaScript, Node.js, Smalltalk, OCaml and Delphi and other languages."

pkg_default="0.8.0"
pkg_variants=("$pkg_default")

pkg_opts="configure "
pkg_opts+="force-serial-build "
pkg_opts+="use-build-makefile=Makefile "
thr_opts=$pkg_opts

pkg_reqs="libtool "
pkg_reqs+="bison "
pkg_reqs+="flex "
pkg_reqs+="boost "
pkg_reqs+="openssl "
pkg_reqs+="libevent "
pkg_reqs+="python "
pkg_reqs+="glib "
pkg_uses="$pkg_reqs"

####################################################################################################
# satisfy pkg dependencies and load their environment settings
####################################################################################################

bldr_satisfy_pkg               \
  --category    "$pkg_ctry"    \
  --name        "$pkg_name"    \
  --version     "$pkg_default"\
  --requires    "$pkg_reqs"    \
  --uses        "$pkg_uses"    \
  --options     "$pkg_opts"

####################################################################################################

pkg_cfg=""
pkg_cflags="-I$BLDR_OPENSSL_INCLUDE_PATH"
pkg_ldflags="-L$BLDR_OPENSSL_LIB_PATH"

pkg_cfg="--with-c_glib "
pkg_cfg+="--with-ruby=no "
pkg_cfg+="--with-php=no "
pkg_cfg+="--with-erlang=no "
pkg_cfg+="--with-boost=\"$BLDR_BOOST_BASE_PATH\" "
pkg_cfg+="--with-libevent=\"$BLDR_LIBEVENT_BASE_PATH\" "
pkg_cfg+="--with-zlib=\"$BLDR_ZLIB_BASE_PATH\" "
pkg_cfg+="PY_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/python "
pkg_cfg+="JAVA_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/java "
pkg_cfg+="PERL_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/perl "
pkg_cfg+="PHP_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/php "
pkg_cfg+="PHP_CONFIG_PREFIX=$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/php/etc "

####################################################################################################
# register each pkg version with bldr
####################################################################################################

for pkg_vers in ${pkg_variants[@]}
do
    pkg_file="$pkg_name-$pkg_vers.tar.gz"
    pkg_urls="https://dist.apache.org/repos/dist/release/$pkg_name/$pkg_vers/$pkg_file"

    pkg_opts="$thr_opts"
    pkg_opts+="-EPYTHONPATH+=$BLDR_LOCAL_ENV_PATH/$pkg_ctry/$pkg_name/$pkg_vers/bindings/python/lib/python2.7/site-packages "

    bldr_register_pkg                  \
          --category    "$pkg_ctry"    \
          --name        "$pkg_name"    \
          --version     "$pkg_vers"    \
          --default     "$pkg_default"\
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
          --config-path "."
done

####################################################################################################
