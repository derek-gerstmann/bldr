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
export BLDR_TIMESTAMP=${BLDR_TIMESTAMP:=$(date "+%Y-%m-%d-%Hh%Mm%Ss")}

####################################################################################################

BLDR_CATEGORIES=(
    "internal" 
    "compression" 
    "system" 
    "languages" 
    "developer" 
    "network" 
    "concurrency" 
    "numerics" 
    "protocols" 
    "typography" 
    "graphics" 
    "cluster" 
    "storage" 
    "imaging" 
    "databases" 
    "toolkits" 
    "compilers")

BLDR_PARALLEL=${BLDR_PARALLEL:=true}
BLDR_VERBOSE=${BLDR_VERBOSE:=false}
BLDR_DEBUG=${BLDR_DEBUG:=false}
BLDR_LOG_FILE=${BLDR_LOG_FILE:=""}
BLDR_IS_INTERNAL_LOADED=${BLDR_IS_INTERNAL_LOADED:=false}
BLDR_LOADED_MODULES=${BLDR_LOADED_MODULES:=""}
BLDR_DEFAULT_BUILD_LIST=${BLDR_DEFAULT_BUILD_LIST:=${BLDR_CATEGORIES[@]}}
BLDR_DEFAULT_PKG_USES=${BLDR_DEFAULT_PKG_USES:=""}

BLDR_USE_PKG_CTRY=${BLDR_USE_PKG_CTRY:=""}
BLDR_USE_PKG_NAME=${BLDR_USE_PKG_NAME:=""}
BLDR_USE_PKG_VERS=${BLDR_USE_PKG_VERS:=""}
BLDR_USE_PKG_OPTS=${BLDR_USE_PKG_OPTS:=""}

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
    BLDR_TXT_CMD="\033[1;32m"       # bold green
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
    local use_verbose=$1
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    if [[ $use_verbose == true ]]
    then
        output="2>&1 | tee -a $log_file"
    else
        output="2>&1 >> $log_file"
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
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    (echo "-- ${@}" 2>&1) >> $log_file    
    echo -e ${BLDR_TXT_HEADER}"-- ${@} "${BLDR_TXT_RST}
}

function bldr_log_item()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    (echo "${@}" 2>&1) >> $log_file    
    echo -e ${BLDR_TXT_HEADER}"${@} "${BLDR_TXT_RST}
}

function bldr_log_warning()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    (echo "[ ${ts} ] WARNING: ${@}" 2>&1) >> $log_file    
    echo -e ${BLDR_TXT_HEADER}"-- "${BLDR_TXT_TITLE}"WARNING:"${BLDR_TXT_WARN}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_error()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    (echo "[ ${ts} ] ERROR: ${@}" 2>&1) >> $log_file    
    echo -e ${BLDR_TXT_HEADER}"-- "${BLDR_TXT_TITLE}"ERROR:"${BLDR_TXT_ERROR}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_error_output()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    (echo "${@}" 2>&1) >> $log_file    
    echo -e ${BLDR_TXT_ERROR}"${@}"${BLDR_TXT_RST}
}

function bldr_log_status()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local ts=$(date "+%Y-%m-%d-%H:%M:%S")
    (echo "[ ${ts} ] ${@}" 2>&1) >> $log_file    
    echo -e ${BLDR_TXT_TITLE}"["${BLDR_TXT_HEADER}" ${ts} "${BLDR_TXT_TITLE}"]"${BLDR_TXT_TITLE}" ${@} "${BLDR_TXT_RST}
}

function bldr_log_cmd()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"

    local word=""
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
                (echo "> $line_string" 2>&1) >> $log_file
                echo -e ${BLDR_TXT_TITLE}">"${BLDR_TXT_CMD}" $line_string "${BLDR_TXT_RST}
                first_line=false
            else
                line_string=$(bldr_trim_str $line_string)
                (echo "       $line_string" 2>&1) >> $log_file
                echo -e ${BLDR_TXT_TITLE}"      "${BLDR_TXT_CMD}" $line_string "${BLDR_TXT_RST}
            fi
        fi
        line_string=""
    done

    if [[ ${#line_string} -ge 1 ]]
    then
        line_string=$(bldr_trim_str $line_string)
        (echo "       $line_string" 2>&1) >> $log_file
        echo -e ${BLDR_TXT_TITLE}"      "${BLDR_TXT_CMD}" $line_string "${BLDR_TXT_RST}
        line_string=""
    fi
}

function bldr_log_list_item_suffix()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"

    local item_idx="${1}"
    local item_sfx="${2}"
    local item_msg="${3}"

    local txt_idx=$(printf "%03d" $item_idx)

    (echo "[ $txt_idx ] $item_msg '$item_sfx'" 2>&1) >> $log_file
    echo -e ${BLDR_TXT_HEADER}"-- "${BLDR_TXT_TITLE}"["${BLDR_TXT_HEADER}" $txt_idx "${BLDR_TXT_TITLE}"]"${BLDR_TXT_RST}${BLDR_TXT_HEADER}" $item_msg ""'"${BLDR_TXT_TITLE}"$item_sfx"${BLDR_TXT_HEADER}"'"${BLDR_TXT_RST}
}

function bldr_log_list_item_progress()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local item_idx="${1}"
    local item_cnt="${2}"
    local item_msg="${3}"

    local txt_idx=$(printf "%03d" $item_idx)
    local txt_cnt=$(printf "%03d" $item_cnt)

    (echo "[ $txt_idx / $txt_cnt ] $item_msg" 2>&1) >> $log_file
    echo -e ${BLDR_TXT_TITLE}"["${BLDR_TXT_HEADER}" $txt_idx "${BLDR_TXT_TITLE}"/"${BLDR_TXT_HEADER}" $txt_cnt "${BLDR_TXT_TITLE}"]"${BLDR_TXT_RST}${BLDR_TXT_TITLE}" $item_msg "${BLDR_TXT_RST}
}

function bldr_log_list_item()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local item_idx="${1}"
    local item_msg="${2}"

    local txt_idx=$(printf "%03d" $item_idx)

    (echo "-- [ $txt_idx ] $item_msg" 2>&1) >> $log_file
    echo -e ${BLDR_TXT_HEADER}"-- "${BLDR_TXT_TITLE}"["${BLDR_TXT_HEADER}" $txt_idx "${BLDR_TXT_TITLE}"]"${BLDR_TXT_RST}${BLDR_TXT_ERROR}" $item_msg "${BLDR_TXT_RST}
}

function bldr_log_list()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"

    local word=""
    local first_line=true
    local line_string=""
    local log_lines=$(echo ${@} | bldr_split_str ' \n')
    local list_idx
    let list_idx=0

    for word in ${log_lines}
    do
        line_string="$line_string $word"
        if [[ ${#line_string} -ge 1 ]]
        then
            let list_idx++
            if [ $first_line == true ]
            then
                line_string=" $line_string"
                first_line=false
            fi
            bldr_log_list_item $list_idx $line_string
        fi
        line_string=""
    done

    if [[ ${#line_string} -ge 1 ]]
    then
        let list_idx++
        line_string=$(bldr_trim_str $line_string)
        bldr_log_list_item $list_idx $line_string
        line_string=""
    fi
}

function bldr_run_cmd()
{
    local cmd="${@}"

    bldr_log_cmd "$cmd"

    local ts=$(date "+%Y-%m-%d-%Hh%Mm%Ss")
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local cmd_log_file="$BLDR_LOG_PATH/bldr_cmd_$ts.log"

    set -o pipefail    
    
    if [[ $BLDR_VERBOSE == true ]]
    then
        bldr_log_split

        (eval "$cmd" 2>&1 | tee -a $cmd_log_file $log_file) || \
            (bldr_log_split ; bldr_log_error "Failed to execute command!  Output follows:" ; \
             bldr_bail_cmd "$(cat $cmd_log_file)") || exit -1 

        bldr_log_split
    else
        (eval "$cmd" 2>&1 | tee -a $cmd_log_file) >> $log_file || \
            (bldr_log_split ; bldr_log_error "Failed to execute command!  Output follows:" ; \
                bldr_bail_cmd "$(cat $cmd_log_file)") || exit -1 
    fi

    rm $cmd_log_file
    bldr_log_split
}

function bldr_exec()
{
    bldr_log_cmd "${@}"
    eval "${@}" 
}

function bldr_log_split()
{
    local log_file="$BLDR_LOG_PATH/$BLDR_LOG_FILE"
    local log_split="---------------------------------------------------------------------------------------------------------------"
    echo "$log_split" 2>&1 | tee -a $log_file
}

function bldr_format_version()
{
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

function bldr_is_newer_version()
{
    local v1=$(bldr_format_version "$1" )
    local v2=$(bldr_format_version "$2" )
    if [[ ! $(echo -e "$v1\n$v2" | sort -r | head -1) == "$v1" ]]
    then
        echo "true"
        return
    fi
    echo "false"
}

function bldr_find_latest_version_dir()
{
    local path=$1
    local latest=$(find "$path" -maxdepth 1 -mindepth 1 -type d | sort -r --version-sort | head -1)
    local found=$(basename "$latest")
    echo "$found"
}

function bldr_find_latest_version_file()
{
    local path=$1
    local latest=$(find "$path" -maxdepth 1 -mindepth 1 -type f | sort -r --version-sort | head -1)
    local found=$(basename "$latest")
    echo "$found"
}

####################################################################################################

# setup project paths
BLDR_SUBZERO="$0"
BLDR_SUBZERO=${BLDR_SUBZERO:="."}
BLDR_ABS_PWD="$( cd "$( dirname "$BLDR_SUBZERO" )" && pwd )"
BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"

# try one level up if we aren't resolving the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    BLDR_ABS_PWD="$( cd "$( dirname "$BLDR_SUBZERO" )/.." && pwd )"
    BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
    BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"
fi

# try one level up if we aren't resolving the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    BLDR_ABS_PWD="$( cd "$( dirname "$BLDR_SUBZERO" )/../.." && pwd )"
    BLDR_ROOT_PATH="$( dirname "$BLDR_ABS_PWD/.." )"
    BLDR_BASE_PATH="$( basename "$BLDR_ABS_PWD" )"
fi

####################################################################################################

# ensure we are run inside of the root dir
if [ ! -f "$BLDR_ROOT_PATH/system/bldr.sh" ]
then
    echo "Please execute package build script from within the 'bldr' subfolder: '$BLDR_ABS_PWD' '$BLDR_ROOT_PATH'!"
    exit 0
fi 

####################################################################################################

# setup system paths
BLDR_CONFIG_PATH=${BLDR_CONFIG_PATH:=$BLDR_ROOT_PATH}
export BLDR_SCRIPTS_PATH="$BLDR_CONFIG_PATH/scripts"
export BLDR_PKGS_PATH="$BLDR_CONFIG_PATH/pkgs"
export BLDR_PATCHES_PATH="$BLDR_CONFIG_PATH/patches"
export BLDR_SYSTEM_PATH="$BLDR_CONFIG_PATH/system"
export BLDR_CACHE_PATH="$BLDR_CONFIG_PATH/cache"
export BLDR_BUILD_PATH="$BLDR_CONFIG_PATH/build"
export BLDR_LOG_PATH="$BLDR_CONFIG_PATH/logs"

# setup install paths
BLDR_INSTALL_PATH=${BLDR_INSTALL_PATH:=$BLDR_ABS_PWD}
export BLDR_LOCAL_PATH="$BLDR_INSTALL_PATH/local"
export BLDR_MODULE_PATH="$BLDR_INSTALL_PATH/modules"
export BLDR_OS_LIB_EXT="a"

####################################################################################################

# Detect 32 vs 64 bit host architecture
#
if [[ $( uname -p | grep -m1 -c -i 'x86_64') > 0 ]]
then
    export BLDR_SYSTEM_IS_64BIT=true
    export BLDR_SYSTEM_IS_32BIT=true
elif [[ $( uname -p | grep -m1 -c -i 'i386') > 0 ]]
then
    export BLDR_SYSTEM_IS_64BIT=false
    export BLDR_SYSTEM_IS_32BIT=true
fi

####################################################################################################

# Detect generic Linux variants
# 
if [[ $( uname -s | grep -m1 -c -i 'Linux' ) > 0 ]]
then
    export BLDR_OS_NAME="lnx"
    export BLDR_SYSTEM_IS_LINUX=true
else
    export BLDR_SYSTEM_IS_LINUX=false
fi

# Detect CentOS variants of Linux
#
if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
then
    export BLDR_SYSTEM_IS_CENTOS=false
    if [[ -e "/etc/redhat-release" ]]
    then
        if [[ $(cat /etc/redhat-release | grep -m1 -c -i 'CentOS' ) > 0 ]]
        then
            export BLDR_SYSTEM_IS_CENTOS=true
        fi
    fi
fi

####################################################################################################

# Detect MacOSX based on Darwin BSD kernel
# 
if [[ $(uname -s | grep -m1 -c -i 'Darwin' ) > 0 ]]
then
    export BLDR_OS_NAME="osx"
    export BLDR_SYSTEM_IS_OSX=true

    if [[ $( uname -v | grep -m1 -c -i 'x86_64') > 0 ]]
    then
        export BLDR_SYSTEM_IS_64BIT=true
        export BLDR_SYSTEM_IS_32BIT=true
    fi

    # Locate the SDK for OSX based on the active XCode environment
    if [[ "$BLDR_XCODE_SDK" == "" ]]
    then
        BLDR_XCODE_SELECT=$(which xcode-select)
        
        if [[ -x "$BLDR_XCODE_SELECT" ]]
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
else
    export BLDR_SYSTEM_IS_OSX=false
fi

####################################################################################################

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
        local loaded_internal=false
        for internal_path in "$BLDR_LOCAL_PATH/internal"/*
        do
            if [[ $BLDR_DEBUG == true ]]
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
                if [[ $BLDR_SYSTEM_IS_OSX == true ]]
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
        local md_path=""
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
    fi

    if [ -d "$BLDR_MODULE_PATH" ] && [ "$(type -t module)" == "function" ]
    then
        local ctry_path=""
        local ctry_name=""

        for ctry_path in $BLDR_MODULE_PATH/*
        do
            ctry_name=$(basename "$ctry_path")
            module use "$BLDR_MODULE_PATH/$ctry_name" || bldr_bail "Failed to load '$ctry_name' module!"
        done

        if [ -d "$BLDR_MODULE_PATH/internal" ]
        then    
            local internal_path=""
            local internal_base=""
            module use "$BLDR_MODULE_PATH/internal" || bldr_bail "Failed to load 'internal' module!"
            for internal_path in "$BLDR_MODULE_PATH/internal"/*
            do
                internal_base=$(basename $internal_path)
                module load $internal_base || bldr_bail "Failed to load module '$internal_base' from 'internal'!"
            done
        fi
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

# setup the environment to support our own version of PKG_CONFIG
function bldr_load_logger()
{
    if [ ! -d "$BLDR_LOG_PATH" ]
    then
        mkdir -p "$BLDR_LOG_PATH"
    fi

    if [ "$BLDR_LOG_FILE" == "" ]
    then
        local tstamp=$(date "+%Y-%m-%d-%Hh%Mm%Ss")
        export BLDR_LOG_FILE="bldr_${tstamp}.log"
    fi
}

####################################################################################################

function bldr_startup() 
{
    bldr_load_internal
    bldr_load_modules
    bldr_load_logger
    bldr_load_pkgconfig    
}

####################################################################################################

# import our internal tools for usage
bldr_startup

####################################################################################################

BLDR_BOOT_SEARCH_PATH=". build source src ../build ../source ../src"
BLDR_CONFIG_SEARCH_PATH=". source src build .. ../build ../source ../src"
BLDR_BUILD_SEARCH_PATH=". ./build ../build .. ../src ../source"
BLDR_MAKE_SEARCH_PATH=". ./build ../build .. ../src ../source"

BLDR_BOOT_FILE_SEARCH_LIST="bootstrap bootstrap.sh autogen.sh"
BLDR_AUTOCONF_FILE_SEARCH_LIST="configure configure.sh bootstrap bootstrap.sh autogen.sh config"
BLDR_CMAKE_FILE_SEARCH_LIST="CMakeLists.txt cmakelists.txt"
BLDR_MAKE_FILE_SEARCH_LIST="Makefile makefile"
BLDR_MAVEN_FILE_SEARCH_LIST="pom.xml project.xml"

####################################################################################################

function bldr_locate_build_path
{
    local build_path="."
    local given=$(bldr_trim_str "${@}")
    local mk_paths=$(bldr_trim_str "$given $BLDR_BUILD_SEARCH_PATH")
    local mk_files=$BLDR_MAKE_FILE_SEARCH_LIST

    local tst_path=""
    local tst_file=""

    if [ -f "CMakeLists.txt" ] && [ -f "build/Makefile" ]
    then
        build_path="build"
    else
        for tst_path in ${mk_paths}
        do
            for tst_file in ${mk_files}
            do
                if [ -f "$tst_path/$tst_file" ]
                then
                    build_path="$tst_path"
                    break
                fi
            done
            if [ "$build_path" != "." ]
            then
                break
            fi
        done
    fi
    echo "$build_path"
}

function bldr_locate_make_file
{
    local make_file="."
    local given=$(bldr_trim_str "${@}")
    local mk_paths=$(bldr_trim_str "$given $BLDR_MAKE_SEARCH_PATH")
    local mk_files=$BLDR_MAKE_FILE_SEARCH_LIST
    local tst_path=""

    if [ -f "CMakeLists.txt" ] && [ -f "build/Makefile" ]
    then
        make_file="build/Makefile"
    else
        for tst_path in ${mk_paths}
        do
            for tst_file in ${mk_files}
            do
                if [ -f "$tst_path/$tst_file" ]
                then
                    make_file="$tst_path/$tst_file"
                    break
                fi
            done
            if [ "$make_file" != "." ]
            then
                break
            fi
        done
    fi
    echo "$make_file"
}


function bldr_locate_boot_script
{
    local found_path="."
    local given=$(bldr_trim_str "${@}")
    local cfg_paths=$(bldr_trim_str "$given $BLDR_BOOT_SEARCH_PATH")
    local cfg_files=$BLDR_BOOT_FILE_SEARCH_LIST

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
    local given=$(bldr_trim_str "${@}")
    local script=$(bldr_locate_boot_script "$given")
    local path=$(dirname "$script")
    echo "$path"
}

function bldr_is_autoconf_file
{
    local cfg_srch=$(bldr_trim_str "$1")
    local cfg_files=$BLDR_AUTOCONF_FILE_SEARCH_LIST
    local tst_file=""

    for tst_file in ${cfg_files}
    do
        if [[ $(echo "$cfg_srch" | grep -m1 -c "$tst_file") > 0 ]]
        then
            echo "true"
            return
        fi
    done
    echo "false"
}

function bldr_is_cmake_file
{
    local cfg_srch=$(bldr_trim_str "$1")
    local cfg_files=$BLDR_CMAKE_FILE_SEARCH_LIST
    local tst_file=""

    for tst_file in ${cfg_files}
    do
        if [[ $(echo "$cfg_srch" | grep -m1 -c "$tst_file") > 0 ]]
        then
            echo "true"
            return
        fi
    done
    echo "false"
}

function bldr_is_maven_file
{
    local cfg_srch=$(bldr_trim_str "$1")
    local cfg_files=$BLDR_MAVEN_FILE_SEARCH_LIST
    local tst_file=""

    for tst_file in ${cfg_files}
    do
        if [[ $(echo "$cfg_srch" | grep -m1 -c "$tst_file") > 0 ]]
        then
            echo "true"
            return
        fi
    done
    echo "false"
}

function bldr_locate_config_script
{
    local cfg_srch=$(bldr_trim_str "$1")
    local cfg_opts=$2
    local cfg_paths=$(bldr_trim_str "$cfg_srch $BLDR_CONFIG_SEARCH_PATH")
    local found_path="."

    local cmake_files=$BLDR_CMAKE_FILE_SEARCH_LIST
    local autocfg_files=$BLDR_AUTOCONF_FILE_SEARCH_LIST
    local maven_files=$BLDR_MAVEN_FILE_SEARCH_LIST

    local use_cmake=true
    local use_autocfg=true
    local use_maven=true

    if [[ $(echo "$cfg_opts" | grep -m1 -c "cmake" ) > 0 ]]
    then
        use_cmake=true
        use_autocfg=false
        use_maven=false
    
    elif [[ $(echo "$cfg_opts" | grep -m1 -c "config" ) > 0 ]]
    then
        use_cmake=false
        use_autocfg=true
        use_maven=false

    elif [[ $(echo "$cfg_opts" | grep -m1 -c "maven" ) > 0 ]]
    then
        use_cmake=false
        use_autocfg=false
        use_maven=true
    fi

    local tst_path=""
    local tst_file=""

    for tst_path in ${cfg_paths}
    do
        if [[ $use_autocfg == true ]]
        then
            for tst_file in ${autocfg_files}
            do
                if [ -f "$tst_path/$tst_file" ]
                then
                    found_path="$tst_path/$tst_file"
                    break
                fi
            done
        elif [[ $use_cmake == true ]]
        then
            for tst_file in ${cmake_files}
            do
                if [ -f "$tst_path/$tst_file" ]
                then
                    found_path="$tst_path/$tst_file"
                    break
                fi
            done
        elif [[ $use_maven == true ]]
        then
            for tst_file in ${maven_files}
            do
                if [ -f "$tst_path/$tst_file" ]
                then
                    found_path="$tst_path/$tst_file"
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
    bldr_log_error "${msg}. BLDR Exiting..."
    bldr_log_split
    exit 1
}


function bldr_bail_cmd
{
    local msg=$@
    bldr_log_split
    bldr_log_error_output "${msg}"
    bldr_log_split
    bldr_log_error "Fatal Error. BLDR Exiting..."
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
        bldr_run_cmd "$cmd $url $dir" || bldr_bail "Failed to clone '$url' into '$dir'"
    else
        bldr_bail "Failed to locate 'git' command!  Please install this command line utility!"
    fi
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
        bldr_run_cmd "$cmd $url $dir" || bldr_bail "Failed to checkout '$url' into '$dir'"
    else
        bldr_bail "Failed to locate 'svn' command!  Please install this command line utility!"
    fi
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
        if [ $usepipe -eq 1 ]
        then
            bldr_run_cmd "$cmd $url > $archive"
        else
            bldr_run_cmd "$cmd $archive $url"
        fi
        bldr_log_split
        bldr_log_info "Downloaded '$url' to '$archive'..."
    fi
}

function bldr_get_archive_flag()
{
    local is="z"
    local archive="$1"
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
    echo "$is"
}

function bldr_is_valid_archive()
{
    local is=0
    local archive="$1"
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

function bldr_is_library()
{
    local is="false"
    local tst="$1"
    if [ -f $tst ] ; then
       case $tst in
        *.a)        is="true";;
        *.so)       is="true";;
        *.la)       is="true";;
        *.dylib)    is="true";;
        *.so.*)     is="true";;
        *)          is="false";;
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

    if [[ -f $archive ]]
    then
       case $archive in
        *.tar.bz2)  bldr_run_cmd "$extr xvjf ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar.gz)   bldr_run_cmd "$extr xvzf ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar.xz)   bldr_run_cmd "$extr Jxvf ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.bz2)      bldr_run_cmd "bunzip2 ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.rar)      bldr_run_cmd "unrar x ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.gz)       bldr_run_cmd "gunzip ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.tar)      bldr_run_cmd "$extr xvf ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.tbz2)     bldr_run_cmd "$extr xvjf ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.tgz)      bldr_run_cmd "$extr xvzf ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.zip)      bldr_run_cmd "unzip -uo ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.Z)        bldr_run_cmd "uncompress ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *.7z)       bldr_run_cmd "7z x ${archive}" || bldr_bail "Failed to extract archive '${archive}'";;
        *)          bldr_bail "Failed to extract archive '${archive}'";;
       esac    
    fi
}

function bldr_strip_archive_ext()
{
    local archive=$1
    local result=""

    if [[ -f $archive ]]
    then
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
    local bad_archive=false

    if [[ -x $BLDR_LOCAL_PATH/gtar/latest/bin/tar ]]
    then
        extr=$BLDR_LOCAL_PATH/gtar/latest/bin/tar
    fi

    if [[ -f $archive ]]
    then
       case $archive in
        *.tar.bz2)  result=$(eval $extr tjf ${archive} ) || bad_archive=true;;
        *.tar.gz)   result=$(eval $extr tzf ${archive} ) || bad_archive=true;;
        *.tar.xz)   result=$(eval $extr Jtf ${archive} ) || bad_archive=true;;
        *.tar)      result=$(eval $extr tf ${archive} ) || bad_archive=true;;
        *.tbz2)     result=$(eval $extr tjf ${archive} ) || bad_archive=true;;
        *.tgz)      result=$(eval $extr tzf ${archive} ) || bad_archive=true;;
        *.zip)      result=$(eval unzip -l ${archive} ) || bad_archive=true;;
        *)          bad_archive=true;;
       esac    
    fi

    local listing=""
    local base_dir=$(bldr_strip_archive_ext "$archive")
    if [[ $bad_archive == true ]]
    then
        listing="error"
    
    elif [[ $(echo "$result" | grep -m1 -c "$base_dir") > 0 ]]
    then
        listing="$base_dir"
    
    else
        listing=$(echo "$result" | grep -E -o "(\S+)/" | sed 's/\/.*//g' | sort -u )
    fi
    echo "$listing"
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
    local use_verbose=$2
    local patch_cmd=$(which patch)

    # strip leading index '000_' from file name
    local patch_base="$(basename $patch_file)"
    local path_length=${#patch_base}
    local patch_path=$(echo $patch_base|sed 's/^[0-9]*_//g' )

    # split filename into dir parts replacing '_' with '/'
    patch_path=$(echo $patch_path|sed 's/_/\//g')

    if [[ $(echo $patch_path | grep -m1 -c '.diff$' ) > 0 ]]
    then
        # remove '.diff' suffix from filename
        patch_path=$(echo $patch_path|sed 's/.diff$//g')

        # provide the specific source file for the diff based on the name we reconstructed
        patch_cmd="$patch_cmd $patch_path -N"
        bldr_run_cmd "$patch_cmd < $patch_file"

    elif [[ $(echo "$patch_file" | grep -m1 -c '.patch$' ) > 0 ]]
    then

        # assume a unified top-level patch
        patch_cmd="$patch_cmd -p1 -N"
        bldr_run_cmd "$patch_cmd < $patch_file"

    elif [[ $(echo "$patch_file" | grep -m1 -c '.ed$' ) > 0 ]]
    then
        # remove '.ed' suffix from filename
        patch_path=$(echo $patch_path|sed 's/\.ed$//g')

        # use 'ed' to apply the patch
        patch_cmd=$(which ed)
        patch_cmd="$patch_cmd - $patch_path"
        bldr_run_cmd "$patch_cmd < $patch_file"
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

    bldr_run_cmd "tar ${flags} \"${archive}\" \"${dir}\""
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
    if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
    then
        # echo cp -TRv $src $dst
        cp -TR $src $dst || bldr_bail "Failed to copy from '$src' to '$dst'"

    elif [[ $BLDR_SYSTEM_IS_OSX == true ]]
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

        if [[ $(echo "$url" | grep -m1 -c '^http://') > 0 ]]
        then
            bldr_fetch $url $pkg_file 
        
        elif [[ $(echo "$url" | grep -m1 -c '^https://') > 0 ]]
        then
            bldr_fetch $url $pkg_file 

        elif [[ $(echo "$url" | grep -m1 -c '^ftp://') > 0 ]]
        then
            bldr_fetch $url $pkg_file 

        elif [[ $(echo "$url" | grep -m1 -c '^git://') > 0 ]]
        then
            bldr_clone $url $pkg_name 

            if [ -d $pkg_name ]
            then
                bldr_log_info "Archiving package '$pkg_file' from '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_archive $pkg_file $pkg_name
                bldr_remove_dir $pkg_name
                bldr_log_split
            fi

        elif [[ $(echo "$url" | grep -m1 -c '^svn://') > 0 ]]
        then
            bldr_checkout $url $pkg_name 

            if [ -d $pkg_name ]
            then
                bldr_log_split
                bldr_log_info "Archiving package '$pkg_file' from '$pkg_name/$pkg_vers'"
                bldr_log_split
                bldr_make_archive $pkg_file $pkg_name
                bldr_remove_dir $pkg_name
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

    local has_existing="false"
    if [ "$pkg_vers" == "" ]
    then
        pkg_vers="latest"
    fi

    if [ -d "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        if [ "$pkg_name" == "modules" ]
        then
            has_existing="true"

        elif [ -f "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
        then
            has_existing="true"
        
        elif [ -L "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
        then
            has_existing="true"
        fi        
    fi

    if [ "$pkg_name" != "modules" ] && [ "$has_existing" == "true" ]
    then
        if [ -d "$BLDR_PKGS_PATH/$pkg_ctry" ]
        then
            local found=""
            local fnd_list=""
            local fnd_list=$(find "$BLDR_PKGS_PATH/$pkg_ctry"/* -newer "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers" -iname "*$pkg_name.sh" -print 2>/dev/null )
            for found in ${fnd_list}
            do
                if [[ $(echo "$found" | grep -m1 -c "$pkg_name") > 0 ]]                    
                then
                    has_existing="false"
                fi
            done
        fi
    fi
    echo "$has_existing"
}

function bldr_find_pkg_ctry()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_opts=""
    local fnd_ctry=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --options)       pkg_opts="$pkg_opts $2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi
    
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    pkg_list=$(bldr_trim_str $pkg_name)

    if [[ "$pkg_ctry" == "" ]]
    then
        pkg_ctry="*"
    fi

    local pkg_dir="$BLDR_PKGS_PATH"
    if [[ ! -d $pkg_dir ]]
    then
        bldr_log_split
        bldr_log_error "Unable to locate package repository!  Please checkout the 'bldr/pkgs' into your local repo!"
        bldr_log_split
        return
    fi

    local found_pkg=false
    local pkg_ctry_path=""
    for pkg_ctry_path in $pkg_dir/$pkg_ctry
    do
        if [[ $found_pkg == true ]]
        then
            break
        fi

        local ctry_name=$(basename "$pkg_ctry_path")
        if [[ ! -d $pkg_dir/$ctry_name ]]
        then
            continue
        fi

        local pkg_sh=""
        for pkg_sh in $pkg_dir/$ctry_name/*
        do
            if [[ $found_pkg == true ]]
            then
                break
            fi
            
            if [[ ! -x "$pkg_sh" ]]
            then
                continue
            fi

            local pkg_tst_list=$pkg_list
            if [[ "$pkg_list" == "" ]]
            then
                local pkg_base="$(basename "$pkg_sh" )"
                local pkg_base_name="$(echo "$pkg_base" | sed 's/\.sh$//g' | sed 's/[0-9]*\-//' )"
                pkg_tst_list="$pkg_base_name"
            fi
            
            local pkg_entry=""
            local pkg_tst_name=""
            local pkg_tst_vers=""
            for pkg_entry in $pkg_tst_list
            do
                if [[ $(echo "$pkg_entry" | grep -m1 -c '\/') > 0 ]]
                then
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers=$(echo "$pkg_entry" | sed 's/.*\///g')
                else
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers="latest"
                fi

                if [[ $(echo "$pkg_sh" | grep -m1 -c "$pkg_tst_name" ) > 0 ]]
                then
                    fnd_ctry="$ctry_name"
                    found_pkg=true
                    break
                fi
            done
        done
    done

    echo "$fnd_ctry"
}

function bldr_has_required_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_opts=""
    local has_package="false"

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --options)       pkg_opts="$pkg_opts $2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi
    
    local force_rebuild=false
    if [[ $(echo "$pkg_opts" | grep -m1 -c 'force-rebuild' ) > 0 ]]
    then
        force_rebuild=true
    fi
    
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    pkg_list=$(bldr_trim_str $pkg_name)

    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry="*"
    fi

    local pkg_dir="$BLDR_PKGS_PATH"
    if [[ ! -d $pkg_dir ]]
    then
        bldr_log_split
        bldr_log_error "Unable to locate package repository!  Please checkout the 'bldr/pkgs' into your local repo!"
        bldr_log_split
        return
    fi

    local bld_cnt
    let bld_cnt=0
    local found_pkg=false
    local pkg_ctry_path=""

    for pkg_ctry_path in $pkg_dir/$pkg_ctry
    do
        if [[ $found_pkg == true ]]
        then
            break
        fi

        local ctry_name=$(basename "$pkg_ctry_path")
        if [[ ! -d $pkg_dir/$ctry_name ]]
        then
            continue
        fi

        local pkg_sh=""
        for pkg_sh in $pkg_dir/$ctry_name/*
        do
            if [[ $found_pkg == true ]]
            then
                break
            fi
            
            if [[ ! -x "$pkg_sh" ]]
            then
                continue
            fi

            local pkg_tst_list=$pkg_list
            if [[ "$pkg_list" == "" ]]
            then
                local pkg_base="$(basename "$pkg_sh" )"
                local pkg_base_name="$(echo "$pkg_base" | sed 's/\.sh$//g' | sed 's/[0-9]*\-//' )"
                pkg_tst_list="$pkg_base_name"
            fi
            
            local pkg_entry=""
            local pkg_tst_name=""
            local pkg_tst_vers=""
            for pkg_entry in $pkg_tst_list
            do
                if [[ $(echo "$pkg_entry" | grep -m1 -c '\/') > 0 ]]
                then
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers=$(echo "$pkg_entry" | sed 's/.*\///g')
                else
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers="latest"
                fi

                if [[ $(echo "$pkg_sh" | grep -m1 -c "$pkg_tst_name" ) > 0 ]]
                then

                    local use_existing="false"
                    if [[ $force_rebuild == true ]]
                    then
                        use_existing="false"
                    else
                        use_existing=$(bldr_has_pkg --category "$ctry_name" --name "$pkg_tst_name" --version "$pkg_tst_vers" --options "$pkg_opts" )
                    fi

                    has_package=$use_existing
                    found_pkg=true
                    break
                fi
            done
        done
    done

    echo "$has_package"
}


function bldr_build_required_pkg()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_opts=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --options)       pkg_opts="$pkg_opts $2"; shift 2;;
           * )              break ;;
        esac
    done


    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi
    
    local force_rebuild=false
    if [[ $(echo "$pkg_opts" | grep -m1 -c 'force-rebuild' ) > 0 ]]
    then
        force_rebuild=true
    fi
    
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    pkg_list=$(bldr_trim_str $pkg_name)

    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry="*"
    fi

    local pkg_dir="$BLDR_PKGS_PATH"
    if [[ ! -d $pkg_dir ]]
    then
        bldr_log_split
        bldr_log_error "Unable to locate package repository!  Please checkout the 'bldr/pkgs' into your local repo!"
        bldr_log_split
        return
    fi

    local bld_cnt
    let bld_cnt=0
    local found_pkg=false
    local pkg_ctry_path=""

    for pkg_ctry_path in $pkg_dir/$pkg_ctry
    do    
        local ctry_name=$(basename "$pkg_ctry_path")
        if [[ ! -d $pkg_dir/$ctry_name ]]
        then
            continue
        fi

        local pkg_sh=""
        for pkg_sh in $pkg_dir/$ctry_name/*
        do
            if [[ ! -x "$pkg_sh" ]]
            then
                continue
            fi

            local pkg_tst_list=$pkg_list
            if [[ "$pkg_list" == "" ]]
            then
                local pkg_base="$(basename "$pkg_sh" )"
                local pkg_base_name="$(echo "$pkg_base" | sed 's/\.sh$//g' | sed 's/[0-9]*\-//' )"
                pkg_tst_list="$pkg_base_name"
            fi
            
            local pkg_entry=""
            local pkg_tst_name=""
            local pkg_tst_vers=""
            for pkg_entry in $pkg_tst_list
            do
                if [[ $(echo "$pkg_entry" | grep -m1 -c '\/') > 0 ]]
                then
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers=$(echo "$pkg_entry" | sed 's/.*\///g')
                else
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers="latest"
                fi

                if [[ $(echo "$pkg_sh" | grep -m1 -c "$pkg_tst_name" ) > 0 ]]
                then

                    local use_existing="false"
                    if [[ $force_rebuild == true ]]
                    then
                        use_existing="false"
                    else
                        use_existing=$(bldr_has_pkg --category "$ctry_name" --name "$pkg_tst_name" --version "$pkg_tst_vers" --options "$pkg_opts" )
                    fi

                    if [ "$use_existing" == "false" ]
                    then
                        bldr_log_status "Building required '$pkg_tst_name/$pkg_tst_vers' from '$ctry_name' ... "
                        bldr_log_split
                        eval $pkg_sh || exit -1
                        return
                    fi
                fi
            done
        done
    done
}

function bldr_load_pkg()
{
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""
    local pkg_opts=""
    local use_verbose=false

    while true ; do
        case "$1" in
           --name)          pkg_name="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --options)       pkg_opts="$2"; shift 2;;
           --verbose)       use_verbose="$2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$pkg_vers" == "" ]
    then
        pkg_vers="latest"
    fi

    if [ "$pkg_name" == "" ]
    then
        bldr_bail "Unable to load package -- package name not specified!"
    fi   

    if [ "$(type -t module)" != "function" ]
    then
        bldr_log_warning "Module environment not setup!  Skipping load request for package '$pkg_name/$pkg_vers' ..."
        return
    fi
    
    local loaded=false
    local found=""
    local entry=""
    local ctry_entry=""
    local ctry_list=""

    if [ "$pkg_ctry" == "" ]
    then
        found=$(find $BLDR_MODULE_PATH/* -iname "$pkg_name" )
        for entry in ${found}
        do
            ctry_entry=$(dirname $entry)
            ctry_list="$ctry_list $ctry_entry"
        done
    else
        ctry_list="$BLDR_MODULE_PATH/$pkg_ctry"
    fi

    for ctry_entry in ${ctry_list}
    do
        local fnd_list=$(find $ctry_entry/$pkg_name/* -iname "$pkg_vers" )
        local fnd_entry=""

        local fnd_ctry=$(basename "$ctry_entry")
        if [ -d "$BLDR_MODULE_PATH/$pkg_ctry" ]
        then
            module use "$BLDR_MODULE_PATH/$pkg_ctry" || bldr_bail "Failed to load '$pkg_ctry' module!"
        fi

        for fnd_entry in ${fnd_list}
        do
            local fnd_vers=$(basename "$fnd_entry")
            bldr_log_info "Loading module '$pkg_name/$fnd_vers' from '$fnd_ctry' ..."
            module load $pkg_name/$fnd_vers || bldr_bail "Failed to load '$pkg_name/$fnd_vers' module from '$fnd_ctry'!"
            loaded=true
        done
    done

    if [[ $loaded == false ]]
    then
        bldr_log_warning "Failed to locate a suitable module to load for package '$pkg_name/$pkg_vers' ..."
    fi
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-setup" ) > 0 ]]
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
        if [[ $BLDR_VERBOSE == true ]]
        then
            bldr_log_info "Removing stale build '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers'"
            bldr_log_split
        fi
        bldr_remove_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    fi

#    bldr_make_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
#    bldr_log_split

    if [ -f "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        if [[ $BLDR_VERBOSE == true ]]
        then
            bldr_log_info "Removing stale module '$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers'"
            bldr_log_split
        fi
        bldr_remove_file "$BLDR_MODULE_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    fi

    if [ -d "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        if [[ $BLDR_VERBOSE == true ]]
        then
            bldr_log_info "Removing stale install '$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers'"
            bldr_log_split
        fi
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-fetch" ) > 0 ]]
    then
        return
    fi

    # create the local cache dir if it doesn't exist
    if [ ! -d $BLDR_CACHE_PATH ]
    then
        bldr_make_dir "$BLDR_CACHE_PATH"
        bldr_log_split
    fi

    if [ -e "$BLDR_CACHE_PATH/$pkg_file" ]
    then
        local archive_list=$(bldr_list_archive "$BLDR_CACHE_PATH/$pkg_file" )
        if [ "$archive_list" == "error" ]
        then
            bldr_log_split
            bldr_log_info "Existing package file in cache appears invalid!  Retrieving '$pkg_name/$pkg_vers' again ..."
            bldr_log_split
            bldr_remove_file "$BLDR_CACHE_PATH/$pkg_file"
        fi
    fi

    # if a local copy doesn't exist, grab the pkg from the url
    if [ ! -e "$BLDR_CACHE_PATH/$pkg_file" ]
    then
        bldr_push_dir "$BLDR_CACHE_PATH"
        bldr_download_pkg "$pkg_name" "$pkg_vers" "$pkg_urls" "$pkg_file" "$use_verbose"
        bldr_pop_dir
    fi
    
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

        bldr_log_info "Extracting package '$pkg_file' ..."
        bldr_log_split
        bldr_extract_archive "$pkg_file" 

        local move_item=""
        local move_list=$(echo "$archive_listing" | bldr_split_str " ")
        for move_item in $move_list
        do
            bldr_log_info "Moving '$move_item' to '$pkg_name/$pkg_vers' ..."
            bldr_move_file "$move_item" "$pkg_vers"
        done

        bldr_log_split
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
    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-system-patches" ) > 0 ]]
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

                bldr_apply_patch $patch_file $use_verbose
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

                bldr_apply_patch $patch_file $use_verbose
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

            bldr_apply_patch $patch_file $use_verbose
            bldr_log_split
        fi
    done
    bldr_pop_dir

    pkg_uses=$(bldr_trim_list_str "$pkg_uses")
    if [ "$pkg_uses" != "" ] && [ "$pkg_uses" != " " ] && [ "$pkg_uses" != ":" ]
    then
        pkg_uses=$(echo $pkg_uses | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_uses="$BLDR_DEFAULT_PKG_USES"
    fi

    if [ "$pkg_uses" != "" ]
    then
        for using in ${pkg_uses}
        do
            if [[ $(echo $using | grep -m1 -c '\/') > 0 ]]
            then
                local req_name=$(echo "$using" | sed 's/\/.*//g')
                local req_vers=$(echo "$using" | sed 's/.*\///g')
                bldr_load_pkg --name "$req_name" --version "$req_vers" --verbose $use_verbose
            else
                local req_name=$(echo "$using" | sed 's/\/.*//g')
                local req_vers="latest"
                bldr_load_pkg --name "$req_name" --version "$req_vers" --verbose $use_verbose                
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-boot" ) > 0 ]]
    then
        bldr_log_info "Skipping bootstrap ..."
        bldr_log_split
        bootstrap=false
    
    elif [[ $(echo "$pkg_opts" | grep -m1 -c "force-bootstrap" ) > 0 ]]
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
    if [[ $bootstrap == false ]]
    then
        if [[ $BLDR_VERBOSE == true ]]
        then
            bldr_log_info "No bootstrap script detected.  Skipping... "
            bldr_log_split
        fi
    else
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$boot_path"
        local boot_cmd=$(bldr_locate_boot_script $pkg_cfg_path)
        local output=$(bldr_get_stdout)

        if [ -x "$boot_cmd" ] && [ "$boot_cmd" != "." ]
        then
            if [[ $(echo "$pkg_opts" | grep -m1 -c "no-bootstrap-prefix" ) > 0 ]]
            then
                bldr_run_cmd "$boot_cmd"
            else
                bldr_run_cmd "$boot_cmd --prefix=\"$prefix\""
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

function bldr_maven_pkg()
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-config" ) > 0 ]]
    then
        return
    fi

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local cfg_path=$(bldr_locate_config_path $pkg_cfg_path $pkg_opts)
    bldr_pop_dir

  
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

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"

    bldr_log_status "Launching 'maven' for '$pkg_name/$pkg_vers' from '$cfg_path' ..."
    bldr_log_split

    bldr_run_cmd "mvn clean install ${pkg_cfg}"

    bldr_log_info "Done configuring package '$pkg_name/$pkg_vers'"
    bldr_log_split

    bldr_pop_dir
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-config" ) > 0 ]]
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
    local cmake_pre="-DCMAKE_INSTALL_PREFIX=\"$prefix\""

    if [[ $BLDR_SYSTEM_IS_OSX == true ]]
    then
        cmake_pre="$cmake_pre -DCMAKE_OSX_ARCHITECTURES=$BLDR_OSX_ARCHITECTURES"
        cmake_pre="$cmake_pre -DCMAKE_OSX_SYSROOT=$BLDR_OSX_SYSROOT"
        cmake_pre="$cmake_pre -DCMAKE_OSX_DEPLOYMENT_TARGET=$BLDR_OSX_DEPLOYMENT_TARGET"
    fi

    local use_static=false
    local use_shared=false

    if [[ $(echo "$pkg_opts" | grep -m1 -c "enable-shared" ) > 0 ]]
    then
        bldr_log_info "Adding 'shared' build configuration ..."
        bldr_log_split
        cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=ON"
        use_shared=true
    fi
    
    if [[ $(echo "$pkg_opts" | grep -m1 -c "enable-static" ) > 0 ]]
    then
        bldr_log_info "Adding 'static' build configuration ..."
        bldr_log_split
        cmake_pre="$cmake_pre -DBUILD_STATIC_LIBS=ON"
        use_static=true
    fi

    if [[ $(echo "$pkg_opts" | grep -m1 -c "force-shared" ) > 0 ]]
    then
        bldr_log_info "Forcing 'shared' build configuration ..."
        bldr_log_split
        if [ use_shared != true ]
        then
            cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF"
        fi
    fi

    if [[ $(echo "$pkg_opts" | grep -m1 -c "force-static" ) > 0 ]]
    then
        bldr_log_info "Forcing 'static' build configuration ..."
        bldr_log_split
        if [ use_static != true ]
        then
            cmake_pre="$cmake_pre -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON"
        fi
    fi

    bldr_run_cmd "$cmake_exec $cmake_mod $cmake_pre $env_flags $cmake_src_path"

    bldr_log_info "Done configuring package '$pkg_name/$pkg_vers'"
    bldr_log_split
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-config" ) > 0 ]]
    then
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    if [[ $(echo "$pkg_opts" | grep -m1 -c "use-build-dir" ) > 0 ]]
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-auto-compile-flags" ) < 1 ]]
    then
        if [[ $BLDR_SYSTEM_IS_OSX == true ]]
        then
            if [[ $(echo "$pkg_opts" | grep -m1 -c "disable-xcode-cflags" ) > 0 ]]
            then
                bldr_log_info "Disabling XCode Compile FLAGS ..."
                bldr_log_split
            else
                pkg_cflags="$pkg_cflags:$BLDR_XCODE_CFLAGS"
            fi

            if [[ $(echo "$pkg_opts" | grep -m1 -c "disable-xcode-ldflags" ) > 0 ]]
            then
                bldr_log_info "Disabling XCode Linker FLAGS ..."
                bldr_log_split
            else
                pkg_ldflags="$pkg_ldflags:$BLDR_XCODE_LDFLAGS"
            fi
        fi
    fi

    pkg_cflags=$(bldr_trim_list_str "$pkg_cflags")
    if [ "$pkg_cflags" != "" ] && [ "$pkg_cflags" != " " ]  && [ "$pkg_cflags" != ":" ]
    then
        pkg_cflags=$(echo $pkg_cflags | bldr_split_str ":" | bldr_join_str " ")
        if [[ $BLDR_SYSTEM_IS_CENTOS == true ]]
        then
            pkg_cflags="$pkg_cflags -I/usr/include"
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
        if [[ $BLDR_SYSTEM_IS_CENTOS == true ]]
        then
            pkg_ldflags="$pkg_ldflags -L/usr/lib64 -L/usr/lib"
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "enable-shared" ) > 0 ]]
    then
        bldr_log_info "Adding 'shared' build configuration ..."
        bldr_log_split
        pkg_cfg="$pkg_cfg --enable-shared"
        use_shared=true
    fi
    
    if [[ $(echo "$pkg_opts" | grep -m1 -c "enable-static" ) > 0 ]]
    then
        bldr_log_info "Adding 'static' build configuration ..."
        bldr_log_split
        pkg_cfg="$pkg_cfg --enable-static"
        use_static=true
    fi

    if [[ $(echo "$pkg_opts" | grep -m1 -c "force-shared" ) > 0 ]]
    then
        bldr_log_info "Forcing 'shared' build configuration ..."
        bldr_log_split
        if [ $use_shared != true ]
        then
            pkg_cfg="$pkg_cfg --enable-shared --disable-static"
        fi

    elif [[ $(echo "$pkg_opts" | grep -m1 -c "force-static" ) > 0 ]]
    then
        bldr_log_info "Forcing 'static' build configuration ..."
        bldr_log_split
        if [ $use_static != true ]
        then
            pkg_cfg="$pkg_cfg --disable-shared --enable-static"
        fi
    fi

    if [[ $(echo "$pkg_opts" | grep -m1 -c "use-build-dir" ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/build"
    else
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path"
    fi

    local cfg_cmd=$(bldr_locate_config_script $pkg_cfg_path $pkg_opts)
    local output=$(bldr_get_stdout)  

    if [[ $(echo "$pkg_opts" | grep -m1 -c "config-agree-to-prompt" ) > 0 ]]
    then
        bldr_log_cmd "$cfg_cmd --prefix=\"$prefix\" $pkg_cfg $env_flags"
        bldr_log_split

        if [ $BLDR_VERBOSE != false ]
        then
            echo "yes" | eval $cfg_cmd "--prefix=\"$prefix\" ${pkg_cfg} ${env_flags}" || bldr_bail "Failed to configure: '$prefix'"
            bldr_log_split
        else
            echo "yes" | eval $cfg_cmd "--prefix=\"$prefix\" ${pkg_cfg} ${env_flags}" &> /dev/null || bldr_bail "Failed to configure: '$prefix'"
        fi
    else    
        bldr_run_cmd "$cfg_cmd --prefix=\"$prefix\" ${pkg_cfg} ${env_flags}"
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-config" ) > 0 ]]
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

    local use_maven=false
    local has_maven=false

    if [[ $(bldr_is_cmake_file "$cfg_cmd") == "true" ]]
    then
        has_cmake=true
    
    elif [[ $(bldr_is_autoconf_file "$cfg_cmd") == "true" ]]
    then
        has_autocfg=true
    
    elif [[ $(bldr_is_maven_file "$cfg_cmd") == "true" ]]
    then
        has_maven=true
    fi

    if [[ $(echo "$pkg_opts" | grep -m1 -c "cmake" ) > 0 ]]
    then
        use_cmake=true
        use_autocfg=false
        has_autocfg=false
    
    elif [[ $(echo "$pkg_opts" | grep -m1 -c "configure" ) > 0 ]]
    then
        use_cmake=false
        has_cmake=false
        use_autocfg=true

    elif [[ $(echo "$pkg_opts" | grep -m1 -c "maven" ) > 0 ]]
    then
        use_maven=true
        use_cmake=false
        has_cmake=false
        use_autocfg=false
        has_autocfg=false
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

    if [ $use_maven == true ] && [ $has_maven == true ]
    then
        bldr_log_info "Using maven for '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$cfg_path' ..."
        bldr_log_split

        bldr_maven_pkg                    \
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-compile" ) > 0 ]]
    then
        return
    fi

    if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_warning "Build directory not found for '$pkg_name/$pkg_vers'!  Skipping 'compile' stage ..."
        bldr_log_split
        return
    fi

    # setup the build and prep for the compile
    #
    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_status "Building package '$pkg_name/$pkg_vers'"
    bldr_log_split
    
    bldr_log_info "Moving to build path: '$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path' ..."
    bldr_log_split
    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"

    if [[ $(echo "$pkg_opts" | grep -m1 -c "force-serial-build" ) > 0 ]]
    then
        bldr_log_info "Forcing serial build for '$pkg_name/$pkg_vers' ..."
        bldr_log_split
        BLDR_PARALLEL=false
    fi

    local defines=""
    local output=$(bldr_get_stdout)
    local options="--stop"

    if [[ $BLDR_VERBOSE != true ]]
    then
        options="--quiet $options"
    fi

    if [[ $BLDR_PARALLEL == true ]]
    then
        local procs=2
        if [[ $BLDR_SYSTEM_IS_OSX == true ]]
        then
            procs=$(sysctl -n hw.ncpu)
        fi
        if [[ $BLDR_SYSTEM_IS_LINUX == true ]]
        then
            procs=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)
        fi
        options="-j$procs $options"
    fi

    # append any -M directives as macros to the make command (eg. -MMAKE_EXAMPLES=0 -> MAKE_EXAMPLES=0)
    if [[ $(echo "$pkg_opts" | grep -m1 -c '\-M') > 0 ]]
    then
        local def=""
        defines=$(echo $pkg_opts | grep -E -o "\-M(\S+)\s*" | sed 's/-M//g' )
        for def in ${defines}
        do
            options="$options $def"
        done
    fi

    if [ -f "./Makefile" ] || [ -f "./makefile" ]
    then
        bldr_run_cmd "make $options" || bldr_bail "Failed to build package: '$prefix'"
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-install" ) > 0 ]]
    then
        return
    fi

    if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_warning "Build directory not found for '$pkg_name/$pkg_vers'!  Skipping 'install' stage ..."
        bldr_log_split
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"

    local output=$(bldr_get_stdout)
    local options="--stop"
    if [ $BLDR_VERBOSE != true ]
    then
        options="--quiet $options"
    fi
    # extract the makefile rule names and filter out empty lines and comments
    if [ -f "./Makefile" ] || [ -f "./makefile" ]
    then
        # install using make if an 'install' rule exists
        local rules=$(make -pnsk | grep -v ^$ | grep -v ^# | grep -m1 -c '^install:')
        if [[ $(echo "$rules") > 0 ]]
        then

            # append any -M directives as macros to the make command (eg. -MMAKE_EXAMPLES=0 -> MAKE_EXAMPLES=0)
            if [[ $(echo "$pkg_opts" | grep -m1 -c '\-M') > 0 ]]
            then
                local def=""
                defines=$(echo $pkg_opts | grep -E -o "\-M(\S+)\s*" | sed 's/-M//g' )
                for def in ${defines}
                do
                    options="$options $def"
                done
            fi

            bldr_log_status "Installing package '$pkg_name/$pkg_vers'"
            bldr_log_split

            bldr_run_cmd "make $options install" || bldr_bail "Failed to install package: '$prefix'"
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-migrate" ) > 0 ]]
    then
        return
    fi

    if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_warning "Build directory not found for '$pkg_name/$pkg_vers'!  Skipping 'migrate' stage ..."
        bldr_log_split
        return
    fi

    local prefix="$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"

    bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
    local build_path=$(bldr_locate_build_path $pkg_cfg_path)
    bldr_pop_dir

    bldr_log_status "Migrating package '$pkg_name/$pkg_vers' ..."
    bldr_log_split

    local src_path=""

    # build using make if a makefile exists
    if [ -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path" ] 
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers/$build_path"
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "migrate-build-tree" ) > 0 ]]
    then
        bldr_make_dir "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_copy_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" || bldr_bail "Failed to copy shared files into directory: $BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        bldr_log_split
    fi
    
    if [[ $(echo "$pkg_opts" | grep -m1 -c "migrate-build-headers" ) > 0 ]]
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "migrate-build-source" ) > 0 ]]
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "migrate-build-bin" ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        local bin_paths=". lib bin lib32 lib64 build src"
        local binary=""
        local subdir=""
        local src_path=""
        for src_path in ${bin_paths}
        do
            # move product into external path
            if [ $src_path == "." ] || [ $src_path == "src" ] || [ $src_path == "build" ]
            then
                subdir="bin"
            else
                subdir="$src_path"
            fi

            if [ ! -d "$src_path" ]
            then
                continue
            fi

            local first_file=1
            local binary=""
            for binary in ${src_path}/*
            do
                if [ -x "$binary" ] && [ ! -d "$binary" ]
                then
                    if [[ $(bldr_is_library "$binary") == "true" ]]
                    then
                        subdir="lib"
                    fi
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
        done
        bldr_pop_dir
    fi    

    if [[ $(echo "$pkg_opts" | grep -m1 -c "migrate-build-doc" ) > 0 ]]
    then
        bldr_push_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
        local inc_paths="doc man share etc"
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-cleanup" ) > 0 ]]
    then
        return
    fi

    if [ ! -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_warning "Build directory not found for '$pkg_name/$pkg_vers'!  Skipping 'cleanup' stage ..."
        bldr_log_split
        return
    fi

    bldr_log_status "Cleaning package '$pkg_name/$pkg_vers' ..."
    bldr_log_split
    
    if [[ $(echo "$pkg_opts" | grep -m1 -c "keep" ) > 0 ]]
    then
        bldr_log_info "Keeping package build directory for '$pkg_name/$pkg_vers'"
        bldr_log_split
    else
        if [ -d "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
        then
            bldr_log_info "Removing package build directory for '$pkg_name/$pkg_vers'"
            bldr_log_split

            bldr_remove_dir "$BLDR_BUILD_PATH/$pkg_ctry/$pkg_name/$pkg_vers"
            bldr_log_split
        fi
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

    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-modulate" ) > 0 ]]
    then
        return
    fi
    if [ ! -d "$BLDR_LOCAL_PATH/$pkg_ctry/$pkg_name/$pkg_vers" ]
    then
        bldr_log_warning "Local directory not found for '$pkg_name/$pkg_vers'!  Skipping 'modulate' stage ..."
        bldr_log_split
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
            echo "if { ! [ is-loaded $require ] } {"            >> $module_file
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
    echo ""                                                                  >> $module_file
    
    # append any -E directives as environment variables to export (eg. -EPYTHONPATH=path/to/export -> PYTHONPATH=path/to/export)
    local def_name=""
    local def_value=""
    if [[ $(echo "$pkg_opts" | grep -m1 -c '\-E') > 0 ]]
    then
        local def=""
        local defines=$(echo $pkg_opts | grep -E -o "\-E(\S+)\s*" | sed 's/-E//g' )
        for def in ${defines}
        do
            if [[ $(echo "$def" | grep -m1 -c '\+=') == "true" ]]
            then
                def_name=$(echo $def | sed 's/+=.*//g')
                def_value=$(echo $def | sed 's/.*+=//g')
                echo "append-path  $def_name                $def_value"      >> $module_file
            elif [[ $(echo "$def" | grep -m1 -c '\:=') == "true" ]]
            then
                def_name=$(echo $def | sed 's/:=.*//g')
                def_value=$(echo $def | sed 's/.*:=//g')
                echo "prepend-path $def_name                $def_value"      >> $module_file
            elif [[ $(echo "$def" | grep -m1 -c '=') == "true" ]]
            then
                def_name=$(echo $def | sed 's/=.*//g')
                def_value=$(echo $def | sed 's/.*=//g')
                echo "setenv       $def_name                $def_value"      >> $module_file
            fi
        done
        echo ""                                                              >> $module_file
    fi

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

    for found in $(find $prefix -type d -iname "site-packages")
    do
        echo ""                                                              >> $module_file
        echo "append-path $pkg_title""_PYTHON_SITE_PACKAGES_PATH $found"     >> $module_file
        echo "append-path PYTHONPATH $found"                                 >> $module_file
    done

    for found in $(find $prefix -type d -iname "lib")
    do
        echo ""                                                              >> $module_file
        echo "setenv $pkg_title""_LIB_PATH                  $found"          >> $module_file
        echo ""                                                              >> $module_file
        if [[ $BLDR_SYSTEM_IS_OSX == true ]]
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
        if [[ $BLDR_SYSTEM_IS_OSX == true ]]
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
        if [[ $BLDR_SYSTEM_IS_OSX == true ]]
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
        pkg_latest=$(bldr_find_latest_version_file "$module_dir" )
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
    local pkg_opts=" "
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

    pkg_vers=$(bldr_trim_list_str "$pkg_vers")
    pkg_ctry=$(bldr_trim_list_str "$pkg_ctry")
    pkg_name=$(bldr_trim_list_str "$pkg_name")

    if [ "$pkg_name" == "" ] || [ "$pkg_vers" == "" ] || [ "$pkg_file" == "" ]
    then
        bldr_bail "Incomplete package definition!  Need at least 'name', 'version' and 'file' defined!"
    fi

    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry="$BLDR_USE_PKG_CTRY"
    fi
    
    if [ "$BLDR_USE_PKG_OPTS" != "" ]
    then
        pkg_opts="$BLDR_USE_PKG_OPTS $pkg_opts"
    fi

    local existing="false"
    if [[ $(echo "$pkg_opts" | grep -m1 -c "force-rebuild" ) > 0 ]]
    then
        bldr_log_status "Rebuilding package '$pkg_name/$pkg_vers' ... "
        bldr_log_split
    else
        existing=$(bldr_has_pkg --category "$pkg_ctry" --name "$pkg_name" --version "$pkg_vers" --options "$pkg_opts" )
    fi

    if [ "$existing" == "true" ]
    then
        if [ $BLDR_VERBOSE != false ]
        then
            bldr_log_info "Skipping existing package '$pkg_name/$pkg_vers' ... "
            bldr_log_split
        fi
        return
    fi

    local pkg_needs=$(bldr_trim_list_str "$pkg_uses $pkg_reqs")
    if [ "$pkg_needs" != "" ] && [ "$pkg_needs" != " " ] && [ "$pkg_needs" != ":" ]
    then
        pkg_needs=$(echo $pkg_needs | bldr_split_str ":" | bldr_join_str " ")
    else
        pkg_needs=""
    fi

    local pkg_req_has=""
    local pkg_req_build=""
    local pkg_need_name=""

    if [ "$pkg_needs" != "" ] && [[ $(echo "$pkg_opts" | grep -m1 -c "skip-build-dependencies" ) < 1 ]]
    then
        for pkg_need_name in ${pkg_needs}
        do
            if [[ $(echo $pkg_need_name | grep -m1 -c '\/') > 0 ]]
            then
                local req_name=$(echo "$pkg_need_name" | sed 's/\/.*//g')
                local req_vers=$(echo "$pkg_need_name" | sed 's/.*\///g')
            else
                local req_name=$(echo "$pkg_need_name" | sed 's/\/.*//g')
                local req_vers="latest"
            fi

            local has_existing=$(bldr_has_required_pkg --name "$req_name" --version "$req_vers" )
            
            if [ $has_existing == "false" ]
            then
                if [[ $(echo $pkg_req_build | grep -m1 -c "$req_name/$req_vers") < 1 ]]
                then
                    pkg_req_build="$pkg_req_build $req_name/$req_vers"
                fi
            else
                if [[ $(echo $pkg_req_has | grep -m1 -c "$req_name/$req_vers") < 1 ]]
                then
                    bldr_log_info "Using required package '$req_name/$req_vers' for '$pkg_name/$pkg_vers' ... "                
                    pkg_req_has="$pkg_req_has $req_name/$req_vers"

                    if [[ $(echo "$pkg_opts" | grep -m1 -c "skip-auto-compile-flags" ) < 1 ]]
                    then
                        local req_ctry=$(bldr_find_pkg_ctry --name "$req_name" --version "$req_vers" )
                        local req_inc="$BLDR_LOCAL_PATH/$req_ctry/$req_name/$req_vers/include"
                        local req_lib="$BLDR_LOCAL_PATH/$req_ctry/$req_name/$req_vers/lib"

                        if [[ -d "$req_inc" ]] && [[ $(echo $pkg_cflags | grep -m1 -c "$req_inc") < 1 ]]
                        then
                            pkg_cflags="$pkg_cflags:-I$req_inc"
                        fi

                        if [[ -d "$req_lib" ]] && [[ $(echo $pkg_ldflags | grep -m1 -c "$req_lib") < 1 ]]
                        then
                            pkg_ldflags="$pkg_ldflags:-L$req_lib"
                        fi
                    fi
                fi
            fi
        done

        if [[ "$pkg_req_build" != "" ]]
        then
            bldr_log_split
            bldr_log_status "Building required dependencies:"
            bldr_log_split

            bldr_log_list $pkg_req_build
            bldr_log_split

            for pkg_need_name in ${pkg_req_build}
            do
                if [[ $(echo $pkg_need_name | grep -m1 -c '\/') > 0 ]]
                then
                    local req_name=$(echo "$pkg_need_name" | sed 's/\/.*//g')
                    local req_vers=$(echo "$pkg_need_name" | sed 's/.*\///g')
                else
                    local req_name=$(echo "$pkg_need_name" | sed 's/\/.*//g')
                    local req_vers="latest"
                fi
                bldr_build_required_pkg --name "$req_name" --version "$req_vers" --verbose "$use_verbose"
            done        
        fi
        bldr_log_split
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
    local pkg_vers=""
    local pkg_opts=""

    while true ; do
        case "$1" in
           --verbose)       use_verbose="$2"; shift 2;;
           --name)          pkg_name="$2"; shift 2;;
           --category)      pkg_ctry="$2"; shift 2;;
           --version)       pkg_vers="$2"; shift 2;;
           --options)       pkg_opts="$pkg_opts $2"; shift 2;;
           * )              break ;;
        esac
    done

    if [ "$use_verbose" == "true" ]
    then
        BLDR_VERBOSE=true
    fi
    
    if [ "$BLDR_USE_PKG_OPTS" != "" ]
    then
        pkg_opts="$BLDR_USE_PKG_OPTS $pkg_opts"
    fi

    if [ "$pkg_vers" == "" ]
    then
        pkg_vers="latest"
    fi

    local pkg_vers=$(echo "$pkg_vers" | sed 's/\://g' )
    local pkg_ctry=$(echo "$pkg_ctry" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_list=$(echo "$pkg_name" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_dir="$BLDR_PKGS_PATH"

    local force_rebuild=false
    if [[ $(echo "$pkg_opts" | grep -m1 -c 'force-rebuild' ) > 0 ]]
    then
        force_rebuild=true
    fi
    
    # push the system category onto the list if it hasn't been built yet
    pkg_ctry=$(bldr_trim_str $pkg_ctry)
    if [ "$pkg_ctry" == "" ]
    then
        pkg_ctry="$BLDR_DEFAULT_BUILD_LIST"
    fi

    if [[ ! -d $BLDR_LOCAL_PATH/internal ]]
    then
        if [[ $(echo "$pkg_ctry" | grep -m1 -c 'internal' ) < 1 ]]
        then
            pkg_ctry="internal $pkg_ctry"
        fi
    fi

    local pkg_vers=$(echo "$pkg_vers" | sed 's/\://g' )
    local pkg_ctry=$(echo "$pkg_ctry" | bldr_split_str ":" | bldr_join_str " ")
    local pkg_list=$(echo "$pkg_name" | bldr_split_str ":" | bldr_join_str " ")

    if [[ ! -d $pkg_dir ]]
    then
        bldr_log_split
        bldr_log_error "Unable to locate package repository!  Please checkout the 'bldr/pkgs' into your local repo!"
        bldr_log_split
        return
    fi

    bldr_log_split
    bldr_log_status "Starting build from '$pkg_dir' ..."
    bldr_log_split
    
    local bld_cnt
    let bld_cnt=0
    local pkg_ctry_path=""
    for pkg_ctry_path in $pkg_dir/$pkg_ctry
    do
        local ctry_name=$(basename "$pkg_ctry_path")
        if [[ ! -d $pkg_dir/$ctry_name ]]
        then
            continue
        fi

        local ctry_cnt
        let ctry_cnt=0
        local pkg_sh=""
        for pkg_sh in $pkg_dir/$ctry_name/*
        do
            if [[ ! -x "$pkg_sh" ]]
            then
                continue
            fi

            local pkg_tst_list=$pkg_list
            if [[ "$pkg_list" == "" ]]
            then
                local pkg_base="$(basename "$pkg_sh" )"
                local pkg_base_name="$(echo "$pkg_base" | sed 's/\.sh$//g' | sed 's/[0-9]*\-//' )"
                pkg_tst_list="$pkg_base_name"
            fi
            
            local pkg_entry=""
            local pkg_tst_name=""
            local pkg_tst_vers=""
            for pkg_entry in $pkg_tst_list
            do
                if [[ $(echo "$pkg_entry" | grep -m1 -c '\/') > 0 ]]
                then
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers=$(echo "$pkg_entry" | sed 's/.*\///g')
                else
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers="$pkg_vers"
                fi

                if [[ $(echo "$pkg_sh" | grep -m1 -c "$pkg_tst_name" ) > 0 ]]
                then

                    local use_existing="false"
                    if [[ $force_rebuild == true ]]
                    then
                        use_existing="false"
                    else
                        use_existing=$(bldr_has_pkg --category "$ctry_name" --name "$pkg_tst_name" --version "$pkg_tst_vers" --options "$pkg_opts" )
                    fi

                    if [ "$use_existing" == "false" ]
                    then
                        let bld_cnt++
                        let ctry_cnt++
                    fi
                fi
            done
        done

        if [[ $ctry_cnt -gt 0 ]]
        then
            bldr_log_list_item_suffix $ctry_cnt "$ctry_name" "Matching packages in"

        elif [[ $BLDR_VERBOSE == true ]]
        then
            bldr_log_list_item_suffix $ctry_cnt "$ctry_name" "Matching packages in"
        fi
    done

    if [ $BLDR_VERBOSE == true ] || [ $bld_cnt -gt 0 ]
    then
        bldr_log_split
    fi
    
    if [ $bld_cnt -lt 1 ]
    then
        bldr_log_warning "No matching packages found!  Use --option 'force-rebuild' to override!"
        bldr_log_split
        return
    fi

    local bld_idx
    let bld_idx=0
    local txt_cnt=$(printf "%03d" $bld_cnt)
    local pkg_ctry_path=""
    for pkg_ctry_path in $pkg_dir/$pkg_ctry
    do
        local ctry_name=$(basename "$pkg_ctry_path")
        if [[ ! -d $pkg_dir/$ctry_name ]]
        then
            continue
        fi

        local pkg_sh=""
        for pkg_sh in $pkg_dir/$ctry_name/*
        do
            if [[ ! -x "$pkg_sh" ]]
            then
                continue
            fi

            local pkg_tst_list=$pkg_list
            local pkg_base_name=""
            if [[ "$pkg_list" == "" ]]
            then
                local pkg_base="$(basename "$pkg_sh" )"
                pkg_base_name="$(echo "$pkg_base" | sed 's/\.sh$//g' | sed 's/[0-9]*\-//' )"
                pkg_tst_list="$pkg_base_name"
            fi

            local pkg_entry=""
            local pkg_tst_name=""
            local pkg_tst_vers=""
            for pkg_entry in $pkg_tst_list
            do
                if [[ $(echo "$pkg_entry" | grep -m1 -c '\/') > 0 ]]
                then
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers=$(echo "$pkg_entry" | sed 's/.*\///g')
                else
                    pkg_tst_name=$(echo "$pkg_entry" | sed 's/\/.*//g')
                    pkg_tst_vers="$pkg_vers"
                fi

                if [[ $(echo "$pkg_sh" | grep -m1 -c "$pkg_tst_name" ) > 0 ]]
                then

                    local use_existing="false"
                    if [[ $force_rebuild == true ]]
                    then
                        use_existing="false"
                    else
                        use_existing=$(bldr_has_pkg --category "$ctry_name" --name "$pkg_tst_name" --version "$pkg_tst_vers" --options "$pkg_opts" )
                    fi
                    
                    if [[ "$use_existing" == "false" ]]
                    then
                        let bld_idx++
                        local txt_idx=$(printf "%03d" $bld_idx)

                        bldr_log_list_item_progress $bld_idx $bld_cnt "Building '$pkg_tst_name/$pkg_tst_vers' from '$ctry_name' ... "
                        bldr_log_split

                        export BLDR_USE_PKG_CTRY="$ctry_name"
                        export BLDR_USE_PKG_OPTS="$pkg_opts"

                        eval $pkg_sh || exit -1

                        export BLDR_USE_PKG_CTRY=""
                        export BLDR_USE_PKG_OPTS=""
                    fi
                fi
            done
        done
    done
}


####################################################################################################

function bldr_modularize_pkgs()
{
    local use_verbose="false"
    local pkg_ctry=""
    local pkg_name="" 
    local pkg_vers=""

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
        pkg_ctry="$BLDR_DEFAULT_BUILD_LIST"
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
                        if [[ $(echo "$pkg_def" | grep -m1 -c "*$entry*" ) > 0 ]]
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
        local pkg_category=""
        local pkg_entry=""

        bldr_log_split
        bldr_log_status "Loading for '$pkg_ctry' in '$md_path'..."
        bldr_log_split

        for pkg_category in $md_path/$pkg_ctry
        do
            local base_ctry=$(basename $pkg_category)

            bldr_log_info "Loading category '$base_ctry'"
            bldr_log_split

            module use $md_path/$base_ctry || bldr_bail "Failed to load module '$base_ctry'!"

            for pkg_entry in $md_path/$base_ctry/*
            do
                if [[ $(echo "$BLDR_LOADED_MODULES" | grep -m1 -c "$using" ) > 0 ]]
                then
                    local $using=$(basename $pkg_entry)
                    module load $using || bldr_bail "Failed to load module '$pkg_entry' from '$base_ctry'!"
                    BLDR_LOADED_MODULES="$BLDR_LOADED_MODULES:$using"
                fi
            done
        done
    fi
}
