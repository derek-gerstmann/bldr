#!/bin/bash

####################################################################################################
# import the BLDR system
####################################################################################################

source "bldr.sh"

####################################################################################################
# setup pkg definition and resource files
####################################################################################################

pkg_ctry="compilers"
pkg_name="binutils"
pkg_vers="2.22"
pkg_info="The GNU Binutils are a collection of binary tools (eg for linking and assembling)."

pkg_desc="The GNU Binutils are a collection of binary tools. The main ones are:

* ld - the GNU linker.
* as - the GNU assembler.

But they also include:

* addr2line - Converts addresses into filenames and line numbers.
* ar - A utility for creating, modifying and extracting from archives.
* c++filt - Filter to demangle encoded C++ symbols.
* dlltool - Creates files for building and using DLLs.
* gold - A new, faster, ELF only linker, still in beta test.
* gprof - Displays profiling information.
* nlmconv - Converts object code into an NLM.
* nm - Lists symbols from object files.
* objcopy - Copys and translates object files.
* objdump - Displays information from object files.
* ranlib - Generates an index to the contents of an archive.
* readelf - Displays information from any ELF format object file.
* size - Lists the section sizes of an object or archive file.
* strings - Lists printable strings from files.
* strip - Discards symbols.
* windmc - A Windows compatible message compiler.
* windres - A compiler for Windows resource files.

Most of these programs use BFD, the Binary File Descriptor library, to do low-level manipulation. Many of them also use the opcodes library to assemble and disassemble machine instructions.

The binutils have been ported to most major Unix variants as well as Wintel systems, and their main reason for existence is to give the GNU system (and GNU/Linux) the facility to compile and link programs."

pkg_file="$pkg_name-$pkg_vers.tar.bz2"
pkg_urls="http://ftp.gnu.org/gnu/$pkg_name/$pkg_file"
pkg_opts="configure"
pkg_reqs=""
pkg_uses=""
pkg_cflags=""
pkg_ldflags=""
pkg_cfg="" 

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


