#!/bin/bash

####################################################################################################
##
## License:    The MIT License
## 
## Copyright (c) 2012. Derek Gerstmann, The University of Western Australia.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
## THE SOFTWARE.
##  
####################################################################################################

export BLDR_VERSION_MAJOR="1"
export BLDR_VERSION_MINOR="0"
export BLDR_VERSION_PATCH="0"
export BLDR_VERSION_STR="v$BLDR_VERSION_MAJOR.$BLDR_VERSION_MINOR.$BLDR_VERSION_PATCH"

####################################################################################################

BLDR_PARALLEL=${BLDR_PARALLEL:=true}
BLDR_VERBOSE=${BLDR_VERBOSE:=false}
BLDR_DEBUG=${BLDR_DEBUG:=false}
BLDR_INITIALIASED=${BLDR_INITIALIASED:=false}
BLDR_LOADED_MODULES=${BLDR_LOADED_MODULES:=""}

BLDR_USE_PKG_CTRY=${BLDR_USE_PKG_CTRY:=""}
BLDR_USE_PKG_NAME=${BLDR_USE_PKG_NAME:=""}
BLDR_USE_PKG_VERS=${BLDR_USE_PKG_VERS:=""}

BLDR_XCODE_SDK=${BLDR_XCODE_SDK:=""}
BLDR_XCODE_BASE=${BLDR_XCODE_BASE:="/Developer"}

BLDR_OSX_SYSROOT=${BLDR_OSX_SYSROOT:=""}
BLDR_OSX_ARCHITECTURES=${BLDR_OSX_ARCHITECTURES:=""}
BLDR_OSX_DEPLOYMENT_TARGET=${BLDR_OSX_DEPLOYMENT_TARGET:=""}

####################################################################################################

if [ -t 1 ] ; 
then 
    BLDR_TXT_HEADER="\033[1;34m"    # bold blue
    BLDR_TXT_TITLE="\033[1;37m"     # bold white
    BLDR_TXT_ERROR="\033[1;31m"     # bold red
    BLDR_TXT_WARN="\033[1;33m"      # bold yellow
    BLDR_TXT_CMD="\033[1;32m"       # bold reen
    BLDR_TXT_INFO="\033[0;37m"      # white
    BLDR_TXT_RST="\033[0m"          # reset
else
    BLDR_TXT_HEADER=""
    BLDR_TXT_TITLE=""
    BLDR_TXT_ERROR=""
    BLDR_TXT_WARN=""
    BLDR_TXT_CMD=""
    BLDR_TXT_INFO=""
    BLDR_TXT_RST=""
fi

####################################################################################################

function bldr_get_stdout()
{
    local output=""    
    if [ $BLDR_VERBOSE != false ]
    then
        output="&>1"
    else
        output="&>/dev/null"
    fi
    echo $output
}

function bldr_make_lowercase()
{
    echo $1 | tr '[:upper:]' '[:lower:]'
}

function bldr_make_uppercase()
{
    echo $1 | tr '[:lower:]' '[:upper:]'
}

function bldr_resolve_path()
{
    cd "$1" 2>/dev/null || return $? 
    local resolved="`pwd -P`"
    echo "$resolved"
}

function bldr_unquote_str
{
    echo "${@}" | sed 's/^"*//g' | sed 's/"*$//g' 
}

function bldr_trim_str
{
    echo "${@}" | sed 's/^ *//g' | sed 's/ *$//g' 
}

function bldr_trim_list_str
{
    echo "${@}" | sed 's/^:*//g' | sed 's/:*$//g'
}

function bldr_trim_url_str
{
    echo "${@}" | sed 's/^;*//g' | sed 's/;*$//g'
}

function bldr_match_str
{
    local $str
    local $fnd
    local cnt=$(echo $str | grep -m1 -c '^'$fnd':')
    echo "$cnt"
}

function bldr_quote_str
{
    local filename=$1

    sed $filename \
        -e 's#\\#\\\\#' \
        -e 's#/#\\/#' \
        -e 's#\.#\\.#' \
        -e 's#\*#\\*#' \
        -e 's#\[#\\[#'

    return $?
}

function bldr_split_str
{
    local BLDR_DEFAULT_DELIMITER=" "

    local a_delimiter="${1:-$BLDR_DEFAULT_DELIMITER}"
    local a_inputfile="$2"

    awk -F "$a_delimiter" \
    '{  for(i = 1; i <= NF; i++) {
            print $i
        }
    }' $a_inputfile

    return $?
}

function bldr_join_str
{
    local BLDR_DEFAULT_DELIMITER=" "

    local a_delimiter="${1:-$BLDR_DEFAULT_DELIMITER}"
    local a_inputfile="$2"

    awk -v usersep="$a_delimiter" '
    BEGIN{
        sep=""; # Start with no bldr_log_split (before the first item)
    }
    {
        printf("%s%s", sep, $0);
        (NR == 1) && sep = usersep; # Separator is set after the first item.
    }
    END{
        print "" # Print a new line at the end.
    }' $a_inputfile
    
    return $?
}

function bldr_echo()
{
    echo "${@}"
}

function bldr_log_info()
{
    echo -e ${BLDR_TXT_HEADER}"-- ${@} "${BLDR_TXT_RST}
}

function bldr_log_warning()
{
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    echo -e ${BLDR_TXT_WARN}"[ ${ts} ]"${BLDR_TXT_ERROR}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_error()
{
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    echo -e ${BLDR_TXT_ERROR}"[ ${ts} ]"${BLDR_TXT_WARN}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_status()
{
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    echo -e ${BLDR_TXT_HEADER}"[ ${ts} ]"${BLDR_TXT_TITLE}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_cmd()
{
    local first_line=true
    local line_string=""
    local log_lines=$(echo ${@} | bldr_split_str ' \n')
    for word in ${log_lines}
    do
        line_string="$line_string $word"
        if [[ ${#line_string} -ge 1 ]]
        then
            if [ $first_line == true ]
            then
                echo -e ${BLDR_TXT_TITLE}">"${BLDR_TXT_CMD}" $line_string "${BLDR_TXT_RST}
                first_line=false
            else
                line_string=$(bldr_trim_str $line_string)
                echo -e ${BLDR_TXT_TITLE}"      "${BLDR_TXT_CMD}" $line_string "${BLDR_TXT_RST}
            fi
        fi
        line_string=""
    done

    if [[ ${#line_string} -ge 1 ]]
    then
        line_string=$(bldr_trim_str $line_string)
        echo -e ${BLDR_TXT_TITLE}"      "${BLDR_TXT_CMD}" $line_string "${BLDR_TXT_RST}
        line_string=""
    fi
}

function bldr_exec()
{
    bldr_log_cmd "${@}"
    eval "${@}" 
}

function bldr_log_split()
{
    bldr_echo "---------------------------------------------------------------------------------------------------------------"
}

function bldr_format_version()
{
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

function bldr_is_newer_version()
{
    if [[ ! $(echo -e "$1\n$2" | sort -r --version-sort | head -1) == "$1" ]]; then
        return true
    fi
    return false
}

function bldr_find_latest_version_dir()
{
    local path=$1
    bldr_push_dir $path
    local latest=$(find ./ -maxdepth 1 -mindepth 1 -type d | sort -r --version-sort | head -1)
    bldr_pop_dir
    echo "$latest"
}

####################################################################################################

# setup project paths
BLDR_ABS_PWD="$( cd "$( dirname "$0" )/.." && pwd )"
BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"
BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD" )"

# try one level up if we aren't resolving the root dir
if [ "$BLDR_BASE_PATH" != "bldr" ]
then
    BLDR_ABS_PWD="$( cd "$( dirname "$0" )/../.." && pwd )"
    BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"
    BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD" )"
fi

####################################################################################################

# ensure we are run inside of the root dir
if [ "$BLDR_BASE_PATH" != "bldr" ]
then
    echo "Please execute package build script from within the 'bldr' subfolder: '$BLDR_ABS_PWD'!"
    exit 0
fi 

####################################################################################################

# setup system paths
BLDR_CONFIG_PATH=${BLDR_CONFIG_PATH:=$BLDR_ABS_PWD}
export BLDR_SCRIPTS_PATH="$BLDR_CONFIG_PATH/scripts"
export BLDR_PKGS_PATH="$BLDR_CONFIG_PATH/pkgs"
export BLDR_PATCHES_PATH="$BLDR_CONFIG_PATH/patches"
export BLDR_SYSTEM_PATH="$BLDR_CONFIG_PATH/system"
export BLDR_CACHE_PATH="$BLDR_CONFIG_PATH/cache"
export BLDR_BUILD_PATH="$BLDR_CONFIG_PATH/build"

# setup install paths
BLDR_INSTALL_PATH=${BLDR_INSTALL_PATH:=$BLDR_ABS_PWD}
export BLDR_LOCAL_PATH="$BLDR_INSTALL_PATH/local"
export BLDR_MODULE_PATH="$BLDR_INSTALL_PATH/modules"
export BLDR_OS_LIB_EXT="a"

####################################################################################################

export BLDR_SYSTEM_IS_LINUX=$( uname -s | grep -m1 -c Linux )
if [ "$BLDR_SYSTEM_IS_LINUX" -eq 1 ]
then
    export BLDR_OS_NAME="lnx"
fi

export BLDR_SYSTEM_IS_OSX=$( uname -s | grep -m1 -c Darwin )
if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
then
    export BLDR_OS_NAME="osx"

    # Locate the SDK for OSX based on the active XCode environment
    if [ "$BLDR_XCODE_SDK" == "" ]
    then

        BLDR_XCODE_SELECT=$(which xcode-select)
        if [ -x "$BLDR_XCODE_SELECT" ]
        then
            export BLDR_XCODE_BASE=$(xcode-select --print-path)
            if [ -d "$BLDR_XCODE_BASE/Platforms/MacOSX.platform" ]
            then
                BLDR_XCODE_SDK="$BLDR_XCODE_BASE/Platforms/MacOSX.platform/Developer/SDKs"
            fi
        fi

        if [ -d "$BLDR_XCODE_SDK/MacOSX10.6.sdk" ]
        then
            export BLDR_XCODE_SDK="$BLDR_XCODE_SDK/MacOSX10.6.sdk"
            export BLDR_OSX_ARCHITECTURES="i386"
            export BLDR_OSX_SYSROOT="$BLDR_XCODE_SDK"
            export BLDR_OSX_DEPLOYMENT_TARGET=10.6
        else
            if [ -d "$BLDR_XCODE_SDK/MacOSX10.7.sdk" ]
            then
                    export BLDR_XCODE_SDK="$BLDR_XCODE_SDK/MacOSX10.7.sdk"
                    export BLDR_OSX_ARCHITECTURES="x86_64"
                    export BLDR_OSX_SYSROOT="$BLDR_XCODE_SDK"
                    export BLDR_OSX_DEPLOYMENT_TARGET=10.7
            else
                if [ -d "$BLDR_XCODE_SDK/MacOSX10.8.sdk" ]
                then
                    export BLDR_XCODE_SDK="$BLDR_XCODE_SDK/MacOSX10.8.sdk"
                    export BLDR_OSX_ARCHITECTURES="x86_64"
                    export BLDR_OSX_SYSROOT="$BLDR_XCODE_SDK"
                    export BLDR_OSX_DEPLOYMENT_TARGET=10.8
                fi                    
            fi        
        fi
    fi
    
    # Use the chosen SDK for OSX
    if [ "$BLDR_OSX_SYSROOT" != "" ]
    then
        export MACOSX_DEPLOYMENT_TARGET=$BLDR_OSX_DEPLOYMENT_TARGET
        export BLDR_XCODE_LDFLAGS="-arch:$BLDR_OSX_ARCHITECTURES:-isysroot:$BLDR_OSX_SYSROOT:-L$BLDR_OSX_SYSROOT/usr/lib"
        export BLDR_XCODE_CFLAGS="-arch:$BLDR_OSX_ARCHITECTURES:-isysroot:$BLDR_OSX_SYSROOT:-I$BLDR_OSX_SYSROOT/usr/include"
    fi
fi

export BLDR_SYSTEM_IS_CENTOS=0
if [ "$BLDR_SYSTEM_IS_LINUX" -eq 1 ]
then
    if [ -e /etc/redhat-release ]
    then
        export BLDR_SYSTEM_IS_CENTOS=$( cat /etc/redhat-release | grep -m1 -c CentOS )
    fi
fi

if [ "$BLDR_OS_NAME" == "" ]
then
    echo "Operating system is unknown and not detected properly.  Please update detection routine!"
    exit 0
fi 

####################################################################################################

function bldr_load_internal()
{
    if [ -d "$BLDR_LOCAL_PATH/internal" ]
    then
        loaded_internal=false
        for internal_path in "$BLDR_LOCAL_PATH/internal"/*
        do
            if [ $BLDR_DEBUG != false ]
            then
                bldr_log_info "Using internal utility: '$internal_path'"
                loaded_internal=true
            fi
            if [[ -d "$internal_path/latest/bin" ]]
            then
                export PATH="$internal_path/latest/bin:$PATH"
            fi
            if [[ -d "$internal_path/latest/lib" ]]
            then
                export LD_LIBRARY_PATH="$internal_path/latest/lib:$LD_LIBRARY_PATH"
                if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
                then
                    export DYLD_LIBRARY_PATH="$internal_path/latest/lib:$DYLD_LIBRARY_PATH"
                fi
            fi
        done
        if [ $loaded_internal != false ]
        then
            bldr_log_split
        fi
    fi
}

function bldr_load_modules()
{
    if [ -d "$BLDR_LOCAL_PATH/internal/modules/latest" ]
    then
        for md_path in "$BLDR_LOCAL_PATH/internal/modules/latest/Modules"/*
        do
            if [[ -d "$md_path/bin" ]]
            then
                export PATH="$md_path/bin:$PATH"
            fi
            if [[ -d "$md_path/init" ]]
            then
                source "$md_path/init/bash"
            fi
        done

        if [ -d "$BLDR_MODULE_PATH/internal" ]
        then
            module use "$BLDR_MODULE_PATH/internal"
            for internal_path in "$BLDR_MODULE_PATH/internal"/*
            do
                local internal_base=$(basename $internal_path)
                if [ $BLDR_DEBUG != false ]
                then
                    bldr_log_info "Using internal module: '$internal_base'"
                fi
                module -f add $internal_base
            done
        fi
        
        if [ -d "$BLDR_MODULE_PATH/system" ]
        then
            module use "$BLDR_MODULE_PATH/system"
        fi

        for md_path in $BLDR_MODULE_PATH/*
        do
            local md_name=$(basename $md_path)
            module use "$BLDR_MODULE_PATH/$md_name"
        done
    fi
}

# setup the environment to support our own version of PKG_CONFIG
function bldr_load_pkgconfig()
{
    if [ -d "$BLDR_LOCAL_PATH/internal/pkg-config/latest/bin" ]
    then
        if [ ! -d "$BLDR_LOCAL_PATH/internal/pkg-config/latest/lib/pkgconfig" ]
        then
            mkdir -p "$BLDR_LOCAL_PATH/internal/pkg-config/latest/lib/pkgconfig"
        fi

        export PKG_CONFIG=$BLDR_LOCAL_PATH/internal/pkg-config/latest/bin/pkg-config
        export PKG_CONFIG_PATH=$BLDR_LOCAL_PATH/internal/pkg-config/latest/lib/pkgconfig
    fi
}

####################################################################################################

# import our internal tools for usage
if [[ $BLDR_INITIALIASED == false ]]; then
    bldr_load_internal
    bldr_load_modules
    bldr_load_pkgconfig
    BLDR_INITIALIASED=true
fi

####################################################################################################

function bldr_locate_makefile
{
    local make_path="."
    local given=$(bldr_trim_str "$1")
    local mk_paths=$(bldr_trim_str "$given . ./build ../build .. ../src ../source")
    local tst_path=""

    if [ -f "CMakeLists.txt" ] && [ -f "build/Makefile" ]
    then
        make_path="build"
    else
        for tst_path in ${mk_paths}
        do
            if [ -f "$tst_path/Makefile" ]
            then
                make_path="$tst_path"
                break
            fi
        done
    fi
    echo "$make_path"
}

function bldr_locate_boot_script
{
    local found_path="."
    local given=$(bldr_trim_str "$1")
    local cfg_paths=$(bldr_trim_str "$given . build source src ../build ../source ../src")
    local cfg_files="bootstrap bootstrap.sh autogen.sh"

    local tst_path=""
    local tst_file=""

    for tst_path in ${cfg_paths}
    do
        for tst_file in ${cfg_files}
        do
            if [ -f "$tst_path/$tst_file" ]
            then
                found_path="$tst_path/$tst_file"
                break
            fi
        done
        if [ $found_path != "." ]
        then
            break
        fi
    done
    echo "$found_path"
}

function bldr_locate_boot_path
{
    local given=$(bldr_trim_str "$1")
    local script=$(bldr_locate_boot_script "$given")
    local path=$(dirname "$script")
    echo "$path"
}

function bldr_locate_config_script
{
    local cfg_srch=$(bldr_trim_str "$1")
    local cfg_opts=$2
    local cfg_paths=$(bldr_trim_str "$cfg_srch . source src build .. ../build ../source ../src")
    local found_path="."

    local cmake_files="CMakeLists.txt"
    local autocfg_files="configure configure.sh bootstrap bootstrap.sh autogen.sh config"

    local use_cmake=true
    local use_autocfg=true

    if [[ $(echo $cfg_opts | grep -m1 -c 'cmake' ) > 0 ]]
    then
        use_cmake=true
        use_autocfg=false
    
    elif [[ $(echo $cfg_opts | grep -m1 -c 'config' ) > 0 ]]
    then
        use_cmake=false
        use_autocfg=true
    fi

    local tst_path=""
    local cmake_tst_file=""
    local autocfg_tst_file=""
    for tst_path in ${cfg_paths}
    do
        if [ $use_autocfg == true ]
        then
            for autocfg_tst_file in ${autocfg_files}
            do
                if [ -f "$tst_path/$autocfg_tst_file" ]
                then
                    found_path="$tst_path/$autocfg_tst_file"
                    break
                fi
            done
        fi
        if [ $use_cmake == true ]
        then
            for cmake_tst_file in ${cmake_files}
            do
                if [ -f "$tst_path/$cmake_tst_file" ]
                then
                    found_path="$tst_path/$cmake_tst_file"
                    break
                fi
            done
        fi

        if [ $found_path != "." ]
        then
            break
        fi
    done

    echo "$found_path"
}

function bldr_locate_config_path
{
    local srch=$(bldr_trim_str "$1")
    local script=$(bldr_locate_config_script "$srch" "$2")
    local found_path=$(dirname "$script")
    echo "$found_path"
}

function bldr_output_header()
{
    local msg=$@
    bldr_log_split
    bldr_log_status "${msg}"
    bldr_log_split
}

function bldr_bail
{
    local msg=$@

    bldr_log_split
    bldr_log_error "ERROR: ${msg}. Exiting..."
    bldr_log_split

    exit 1
}

function try
{
    $@
    if test $? -ne 0 ; then
        bldr_bail "$@"
    fi
}

function bldr_exit_on_failure
{
    if test $? -ne 0 ; then
        bldr_bail "$1"
    fi
}

function bldr_clone()
{
    local url=$1
    local dir=$2

    local cmd="$(which git)"
    if [ -e $cmd ];
    then
        cmd="git clone"
        $cmd $url $dir || bldr_bail "Failed to clone '$url' into '$dir'"
    else
        bldr_bail "Failed to locate 'git' command!  Please install this command line utility!"
    fi
    bldr_log_split
}

function bldr_checkout()
{
    local url=$1
    local dir=$2

    url="${url/svn/http}"
    local cmd="$(which svn)"
    if [ -e $cmd ];
    then
        cmd="svn export"
        $cmd $url $dir || bldr_bail "Failed to bldr_checkout '$url' into '$dir'"
    else
        bldr_bail "Failed to locate 'svn' command!  Please install this command line utility!"
    fi
    bldr_log_split
}

function bldr_fetch() 
{
    local url=$1
    local archive=$2
    local dir=$3

    local usepipe=0
    local cmd="$(which wget)"
    if [ ! -e $cmd ];
    then
        cmd="$(which curl)"
        if [ -e $cmd ];
        then
            cmd="curl -f -L -O"
            usepipe=1
        else
            bldr_bail "Failed to locate either 'wget' or 'curl' for fetching packages!  Please install one of these utilties!"
        fi
    else
        cmd="wget --progress=dot -O"
    fi

    if [ ! -e $archive ]; then
        bldr_log_status "Fetching '$archive'..."
        bldr_log_split
        if [ "$usepipe" -eq 1 ]
        then
            bldr_log_cmd "$cmd $url > $archive"
            bldr_log_split
            $cmd $url > $archive
        else
            bldr_log_cmd "$cmd $archive $url"
            bldr_log_split
            $cmd $archive $url
        fi
        bldr_log_split
        bldr_log_info "Downloaded '$url' to '$archive'..."
    fi
}

function bldr_get_archive_flag()
{
    local is="z"
    local archive=$1
    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  is="j";;
        *.tar.gz)   is="z";;
        *.tar.xz)   is="J";;
        *.bz2)      is="j";;
        *.gz)       is="z";;
        *.tar)      is="";;
        *.tbz2)     is="j";;
        *.tgz)      is="z";;
        *)          is=0;;
       esac    
    fi
    echo "$is"
}

function bldr_is_valid_archive()
{
    local is=0
    local archive=$1
    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  is=1;;
        *.tar.gz)   is=1;;
        *.tar.xz)   is=1;;
        *.bz2)      is=1;;
        *.rar)      is=1;;
        *.gz)       is=1;;
        *.tar)      is=1;;
        *.tbz2)     is=1;;
        *.tgz)      is=1;;
        *.zip)      is=1;;
        *.Z)        is=1;;
        *.7z)       is=1;;
        *)          is=0;;
       esac    
    fi
    echo "$is"
}

function bldr_extract_archive()
{
    local archive=$1
    local extr=$(which tar)

    if [ -e $BLDR_LOCAL_PATH/gtar/latest/bin/tar ]
    then
        extr=$BLDR_LOCAL_PATH/gtar/latest/bin/tar
    fi

    local output=$(bldr_get_stdout)  
    if [ $BLDR_VERBOSE != false ]
    then
        bldr_log_split
    fi

    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  eval $extr xvjf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar.gz)   eval $extr xvzf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar.xz)   eval $extr Jxvf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.bz2)      eval bunzip2 ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.rar)      eval unrar x ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.gz)       eval gunzip ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar)      eval $extr xvf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tbz2)     eval $extr xvjf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.tgz)      eval $extr xvzf ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.zip)      eval unzip -uo ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.Z)        eval uncompress ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *.7z)       eval 7z x ${archive} $output || bldr_bail "Failed to extract archive '${archive}'";;
        *)          bldr_bail "Failed to extract archive '${archive}'";;
       esac    
    fi
}

function bldr_strip_archive_ext()
{
    local archive=$1
    local result=""

    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  result=$(echo ${archive%.tar.bz2} );;
        *.tar.gz)   result=$(echo ${archive%.tar.gz} );;
        *.tar.xz)   result=$(echo ${archive%.tar.xz} );;
        *.bz2)      result=$(echo ${archive%.bz2} );;
        *.rar)      result=$(echo ${archive%.rar} );;
        *.gz)       result=$(echo ${archive%.gz} );;
        *.tar)      result=$(echo ${archive%.tar} );;
        *.tbz2)     result=$(echo ${archive%.tbz2} );;
        *.tgz)      result=$(echo ${archive%.tgz} );;
        *.zip)      result=$(echo ${archive%.zip} );;
        *.Z)        result=$(echo ${archive%.Z} );;
        *.7z)       result=$(echo ${archive%.7z} );;
        *)          bldr_bail "Failed to extract archive contents '${archive}'";;
       esac    
    fi

    echo $result
}

function bldr_list_archive()
{
    local archive=$1
    local extr=$(which tar)
    local result=""

    if [ -e $BLDR_LOCAL_PATH/gtar/latest/bin/tar ]
    then
        extr=$BLDR_LOCAL_PATH/gtar/latest/bin/tar
    fi

    if [ -f $archive ] ; then
       case $archive in
        *.tar.bz2)  result=$(eval $extr tjf ${archive} );;
        *.tar.gz)   result=$(eval $extr tzf ${archive} );;
        *.tar.xz)   result=$(eval $extr Jtf ${archive} );;
        *.tar)      result=$(eval $extr tf ${archive} );;
        *.tbz2)     result=$(eval $extr tjf ${archive} );;
        *.tgz)      result=$(eval $extr tzf ${archive} );;
        *.zip)      result=$(eval unzip -l ${archive} );;
        *)          bldr_bail "Failed to extract archive contents '${archive}'";;
       esac    
    fi

    local basedir=$(echo "$result" | grep -m1 -E -o "(\S+)/" )

    if [ "$basedir" == "" ]
    then
        basedir=$(bldr_strip_archive_ext "$archive")
    fi

    echo "$basedir"
}

function bldr_make_dir()
{
    local dir=$1
    bldr_log_info "Creating '$dir'"
    mkdir -p ${dir} || bldr_bail "Failed to create directory '${dir}'"
}

function bldr_remove_dir()
{
    local dir=$1
    local force=$2
    if [ "$dir" = "/" ] 
    then
        bldr_bail "Invalid directory name requested for removal: '${dir}'"
    fi

    bldr_log_info "Removing '$dir'"
    if [ ${force} ]; then
        rm -r ${dir}  || bldr_bail "Failed to remove directory '${dir}'"
    else
        if [ -d "${dir}" ]; then
            chmod -R +rw ${dir} || bldr_bail "Failed to remove directory '${dir}'"
            rm -r ${dir}  || bldr_bail "Failed to remove directory '${dir}'"
        fi
    fi
}

function bldr_push_dir()
{
    local dir=$1
    pushd ${dir} > /dev/null || bldr_bail "Failed to push directory '${dir}'"
}

function bldr_pop_dir()
{
    local dir=$1
    popd  > /dev/null  || bldr_bail "Failed to pop directory!"
}

function bldr_move_file()
{
    local src=$1
    local dst=$2
    mv ${src} ${dst}  || bldr_bail "Failed to move file!"
}

function bldr_remove_file()
{
    local src=$1
    rm ${src} || bldr_bail "Failed to remove file!"
}

function bldr_apply_patch()
{
    local patch_file=$1
    local patch_cmd=$(which patch)

    # strip leading index '000_' from file name
    local patch_base="$(basename $patch_file)"
    local path_length=${#patch_base}
    local patch_path=$(echo $patch_base|sed 's/^[0-9]*_//g' )

    # split filename into dir parts replacing '_' with '/'
    patch_path=$(echo $patch_path|sed 's/_/\//g')

    if [[ $(echo $patch_file | grep -m1 -c '.diff$' ) > 0 ]]
    then
        # remove '.diff' suffix from filename
        patch_path=$(echo $patch_path|sed 's/.diff$//g')

        # provide the specific source file for the diff based on the name we reconstructed
        patch_cmd="$patch_cmd $patch_path -N"
        bldr_log_cmd "patch $patch_path < $patch_file"
        bldr_log_split
    
        eval $patch_cmd < $patch_file 
        bldr_log_split

    elif [[ $(echo $patch_file | grep -m1 -c '.patch$' ) > 0 ]]
    then

        # assume a unified top-level patch
        patch_cmd="$patch_cmd -p1 -N"
        bldr_log_cmd "patch -p1 < $patch_file"
        bldr_log_split

        eval $patch_cmd < $patch_file 
        bldr_log_split

    elif [[ $(echo $patch_file | grep -m1 -c '.ed$' ) > 0 ]]
    then
        # remove '.ed' suffix from filename
        patch_path=$(echo $patch_path|sed 's/.ed$//g')

        # use 'ed' to apply the patch
        patch_cmd=$(which ed)
        patch_cmd="$patch_cmd - $patch_path"

        eval $patch_cmd < $patch_file 
        bldr_log_split
    fi
}

function bldr_copy_file()
{
    local src=$1
    local dst=$2
    local frc=$3
    if [ $frc ]
    then
        cp -f ${src} ${dst}  || bldr_bail "Failed to copy file!"
    else
        cp ${src} ${dst}  || bldr_bail "Failed to copy file!"
    fi
}

function bldr_make_archive()
{
    local archive=$1
    local dir=$2
    local flags=$(bldr_get_archive_flag "${archive}")
    flags="c${flags}f"

    bldr_log_cmd "tar ${flags} \"${archive}\" \"${dir}\""
    bldr_log_split   

    eval tar "${flags}" "${archive}" "${dir}" || bldr_bail "Failed to create archive!"
}

function bldr_cursor_pos()
{
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    # tput u7 > /dev/tty    # when TERM=xterm (and relatives)
    
    IFS=';' read -r -d R -a pos
    stty $oldstty
    
    # change from one-based to zero based so they work with: tput cup $row $col
    local row=$((${pos[0]:2} - 1))    # strip off the esc-[
    local col=$((${pos[1]} - 1))
    
    echo "$row $col"
}

function bldr_copy_dir()
{
    local src=$1
    local dst=$2

    bldr_log_info "Copying '$src' to '$dst' ..."
    if [ "$BLDR_SYSTEM_IS_LINUX" -eq 1 ]
    then
        # echo cp -TRv $src $dst
        cp -TR $src $dst || bldr_bail "Failed to copy from '$src' to '$dst'"
    elif [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
    then
        # echo ditto -v $src $dst
        ditto $src $dst || bldr_bail "Failed to copy from '$src' to '$dst'"
    fi
}

function bldr_download_pkg()
{
    local pkg_name="$1"
    local pkg_vers="$2"
    local pkg_urls="$3"
    local pkg_file="$4"
    local use_verbose="$5"

    local pkg_url_list=$(echo $pkg_urls | bldr_split_str ';')
    for url in ${pkg_url_list}
    do
        bldr_log_info "Retrieving package '$pkg_name/$pkg_vers' from '$url'"
        bldr_log_split

        if [[ $(echo "$url" | grep -m1 -c '^http://') == 1 ]]
        then
            bldr_fetch $url $pkg_file 
        
        elif [[ $(echo "$url" | grep -m1 -c '^https://') == 1 ]]
        then
            bldr_fetch $url $pkg_file 

        elif [[ $(echo "$url" | grep -m1 -c '^ftp://') == 1 ]]
        then
            bldr_fetch $url $pkg_file 

        elif [[ $(echo "$url" | grep -m1 -c '^git://') == 1 ]]
        then
            bldr_clone $url $pkg_name 

            if [ -d $pkg_name ]
            then
                bldr_log_split
                bldr_log_info "Archiving package '$pkg_file' from '$pkg_name/$pkg_vers'"
                bldr_make_archive $pkg_file $pkg_name
            fi

        elif [[ $(echo "$url" | grep -m1 -c '^svn://') == 1 ]]
        then
            bldr_checkout $url $pkg_name 

            if [ -d $pkg_name ]
            then
                bldr_log_split
                bldr_log_info "Archiving package '$pkg_file' from '$pkg_name/$pkg_vers'"
                bldr_make_archive $pkg_file $pkg_name
            fi
        fi

        if [ -e $pkg_file ]; then
            break;
        fi
    done
}

####################################################################################################

function bldr_build_all()
{
    local dir="${1}"
    if [[ -d $dir ]]
    then
        local builder
        for builder in "$dir"/*
        do
            if [[ -f $builder ]]
            then
                eval $builder
            fi
        done
    fi
}

function bldr_has_pkg()
{
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_opts=""

    while true ; do
        case "$1" in
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           * )              break ;;
        esac
    done

    local existing="false"
    local found=""
    if [ -d "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        existing="true"
        local pkg_mtime=0
        local bld_mtime=0
        for found in $BLDR_PKGS_PATH/$pkg_ctry/*
        do
            if [[ $(echo $found | grep -m1 -c 'pkg_name' ) < 1 ]]; then
                continue
            fi

            if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
            then
                if [[ $(echo $BLDR_LOADED_MODULES | grep -m1 -c 'coreutils' ) > 0 ]]; then
                    pkg_mtime=$(stat --printf '%Y\n' $found )
                    bld_mtime=$(stat --printf '%Y\n' $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers )
                else
                    pkg_mtime=$(stat -f %m $found )
                    bld_mtime=$(stat -f %m $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers )
                fi
            else
                pkg_mtime=$(stat --printf '%Y\n' "$found" )
                bld_mtime=$(stat --printf '%Y\n' "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" )
            fi

            if [[ $pkg_mtime -gt $bld_mtime ]]
            then
                existing="false"
                break
            else
                existing="true"
                break
            fi             
        done
    fi

    echo "$existing"
    
#    echo "Tested: $pkg_spec -nt $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
}

function bldr_setup_pkg()
{
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-setup' ) > 0 ]]
    then
        return
    fi

    bldr_log_status "Setting up package '$pkg_name/$pkg_vers' for '$BLDR_OS_NAME' ... "
    bldr_log_split
    
    if [ ! -d $BLDR_BUILD_PATH ]
    then
        bldr_make_dir "$BLDR_BUILD_PATH"
        bldr_log_split
    fi

    if [ -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_info "Removing stale build '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_remove_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    fi

    if [ -f "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_info "Removing stale module '$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_remove_file "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    fi

    if [ -d "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_info "Removing stale install '$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers'"
        bldr_log_split
        bldr_remove_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    fi
}

function bldr_fetch_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-fetch' ) > 0 ]]
    then
        return
    fi

    # create the local cache dir if it doesn't exist
    if [ ! -d $BLDR_CACHE_PATH ]
    then
        bldr_make_dir "$BLDR_CACHE_PATH"
        bldr_log_split
    fi

    local filesize=0
    if [ -e "$BLDR_CACHE_PATH/$pkg_file" ]
    then
        local archive_test=$(bldr_list_archive "$BLDR_CACHE_PATH/$pkg_file" )
        if [[ $(echo "$archive_test" | grep -m1 -c 'error') == 1 ]]
        then
            bldr_log_info "Existing package file in cache appears invalid ($filesize < 4096 bytes!).  Retrieving '$pkg_name/$pkg_vers' again ..."
            bldr_log_split
            bldr_remove_file "$BLDR_CACHE_PATH/$pkg_file"
        fi
    fi

    # if a local copy doesn't exist, grab the pkg from the url
    bldr_push_dir "$BLDR_CACHE_PATH"
    if [ ! -e "$BLDR_CACHE_PATH/$pkg_file" ]
    then
        bldr_download_pkg "$pkg_name" "$pkg_vers" "$pkg_urls" "$pkg_file" "$use_verbose"
    fi
    bldr_pop_dir

    # extract any pkg archives
    bldr_log_info "Checking package '$BLDR_CACHE_PATH/$pkg_file'"
    bldr_log_split

    if [[ $(bldr_is_valid_archive "$BLDR_CACHE_PATH/$pkg_file") > 0 ]]
    then
        bldr_log_info "Cloning package '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$pkg_file'"
        bldr_log_split

        if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name" ]
        then
            bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name"
            bldr_log_split
        fi

        if [ -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
        then
            bldr_remove_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
            bldr_log_split
        fi

        bldr_copy_file "$BLDR_CACHE_PATH/$pkg_file" "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_file"

        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name"
        local archive_listing=$(bldr_list_archive $pkg_file)
        bldr_log_info "Extracting package '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_file' as '$archive_listing'"

        if [ $BLDR_VERBOSE == false ]
        then
            bldr_log_split
        fi

        bldr_extract_archive "$pkg_file" 
        bldr_move_file "$archive_listing" "$pkg_vers"
        bldr_remove_file "$pkg_file"
        bldr_pop_dir
    fi
}

function bldr_boot_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_patches=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    bldr_log_status "Booting package '$pkg_name/$pkg_vers'"
    bldr_log_split

    if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_log_split
    fi

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path $pkg_opts)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    local patch_file=""
    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-system-patches' ) > 0 ]]
    then
        bldr_log_info "Skipping system patches ..."
        bldr_log_split
    else
        # common patches
        for patch_file in $BLDR_PATCHES_PATH/$pkg_name/$pkg_vers/common/*
        do
            if [ -f "$patch_file" ] 
            then
                bldr_log_info "Applying patch from file '$patch_file' ..."
                bldr_log_split

                bldr_apply_patch $patch_file
                bldr_log_split
            fi
        done

        # os-specific patches
        for patch_file in $BLDR_PATCHES_PATH/$pkg_name/$pkg_vers/$BLDR_OS_NAME/*
        do
            if [ -f "$patch_file" ] 
            then
                bldr_log_info "Applying patch from file '$patch_file' ..."
                bldr_log_split

                bldr_apply_patch $patch_file
                bldr_log_split
            fi
        done
    fi

    patch_file=""
    pkg_patches=$(bldr_trim_list_str "$pkg_patches")
    if [ "$pkg_patches" != "" ] && [ "$pkg_patches" != " " ] && [ "$pkg_patches" != ":" ]
    then
        pkg_patches=$(echo $pkg_patches|sed 's/:/ /g')
    else
        pkg_patches=""
    fi

    for patch_file in ${pkg_patches}
    do
        if [ -f "$patch_file" ] 
        then
            bldr_log_info "Applying patch from file '$patch_file' ..."
            bldr_log_split

            bldr_apply_patch $patch_file
            bldr_log_split
        fi
    done
    bldr_pop_dir

    pkg_uses=$(bldr_trim_list_str "$pkg_uses")
    if [ "$pkg_uses" != "" ] && [ "$pkg_uses" != " " ] && [ "$pkg_uses" != ":" ]
    then
        pkg_uses=$(echo $pkg_uses | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_uses=""
    fi

    local cmd_mod="$(which modulecmd)"
    if [[ "$pkg_uses" != "" && "$cmd_mod" != "" ]]
    then
        if [ -d "$BLDR_MODULE_PATH/$pkg_ctry" ]
        then
            module use "$BLDR_MODULE_PATH/$pkg_ctry"
        fi

        for using in ${pkg_uses}
        do
            if [[ $(echo $BLDR_LOADED_MODULES | grep -m1 -c '$using' ) > 0 ]]; then
                bldr_log_info "Loading module '$using' ..."
                module -f load $using
                BLDR_LOADED_MODULES="$BLDR_LOADED_MODULES:$using"
            fi
        done
        bldr_log_split
    fi

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"
    local bootstrap=false
    if [ ! -x "./configure" ] && [ ! -x "./configure.sh" ] && [ ! -x "./config" ]
    then
        bootstrap=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-boot' ) > 0 ]]
    then
        bldr_log_info "Skipping bootstrap ..."
        bldr_log_split
        bootstrap=false
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'force-bootstrap' ) > 0 ]]
    then
        bldr_log_info "Forcing bootstrap ..."
        bldr_log_split
        bootstrap=true
    fi
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local boot_path=$(bldr_locate_boot_path $pkg_cfg_path)
    bldr_pop_dir

    # bootstrap package
    if [ $bootstrap == false ]
    then
        bldr_log_info "No bootstrap script detected.  Skipping... "
        bldr_log_split
    else
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$boot_path"
        local boot_cmd=$(bldr_locate_boot_script $pkg_cfg_path)
        local output=$(bldr_get_stdout)

        if [ -x "$boot_cmd" ] && [ "$boot_cmd" != "." ]
        then

            if [[ $(echo $pkg_opts | grep -m1 -c 'no-bootstrap-prefix' ) > 0 ]]
            then

                bldr_log_cmd "$boot_cmd"
                bldr_log_split

                if [ $BLDR_VERBOSE != false ]
                then
                    eval $boot_cmd || bldr_bail "Failed to boot package '$pkg_name/$pkg_vers'!"
                    bldr_log_split
                else
                    eval $boot_cmd &> /dev/null || bldr_bail "Failed to boot package '$pkg_name/$pkg_vers'!"
                fi

            else

                bldr_log_cmd "$boot_cmd --prefix=\"$prefix\""
                bldr_log_split

                if [ $BLDR_VERBOSE != false ]
                then
                    eval $boot_cmd --prefix="$prefix" || bldr_bail "Failed to boot package '$pkg_name/$pkg_vers'!"
                    bldr_log_split
                else
                    eval $boot_cmd --prefix="$prefix" &> /dev/null || bldr_bail "Failed to boot package '$pkg_name/$pkg_vers'!"
                fi
            fi
        else
            if [ $BLDR_VERBOSE != false ]
            then
                bldr_log_info "Failed to locate boot script.  Skipping... "
                bldr_log_split
            fi
        fi
        bldr_pop_dir
    fi
}

function bldr_cmake_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-config' ) > 0 ]]
    then
        return
    fi

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path $pkg_opts)
    bldr_pop_dir

    bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/build"
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/build"

    bldr_log_split
  
    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local env_mpath=""
    local env_flags=" "
    pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
    if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
    then
        pkg_cfg=$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_cfg=""
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        local env_cflags=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str ";")
        local env_c_mpath=$(echo $env_cflags | sed 's/\-I//g')
        env_c_mpath=$(echo $env_c_mpath | sed 's/\/include;/;/g')
        
        local env_split_cflags=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str " ")
        env_flags="$env_flags -DCMAKE_C_FLAGS='$env_split_cflags'"
        env_flags="$env_flags -DCMAKE_CPP_FLAGS='$env_split_cflags'"
        env_flags="$env_flags -DCMAKE_CXX_FLAGS='$env_split_cflags'"
        env_mpath="$env_c_mpath;$env_mpath"
    else
        pkg_cflags=""
    fi

    pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
    if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
    then
        local env_ldflags=$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str ";")
        local env_ld_mpath=$(echo $env_ldflags | sed 's/\-L//g')
        env_ld_mpath=$(echo $env_ld_mpath | sed 's/\/lib;/;/g')
        env_ld_mpath=$(echo $env_ld_mpath | sed 's/\/lib32;/;/g')
        env_ld_mpath=$(echo $env_ld_mpath | sed 's/\/lib64;/;/g')
        local env_split_ldflags=$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")
        env_flags="$env_flags -DCMAKE_EXE_LINKER_FLAGS='$env_split_ldflags'"
        env_flags="$env_flags -DCMAKE_MODULE_LINKER_FLAGS='$env_split_ldflags'"
        env_mpath="$env_ld_mpath;$env_mpath"
    else
        pkg_ldflags=""
    fi

    env_flags="-DCMAKE_PREFIX_PATH=\"$env_mpath\" $env_flags $pkg_cfg"

    local cmake_src_path="$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"
    bldr_log_status "Configuring package '$pkg_name/$pkg_vers' from source folder '$cmake_src_path' ..."
    bldr_log_split

    local cmake_exec="$BLDR_LOCAL_PATH/internal/cmake/latest/bin/cmake"
    local cmake_mod="-DCMAKE_MODULE_PATH=$BLDR_LOCAL_PATH/internal/cmake/latest/share/cmake-2.8/Modules"
    local cmake_pre="-DCMAKE_INSTALL_PREFIX=$prefix"

    if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
    then
        cmake_pre="$cmake_pre -DCMAKE_OSX_ARCHITECTURES=$BLDR_OSX_ARCHITECTURES"
        cmake_pre="$cmake_pre -DCMAKE_OSX_SYSROOT=$BLDR_OSX_SYSROOT"
        cmake_pre="$cmake_pre -DCMAKE_OSX_DEPLOYMENT_TARGET=$BLDR_OSX_DEPLOYMENT_TARGET"
    fi

    local use_static=false
    local use_shared=false

    if [[ $(echo $pkg_opts | grep -m1 -c 'enable-shared' ) > 0 ]]
    then
        bldr_log_info "Adding shared library configuration ..."
        bldr_log_split
        cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=ON"
        use_shared=true
    fi
    
    if [[ $(echo $pkg_opts | grep -m1 -c 'enable-static' ) > 0 ]]
    then
        bldr_log_info "Adding static library configuration ..."
        bldr_log_split
        cmake_pre="$cmake_pre -DBUILD_STATIC_LIBS=ON"
        use_static=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'force-shared' ) > 0 ]]
    then
        bldr_log_info "Forcing shared library configuration ..."
        bldr_log_split
        if [ use_shared != true ]
        then
            cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF"
        fi
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'force-static' ) > 0 ]]
    then
        bldr_log_info "Forcing static library configuration ..."
        bldr_log_split
        if [ use_static != true ]
        then
            cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON"
        fi
    fi

    bldr_log_cmd "$cmake_exec $cmake_pre $env_flags $cmake_src_path"
    bldr_log_split

    if [ $BLDR_VERBOSE != false ]
    then
        eval $cmake_exec $cmake_mod $cmake_pre $env_flags $cmake_src_path || bldr_bail "Failed to configure: '$prefix'"
        bldr_log_split
    else
        eval $cmake_exec $cmake_mod $cmake_pre $env_flags $cmake_src_path &>/dev/null || bldr_bail "Failed to configure: '$prefix'"
    fi

    bldr_log_info "Done configuring package '$pkg_name/$pkg_vers'"
    bldr_pop_dir
}

function bldr_autocfg_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_patches=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-config' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    if [[ $(echo $pkg_opts | grep -m1 -c 'use-build-dir' ) > 0 ]]
    then
        bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/build"
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/build"
    else
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    fi

    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path $pkg_opts)
    bldr_pop_dir

    local env_flags=" "
    pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
    if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
    then
        pkg_cfg=$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_cfg=""
    fi

    if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
    then
        if [[ $(echo $pkg_opts | grep -m1 -c 'disable-xcode-cflags' ) > 0 ]]
        then
            bldr_log_info "Disabling XCode Compile FLAGS ..."
            bldr_log_split
        else
            pkg_cflags="$pkg_cflags:$BLDR_XCODE_CFLAGS"
        fi

        if [[ $(echo $pkg_opts | grep -m1 -c 'disable-xcode-ldflags' ) > 0 ]]
        then
            bldr_log_info "Disabling XCode Linker FLAGS ..."
            bldr_log_split
        else
            pkg_ldflags="$pkg_ldflags:$BLDR_XCODE_LDFLAGS"
        fi
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        pkg_cflags=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str " ")
        if [ "$BLDR_SYSTEM_IS_CENTOS" -eq 1 ]
        then
            pkg_cflags="$pkg_cflags":-I/usr/include
        fi
    else
        pkg_cflags=""
    fi

    local all_cxxflags=$(bldr_trim_str "$pkg_cflags $CXXFLAGS")
    if [ "$all_cxxflags" != "" ]
    then
        env_flags="$env_flags CXXFLAGS=\"$all_cxxflags\""
    fi

    local all_cppflags=$(bldr_trim_str "$pkg_cflags $CPPFLAGS")
    if [ "$all_cppflags" != "" ]
    then
        env_flags="$env_flags CPPFLAGS=\"$all_cppflags\""
    fi

    local all_cflags=$(bldr_trim_str "$pkg_cflags $CFLAGS")
    if [ "$all_cflags" != "" ]
    then
        env_flags="$env_flags CFLAGS=\"$all_cflags\""
    fi

    pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
    if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
    then
        pkg_ldflags=$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")
        if [ "$BLDR_SYSTEM_IS_CENTOS" -eq 1 ]
        then
            pkg_ldflags="$pkg_ldflags":-L/usr/lib64:-L/usr/lib
        fi

    else
        pkg_ldflags=""
    fi

    local all_ldflags=$(bldr_trim_str "$pkg_ldflags $LDFLAGS")
    if [ "$all_ldflags" != "" ]
    then
        env_flags="$env_flags LDFLAGS=\"$all_ldflags\""
    fi

    local use_static=false
    local use_shared=false

    if [[ $(echo $pkg_opts | grep -m1 -c 'enable-shared' ) > 0 ]]
    then
        bldr_log_info "Adding shared library configuration ..."
        bldr_log_split
        pkg_cfg="$pkg_cfg --enable-shared"
        use_shared=true
    fi
    
    if [[ $(echo $pkg_opts | grep -m1 -c 'enable-static' ) > 0 ]]
    then
        bldr_log_info "Adding static library configuration ..."
        bldr_log_split
        pkg_cfg="$pkg_cfg --enable-static"
        use_static=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'force-shared' ) > 0 ]]
    then
        bldr_log_info "Forcing shared library configuration ..."
        bldr_log_split
        if [ $use_shared != true ]
        then
            pkg_cfg="$pkg_cfg --enable-shared --disable-static"
        fi
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'force-static' ) > 0 ]]
    then
        bldr_log_info "Forcing static library configuration ..."
        bldr_log_split
        if [ $use_static != true ]
        then
            pkg_cfg="$pkg_cfg --disable-shared --enable-static"
        fi
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'use-build-dir' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/build"
    else
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"
    fi

    local cfg_cmd=$(bldr_locate_config_script $pkg_cfg_path $pkg_opts)
    local output=$(bldr_get_stdout)  

    bldr_log_cmd "$cfg_cmd --prefix=\"$prefix\" $pkg_cfg $env_flags"
    bldr_log_split

    if [[ $(echo $pkg_opts | grep -m1 -c 'config-agree-to-prompt') > 0 ]]
    then
        if [ $BLDR_VERBOSE != false ]
        then
            echo "yes" | eval $cfg_cmd "--prefix=$prefix ${pkg_cfg} ${env_flags}" || bldr_bail "Failed to configure: '$prefix'"
            bldr_log_split
        else
            echo "yes" | eval $cfg_cmd "--prefix=$prefix ${pkg_cfg} ${env_flags}" &>/dev/null || bldr_bail "Failed to configure: '$prefix'"
        fi
    else    
        if [ $BLDR_VERBOSE != false ]
        then
            eval $cfg_cmd "--prefix=$prefix ${pkg_cfg} ${env_flags}" || bldr_bail "Failed to configure: '$prefix'"
            bldr_log_split
        else
            eval $cfg_cmd "--prefix=$prefix ${pkg_cfg} ${env_flags}" &>/dev/null || bldr_bail "Failed to configure: '$prefix'"
        fi
    fi

    bldr_log_info "Done configuring package '$pkg_name/$pkg_vers'"
    bldr_log_split
    bldr_pop_dir
}


function bldr_config_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_patches=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-config' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path $pkg_opts)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_cmd=$(bldr_locate_config_script $pkg_cfg_path $pkg_opts)
    local output=$(bldr_get_stdout)  

    bldr_log_status "Configuring package '$pkg_name/$pkg_vers' using '$cfg_cmd' ..."
    bldr_log_split

    local use_cmake=true
    local has_cmake=false

    local use_autocfg=false
    local has_autocfg=false

    if [[ $(echo $cfg_cmd | grep -m1 -c 'CMakeLists.txt' ) > 0 ]]
    then
        has_cmake=true
    fi    
    
    if [[ $(echo $cfg_cmd | grep -m1 -c 'config' ) > 0 ]]
    then
        has_autocfg=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'cmake' ) > 0 ]]
    then
        use_cmake=true
        use_autocfg=false
        has_autocfg=false
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'config' ) > 0 ]]
    then
        use_cmake=0
        has_cmake=0
        use_autocfg=1
    fi

    if [ $use_cmake == true ] && [ $has_cmake == true ]
    then
        bldr_log_info "Using cmake for '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path' ..."
        bldr_log_split

        bldr_cmake_pkg                    \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        use_autocfg=true
    fi

    if [ $use_autocfg == true ] && [ $has_autocfg == true ]
    then
        bldr_log_info "Using autoconfig for '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path' ..."
        bldr_log_split

        bldr_autocfg_pkg                     \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi
}

function bldr_compile_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-compile' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_status "Building package '$pkg_name/$pkg_vers'"
    bldr_log_split
    
    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"

    if [[ $(echo $pkg_opts | grep -m1 -c 'force-serial-build' ) > 0 ]]
    then
        bldr_log_info "Forcing serial build for '$pkg_name/$pkg_vers' ..."
        bldr_log_split
        BLDR_PARALLEL=false
    fi

    local defines=""
    local output=$(bldr_get_stdout)
    local options="--stop"

    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    if [ $BLDR_PARALLEL != false ]
    then
        local procs=2
        if [ $BLDR_SYSTEM_IS_OSX -eq 1 ]
        then
            procs=$(sysctl -n hw.ncpu)
        fi
        if [ $BLDR_SYSTEM_IS_LINUX -eq 1 ]
        then
            procs=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)
        fi
        options="-j$procs $options"
    fi

    # append any -M directives as macros to the make command (eg. -MMAKE_EXAMPLES=0 -> MAKE_EXAMPLES=0)
    if [[ $(echo $pkg_opts | grep -m1 -c '\-M') > 0 ]]
    then
        local def=""
        defines=$(echo $pkg_opts | grep -E -o "\-M(\S+)\s*" | sed 's/-M//g' )
        for def in ${defines}
        do
            options="$options $def"
        done
    fi

    if [ -f "./Makefile" ]
    then
        bldr_log_cmd "make $options"
        bldr_log_split

        if [ $BLDR_VERBOSE != false ]
        then
            eval make $options || bldr_bail "Failed to build package: '$prefix'"
            bldr_log_split
        else
            eval make $options &> /dev/null || bldr_bail "Failed to build package: '$prefix'"
        fi
    fi
    bldr_pop_dir
}

function bldr_install_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-install' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi

    # extract the makefile rule names and filter out empty lines and comments
    if [ -f "./Makefile" ]
    then
        # install using make if an 'install' rule exists
        local rules=$(make -pnsk | grep -v ^$ | grep -v ^# | grep -m1 -c '^install:')
        if [[ $(echo "$rules") > 0 ]]
        then
            bldr_log_status "Installing package '$pkg_name/$pkg_vers'"
            bldr_log_split

            bldr_log_cmd "make install"
            bldr_log_split

            if [ $BLDR_VERBOSE != false ]
            then
                eval make $options install || bldr_bail "Failed to install package: '$prefix'"
                bldr_log_split
            else
                eval make $options install &> /dev/null || bldr_bail "Failed to install package: '$prefix'"
            fi
        fi
    fi
    bldr_pop_dir
}

function bldr_migrate_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-migrate' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local make_path=$(bldr_locate_makefile $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_status "Migrating package '$pkg_name/$pkg_vers' ..."
    bldr_log_split

    local src_path=""

    # build using make if a makefile exists
    if [ -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path" ] 
    then

        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$make_path"
        local bin_paths="lib bin lib32 lib64"
        for src_path in ${bin_paths}
        do
            # move product into external os specific path
            if [ -d "$prefix/$src_path" ]
            then
                if [ -d "$prefix/$src_path/pkgconfig" ] && [ -d "$PKG_CONFIG_PATH" ]
                then
                    bldr_log_info "Adding package config '$prefix/$src_path/pkgconfig' for '$pkg_name/$pkg_vers'"
                    bldr_log_split

                    cp -v $prefix/$src_path/pkgconfig/*.pc "$PKG_CONFIG_PATH" || bldr_bail "Failed to copy pkg-config into directory: $PKG_CONFIG_PATH"
                    bldr_log_split
                fi
            fi
        done
        bldr_pop_dir
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'migrate-build-tree' ) > 0 ]]
    then
        bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_copy_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_log_split
    fi
    
    if [[ $(echo $pkg_opts | grep -m1 -c 'migrate-build-headers' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        local inc_paths="include inc man share"
        for src_path in ${inc_paths}
        do
            # move product into external path
            if [ -d "$src_path" ]
            then
                bldr_log_status "Migrating build files from '$src_path' for '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path"
                bldr_copy_dir "$src_path" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path"
                bldr_log_split
            fi
        done
        bldr_pop_dir
    fi    

    if [[ $(echo $pkg_opts | grep -m1 -c 'migrate-build-source' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        local inc_paths="src source"
        for src_path in ${inc_paths}
        do
            # move product into external path
            if [ -d "$src_path" ]
            then
                bldr_log_status "Migrating build files from '$src_path' for '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path"
                bldr_copy_dir "$src_path" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path"
                bldr_log_split
            fi
        done
        bldr_pop_dir
    fi    

    if [[ $(echo $pkg_opts | grep -m1 -c 'migrate-build-binaries' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        local bin_paths=". lib bin lib32 lib64"
        local binary=""
        local subdir=""
        for src_path in ${bin_paths}
        do
            # move product into external path
            if [ $src_path == "." ]
            then
                subdir="bin"
            else
                subdir="$src_path"
            fi
            if [ -d "$src_path" ]
            then
                local first_file=1
                for binary in ${src_path}/*
                do
                    if [ -x "$binary" ] && [ ! -d "$binary" ]
                    then
                        if [ $first_file ]
                        then
                            bldr_log_status "Migrating build binaries from '$subdir' for '$pkg_name/$pkg_vers'"
                            bldr_log_split
                            bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$subdir"
                            bldr_log_split
                            first_file=0
                        fi
                        eval cp -v "$binary" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$subdir" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$subdir"
                        bldr_log_split
                    fi
                done
            fi
        done
        bldr_pop_dir
    fi    

    if [[ $(echo $pkg_opts | grep -m1 -c 'migrate-build-libs' ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        local inc_paths="build"
        for src_path in ${inc_paths}
        do
            # move product into external path
            if [ -d "$src_path" ]
            then
                bldr_log_status "Migrating build libraries from '$src_path' for '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$path"
                bldr_log_split
                eval cp -v "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$path/*.$BLDR_OS_LIB_EXT" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$src_path"
            fi
        done
        bldr_pop_dir
    fi    

    bldr_log_info "Linking local '$pkg_name/$pkg_vers' as '$pkg_name/latest' ..."
    bldr_log_split

    local pkg_latest=$pkg_vers
    if [ -L "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/latest" ]
    then
        bldr_remove_file "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/latest"
        pkg_latest=$(bldr_find_latest_version_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name")
    fi

    if [ -d "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_latest" ]
    then
        if [ $BLDR_VERBOSE != false ]
        then
            ln -sv "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_latest" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/latest" || bldr_bail "Failed to link latest package version to '$pkg_name/$pkg_latest'!"
            bldr_log_split    
        else
            ln -s "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_latest" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/latest"  || bldr_bail "Failed to link latest package version to '$pkg_name/$pkg_latest'!"
        fi
    fi
}

function bldr_cleanup_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-cleanup' ) > 0 ]]
    then
        return
    fi

    bldr_log_status "Cleaning package '$pkg_name/$pkg_vers' ..."
    bldr_log_split
    
    if [[ $(echo $pkg_opts | grep -m1 -c 'keep' ) > 0 ]]
    then
        bldr_log_info "Keeping package build directory for '$pkg_name/$pkg_vers'"
        bldr_log_split
    else
        bldr_log_info "Removing package build directory for '$pkg_name/$pkg_vers'"
        bldr_log_split

        bldr_remove_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name"
        bldr_log_split
    fi
}

function bldr_modulate_pkg()
{
    local use_verbose="false"
    local pkg_ctry="common"
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [[ $(echo $pkg_opts | grep -m1 -c 'skip-modulate' ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local tstamp=$(date "+%Y-%m-%d-%H:%M:%S")

    local module_dir="$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name"
    local module_file="$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_log_status "Modulating '$pkg_ctry' package '$pkg_name/$pkg_vers'"
    bldr_log_split
    
    if [ ! -d $module_dir ]
    then 
        bldr_make_dir "$module_dir"
        bldr_log_split
    fi

    if [ -f $module_file ]
    then
        bldr_remove_file $module_file
        bldr_log_split
    fi

    local pkg_title=$(bldr_make_uppercase $pkg_name)
    pkg_title=$(echo $pkg_title|sed 's/-/_/g')

    pkg_cfg=$(bldr_trim_list_str "$pkg_cfg")
    if [ "$pkg_cfg" != "" ] && [ "$pkg_cfg" != " " ] && [ "$pkg_cfg" != ":" ]
    then
        pkg_cfg="$(echo $pkg_cfg | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_cfg=""
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        pkg_cflags="$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_cflags=""
    fi

    pkg_ldflags=$(bldr_trim_list_str "$pkg_ldflags")
    if [ "$pkg_ldflags" != "" ] && [ "$pkg_ldflags" != " " ] && [ "$pkg_ldflags" != ":" ]
    then
        pkg_ldflags="$(echo $pkg_ldflags | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_ldflags=""
    fi

    pkg_opts=$(bldr_trim_list_str "$pkg_opts")
    if [ "$pkg_opts" != "" ] && [ "$pkg_opts" != " " ] && [ "$pkg_opts" != ":" ]
    then
        pkg_opts="$(echo $pkg_opts | bldr_split_str ":" | bldr_join_str " ")"
    else
        pkg_opts=""
    fi

    pkg_urls=$(bldr_trim_list_str "$pkg_urls")
    pkg_urls=$(bldr_trim_url_str "$pkg_urls")
    if [ "$pkg_urls" != "" ] && [ "$pkg_urls" != " " ] && [ "$pkg_urls" != ":" ]
    then
        pkg_urls="$(echo $pkg_urls | bldr_split_str ";" | bldr_join_str " ")"
    else
        pkg_urls=""
    fi

    pkg_uses=$(bldr_trim_list_str "$pkg_uses")
    if [ "$pkg_uses" != "" ] && [ "$pkg_uses" != " " ] && [ "$pkg_uses" != ":" ]
    then
        pkg_uses=$(echo $pkg_uses | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_uses=""
    fi

    pkg_reqs=$(bldr_trim_list_str "$pkg_reqs")
    if [ "$pkg_reqs" != "" ] && [ "$pkg_reqs" != " " ] && [ "$pkg_reqs" != ":" ]
    then
        pkg_reqs=$(echo $pkg_reqs | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_reqs=""
    fi

    local pkg_env_prefix=$(echo $pkg_title | bldr_join_str "_")

    echo "#%Module 1.0"                                     >  $module_file
    echo "#"                                                >> $module_file
    echo "# $pkg_title $pkg_vers module for use with 'environment-modules' package." >> $module_file
    echo "#"                                                >> $module_file
    echo "# Generated by BLDR $BLDR_VERSION_STR on $tstamp" >> $module_file
    echo "# -- PkgCategory:   '$pkg_ctry'"                  >> $module_file
    echo "# -- PkgName:       '$pkg_name'"                  >> $module_file
    echo "# -- PkgVersion:    '$pkg_vers'"                  >> $module_file
    echo "# -- PkgInfo:       '$pkg_info'"                  >> $module_file
    echo "# -- PkgFile:       '$pkg_file'"                  >> $module_file
    echo "# -- PkgUrls:       '$pkg_urls'"                  >> $module_file
    echo "# -- PkgOptions:    '$pkg_opts'"                  >> $module_file
    echo "# -- PkgUses:       '$pkg_uses'"                  >> $module_file
    echo "# -- PkgRequires:   '$pkg_reqs'"                  >> $module_file
    echo "# -- PkgCFlags:     '$pkg_cflags'"                >> $module_file
    echo "# -- PkgLDFlags:    '$pkg_ldflags'"               >> $module_file
    echo "# -- PkgConfig:     '$pkg_cfg'"                   >> $module_file
    echo "# -- PkgConfigPath: '$pkg_cfg_path'"              >> $module_file
    echo "#"                                                >> $module_file
    echo ""                                                 >> $module_file
    echo "proc ModulesHelp { } { "                          >> $module_file
    echo "    puts stderr \"Provides module environment support for $pkg_title v$pkg_vers.\"" >> $module_file
    echo "    puts stderr \" \""                            >> $module_file

    local line_string=""
    local pkg_desc_lines=$(echo $pkg_desc | bldr_split_str ' \n')
    for word in ${pkg_desc_lines}
    do
        line_string="$line_string $word"
        if [[ ${#line_string} -ge 78 ]]
        then
            line_string=$(bldr_trim_str $line_string)
            echo "    puts stderr \"$line_string\""         >> $module_file
            line_string=""
        fi
    done

    if [[ ${#line_string} -ge 1 ]]
    then
        line_string=$(bldr_trim_str $line_string)
        echo "    puts stderr \"$line_string\""             >> $module_file
        line_string=""
    fi
    echo "    puts stderr \" \""                            >> $module_file
    echo "}"                                                >> $module_file
    echo ""                                                 >> $module_file
    echo "module-whatis \"$pkg_info\""                      >> $module_file
    echo ""                                                 >> $module_file

    if [ "$pkg_reqs" != "" ]
    then
        for require in ${pkg_reqs}
        do
            echo "if { ! [ is-loaded $require ] } {"     >> $module_file
            echo "    module load $require"                     >> $module_file
            echo "}"                                            >> $module_file
            echo ""                                             >> $module_file
        done
        echo ""                                                 >> $module_file

        for require in ${pkg_reqs}
        do
            echo "prereq $require"                              >> $module_file
        done
        echo ""                                                 >> $module_file

        echo "if { [ module-info mode remove ] } { "            >> $module_file
        for require in ${pkg_reqs}
        do
            echo "    module unload $require"                   >> $module_file
        done
        echo "}"                                                >> $module_file     
        echo ""                                                 >> $module_file
    fi

    # pkg specific environment settings
    echo "setenv $pkg_title""_VERSION                       $pkg_vers"       >> $module_file

    local found=""
    local subdir=""
    for found in $(find $prefix -type d -iname "include")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_INCLUDE_PATH              $found"          >> $module_file
        echo ""                                                              >> $module_file
        echo "prepend-path C_INCLUDE_PATH                   $found"          >> $module_file
        echo "prepend-path CPLUS_INCLUDE_PATH               $found"          >> $module_file
        echo "prepend-path CPATH                            $found"          >> $module_file
        echo "prepend-path FPATH                            $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "inc")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_INCLUDE_PATH              $found"          >> $module_file
        echo ""                                                              >> $module_file
        echo "prepend-path C_INCLUDE_PATH                   $found"          >> $module_file
        echo "prepend-path CPLUS_INCLUDE_PATH               $found"          >> $module_file
        echo "prepend-path CPATH                            $found"          >> $module_file
        echo "prepend-path FPATH                            $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "bin")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_BIN_PATH                  $found"          >> $module_file
        echo ""                                                              >> $module_file
        echo "prepend-path PATH                             $found"          >> $module_file
        for subdir in $found/*
        do
            if [ -d $subdir ]
            then
                echo "prepend-path PATH                     $subdir"         >> $module_file
            fi
        done
    done

    for found in $(find $prefix -type d -iname "sbin")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_SBIN_PATH                 $found"          >> $module_file
        echo ""                                                              >> $module_file
        echo "prepend-path PATH                             $found"          >> $module_file
        for subdir in $found/*
        do
            if [ -d $subdir ]
            then
                echo "prepend-path PATH                     $subdir"         >> $module_file
            fi
        done
    done

    for found in $(find $prefix -type d -iname "lib")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_LIB_PATH                  $found"          >> $module_file
        echo ""                                                              >> $module_file
        if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
        then
            echo "prepend-path DYLD_LIBRARY_PATH            $found"          >> $module_file
        fi
        echo "prepend-path LD_LIBRARY_PATH                  $found"          >> $module_file
        echo "prepend-path LIBRARY_PATH                     $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "lib32")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_LIB32_PATH                $found"          >> $module_file
        echo ""                                                              >> $module_file
        if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
        then
            echo "prepend-path DYLD_LIBRARY_PATH            $found"          >> $module_file
        fi
        echo "prepend-path LD_LIBRARY_PATH                  $found"          >> $module_file
        echo "prepend-path LIBRARY_PATH                     $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "lib64")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_LIB64_PATH                $found"          >> $module_file
        echo ""                                                              >> $module_file
        if [ "$BLDR_SYSTEM_IS_OSX" -eq 1 ]
        then
            echo "prepend-path DYLD_LIBRARY_PATH            $found"          >> $module_file
        fi
        echo "prepend-path LD_LIBRARY_PATH                  $found"          >> $module_file
        echo "prepend-path LIBRARY_PATH                     $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "man")
    do
        echo ""                                                              >> $module_file
        echo "prepend-path MANPATH                          $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "locale")
    do
        echo ""                                                              >> $module_file
        echo "prepend-path NLSPATH                          $found"          >> $module_file
    done

    for found in $(find $prefix -type d -iname "info")
    do
        echo ""                                                              >> $module_file
        echo "prepend-path INFOPATH                         $found"          >> $module_file
    done

    if [ -d "$prefix/man" ]
    then
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_MAN_PATH                  $prefix/man"     >> $module_file
    fi

    if [ -d "$prefix/share" ]
    then
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_SHARE_PATH                $prefix/share"   >> $module_file
    fi

    if [ -d "$prefix/etc" ]
    then
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_CONFIG_PATH               $prefix/etc"     >> $module_file
    fi

    echo ""                                                                  >> $module_file

    local pkg_latest=$pkg_vers

    if [ -L "$module_dir/latest" ]
    then
        bldr_remove_file "$module_dir/latest"
        pkg_latest=$(bldr_find_latest_version_dir "$module_dir")
    fi

    if [ -f "$module_dir/$pkg_latest" ] 
    then
        bldr_log_info "Linking module '$pkg_name/$pkg_latest' as '$pkg_name/latest' ..."
        bldr_log_split    
        if [ $BLDR_VERBOSE != false ]
        then
            ln -sv "$module_dir/$pkg_latest" "$module_dir/latest" || bldr_bail "Failed to link latest module version to '$pkg_name/$pkg_latest'!"
            bldr_log_split    
        else
            ln -s "$module_dir/$pkg_latest" "$module_dir/latest"  || bldr_bail "Failed to link latest module version to '$pkg_name/$pkg_latest'!"
        fi
    fi
}

####################################################################################################

function bldr_build_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_patches=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="true"; shift;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [ "$pkg_name" == "" ] || [ "$pkg_vers" == "" ] || [ "$pkg_file" == "" ]
    then
        bldr_bail "Incomplete package definition!  Need at least 'name', 'version' and 'file' defined!"
    fi

    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry=$BLDR_USE_PKG_CTRY
    fi
    
    local existing=$(bldr_has_pkg --category "$pkg_ctry" --name "$pkg_name" --version "$pkg_vers" --options "$pkg_opts")
    if [ "$existing" != "false" ]
    then
        if [ $BLDR_VERBOSE != false ]
        then
            bldr_log_status "Skipping existing package '$pkg_name/$pkg_vers' ... "
            bldr_log_split
        fi
        return
    fi

    if [ $BLDR_VERBOSE != false ]
    then
        echo "PkgCategory:   '$pkg_ctry'"
        echo "PkgName:       '$pkg_name'"
        echo "PkgVersion:    '$pkg_vers'"
        echo "PkgInfo:       '$pkg_info'"
        echo "PkgFile:       '$pkg_file'"
        echo "PkgUrls:       '$pkg_urls'"
        echo "PkgOptions:    '$pkg_opts'"
        echo "PkgUses:       '$pkg_uses'"
        echo "PkgRequires:   '$pkg_reqs'"
        echo "PkgCFlags:     '$pkg_cflags'"
        echo "PkgLDFlags:    '$pkg_ldflags'"
        echo "PkgConfig:     '$pkg_cfg'"
        echo "PkgConfigPath: '$pkg_cfg_path'"
        echo "PkgPatches:    '$pkg_patches'"
        echo "PkgDesc:      "
        echo " "
        echo "$pkg_desc"
        echo " "
        bldr_log_split
    fi

    local override_setup=$(type -t bldr_pkg_setup_method)
    local override_fetch=$(type -t bldr_pkg_fetch_method)
    local override_boot=$(type -t bldr_pkg_boot_method)
    local override_config=$(type -t bldr_pkg_config_method)
    local override_compile=$(type -t bldr_pkg_compile_method)
    local override_install=$(type -t bldr_pkg_install_method)
    local override_migrate=$(type -t bldr_pkg_migrate_method)
    local override_modulate=$(type -t bldr_pkg_modulate_method)
    local override_cleanup=$(type -t bldr_pkg_cleanup_method)

    # Call the overridden package methods for each build phase if they were defined
    # -- otherwise use the default internal ones (which should handle 90% of most packages)
    if [  "$override_setup" == "function" ]
    then
        bldr_pkg_setup_method             \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_setup_pkg                    \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_fetch" == "function" ]
    then
        bldr_pkg_fetch_method             \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_fetch_pkg                    \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_boot" == "function" ]
    then
        bldr_pkg_boot_method              \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_boot_pkg                     \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_config" == "function" ]
    then
        bldr_pkg_config_method            \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_config_pkg                   \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_compile" == "function" ]
    then
        bldr_pkg_compile_method           \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_compile_pkg                  \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_install" == "function" ]
    then
        bldr_pkg_install_method           \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_install_pkg                  \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_migrate" == "function" ]
    then
        bldr_pkg_migrate_method           \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_migrate_pkg                  \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_modulate" == "function" ]
    then
        bldr_pkg_modulate_method          \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_modulate_pkg                 \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    if [ "$override_cleanup" == "function" ]
    then
        bldr_pkg_cleanup_method           \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_cleanup_pkg                  \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    bldr_log_status "DONE with '$pkg_name/$pkg_vers'! --"
    bldr_log_split
}

####################################################################################################

function bldr_modularize_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_info=""
    local pkg_desc=""
    local pkg_file=""
    local pkg_urls=""
    local pkg_uses=""
    local pkg_reqs=""
    local pkg_opts=""
    local pkg_cflags=""
    local pkg_ldflags=""
    local pkg_patches=""
    local pkg_cfg=""
    local pkg_cfg_path=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="true"; shift;;
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --info)          pkg_info="$2"; shift 2;;
           --description)   pkg_desc="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --file)          pkg_file="$2"; shift 2;;
           --config)        pkg_cfg="$pkg_cfg:$2"; shift 2;;
           --config-path)   pkg_cfg_path="$2"; shift 2;;
           --cflags)        pkg_cflags="$pkg_cflags:$2"; shift 2;;
           --ldflags)       pkg_ldflags="$pkg_ldflags:$2"; shift 2;;
           --patch)         pkg_patches="$pkg_patches:$2"; shift 2;;
           --uses)          pkg_uses="$pkg_uses:$2"; shift 2;;
           --requires)      pkg_reqs="$pkg_reqs:$2"; shift 2;;
           --url)           pkg_urls="$pkg_urls;$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    if [ "$pkg_name" == "" ] || [ "$pkg_vers" == "" ] || [ "$pkg_file" == "" ]
    then
        bldr_bail "Incomplete package definition!  Need at least 'name', 'version' and 'file' defined!"
    fi

    local existing=$(bldr_has_module --category "$pkg_ctry" --name "$pkg_name" --version "$pkg_vers" --options "$pkg_opts")
    if [ "$existing" != "false" ]
    then
        if [ $BLDR_VERBOSE != false ]
        then
            bldr_log_status "Skipping existing package '$pkg_name/$pkg_vers' ... "
            bldr_log_split
        fi
        return
    fi

    if [ $BLDR_VERBOSE != false ]
    then
        bldr_log_split
        echo "PkgCategory:   '$pkg_ctry'"
        echo "PkgName:       '$pkg_name'"
        echo "PkgVersion:    '$pkg_vers'"
        echo "PkgInfo:       '$pkg_info'"
        echo "PkgFile:       '$pkg_file'"
        echo "PkgUrls:       '$pkg_urls'"
        echo "PkgOptions:    '$pkg_opts'"
        echo "PkgUses:       '$pkg_uses'"
        echo "PkgRequires:   '$pkg_reqs'"
        echo "PkgCFlags:     '$pkg_cflags'"
        echo "PkgLDFlags:    '$pkg_ldflags'"
        echo "PkgConfig:     '$pkg_cfg'"
        echo "PkgConfigPath: '$pkg_cfg_path'"
        echo "PkgPatches:    '$pkg_patches'"
        echo "PkgDesc:      "
        echo " "
        echo "$pkg_desc"
        echo " "
    fi

    local override_modulate=$(type -t bldr_pkg_modulate_method)

    # Call the overridden package methods for each build phase if they were defined
    # -- otherwise use the default internal ones (which should handle 90% of most packages)
    if [ "$override_modulate" == "function" ]
    then
        bldr_pkg_modulate_method          \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    else
        bldr_modulate_pkg                 \
            --category    "$pkg_ctry"     \
            --name        "$pkg_name"     \
            --version     "$pkg_vers"     \
            --file        "$pkg_file"     \
            --url         "$pkg_urls"     \
            --uses        "$pkg_uses"     \
            --requires    "$pkg_reqs"     \
            --options     "$pkg_opts"     \
            --cflags      "$pkg_cflags"   \
            --ldflags     "$pkg_ldflags"  \
            --patch       "$pkg_patches"  \
            --config      "$pkg_cfg"      \
            --config-path "$pkg_cfg_path" \
            --verbose     "$use_verbose"
    fi

    bldr_log_status "DONE with '$pkg_name/$pkg_vers'! --"
    bldr_log_split
}

####################################################################################################

function bldr_build_pkgs()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_version=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local pkg_ctry=$(echo "$pkg_ctry" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_list=$(echo "$pkg_name" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_dir="$BLDR_PKGS_PATH"

    # push the system category onto the list if it hasn't been built yet
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry="*"
    else
        if [[ ! -d $BLDR_LOCAL_PATH/internal ]]; then
            pkg_ctry="internal system $pkg_ctry"
        fi
        pkg_ctry=$(bldr_trim_str $pkg_ctry)
    fi

    pkg_list=$(bldr_trim_str $pkg_list)

    if [[ -d $pkg_dir ]]
    then
        local builder
        bldr_log_split
        bldr_log_status "Starting build for '$pkg_ctry' in '$pkg_dir'..."
        bldr_log_split
        for pkg_category in $pkg_dir/$pkg_ctry
        do
            local base_ctry=$(basename $pkg_category)
            bldr_log_info "Building category '$base_ctry'"
            bldr_log_split

            for pkg_def in $pkg_dir/$base_ctry/*
            do
                if [[ ! -x $pkg_def ]]
                then
                    continue
                fi

                if [[ "$pkg_list" == "" ]] 
                then
                    if [ $BLDR_VERBOSE != false ]
                    then
                        bldr_log_info "Building package '$pkg_def'"
                        bldr_log_split
                    fi
                    export BLDR_USE_PKG_CTRY="$base_ctry"
                    eval $pkg_def || exit -1
                    export BLDR_USE_PKG_CTRY=""
                else
                    for entry in $pkg_list 
                    do
                        local m=$(echo "$pkg_def" | grep -m1 -c $entry )
                        if [[ $m > 0 ]]
                        then
                            if [ $BLDR_VERBOSE != false ]
                            then
                                bldr_log_info "Building '$entry' from '$pkg_def'"
                                bldr_log_split
                            fi
                            export BLDR_USE_PKG_CTRY="$base_ctry"
                            eval $pkg_def || exit -1
                            export BLDR_USE_PKG_CTRY=""
                            break
                        fi
                    done
                fi
            done
        done
    fi
}


####################################################################################################

function bldr_modularize_pkgs()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_version=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local pkg_ctry=$(echo "$pkg_ctry" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_list=$(echo "$pkg_name" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_dir="$BLDR_PKGS_PATH"

    # push the system category onto the list if it hasn't been built yet
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry="*"
    else
        pkg_ctry="internal system $pkg_ctry"
        pkg_ctry=$(bldr_trim_str $pkg_ctry)
    fi

    pkg_list=$(bldr_trim_str $pkg_list)

    if [[ -d $pkg_dir ]]
    then
        local builder
        bldr_log_split
        bldr_log_status "Starting build for '$pkg_ctry' in '$pkg_dir'..."
        bldr_log_split
        for pkg_category in $pkg_dir/$pkg_ctry
        do
            local base_ctry=$(basename $pkg_category)
            bldr_log_info "Building category '$base_ctry'"
            bldr_log_split

            for pkg_def in $pkg_dir/$base_ctry/*
            do
                if [[ ! -x $pkg_def ]]
                then
                    continue
                fi

                if [[ "$pkg_list" == "" ]] 
                then
                    if [ $BLDR_VERBOSE != false ]
                    then
                        bldr_log_info "Building package '$pkg_def'"
                        bldr_log_split
                    fi
                    eval $pkg_def || exit -1
                else
                    for entry in $pkg_list 
                    do
                        local m=$(echo "$pkg_def" | grep -m1 -c $entry )
                        if [[ $m > 0 ]]
                        then
                            if [ $BLDR_VERBOSE != false ]
                            then
                                bldr_log_info "Building '$entry' from '$pkg_def'"
                                bldr_log_split
                            fi
                            eval $pkg_def || exit -1
                            break
                        fi
                    done
                fi
            done
        done
    fi
}

####################################################################################################

function bldr_load_pkgs()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_version=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi

    local pkg_ctry=$(echo "$pkg_ctry" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_list=$(echo "$pkg_name" | bldr_split_str ":" | bldr_join_str " ")
    local md_path="$BLDR_MODULE_PATH"

    pkg_list=$(bldr_trim_str $pkg_list)

    # push the system category onto the list if it hasn't been built yet
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    if [ "$pkg_ctry" == "" ] || [ "$pkg_ctry" == "all" ]
    then
        pkg_ctry="*"
    else
        pkg_ctry="internal system $pkg_ctry"
        pkg_ctry=$(bldr_trim_str $pkg_ctry)
    fi

    md_list=$(bldr_trim_str $pkg_list)

    if [[ -d $md_path ]]
    then
        local builder
        bldr_log_split
        bldr_log_status "Loading for '$pkg_ctry' in '$md_path'..."
        bldr_log_split
        for pkg_category in $md_path/$pkg_ctry
        do
            local base_ctry=$(basename $pkg_category)

            bldr_log_info "Loading category '$base_ctry'"
            bldr_log_split

            module use $md_path/$base_ctry

            for entry in $md_path/$base_ctry/*
            do
                if [[ $(echo $BLDR_LOADED_MODULES | grep -m1 -c '$using' ) > 0 ]]; then
                    local $using=$(basename $entry)
                    module -f load $using || bldr_bail "Failed to load module '$entry'!"
                    BLDR_LOADED_MODULES="$BLDR_LOADED_MODULES:$using"
                fi
            done
        done
    fi
}
