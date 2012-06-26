#! /usr/bin/env bash
# This file contains the complete sequence of commands
# CodeSourcery used to build this version of Sourcery G++.
# 
# For each free or open-source component of Sourcery G++, the
# source code provided includes all of the configuration
# scripts and makefiles for that component, including any and
# all modifications made by CodeSourcery.  From this list of
# commands, you can see every configuration option used by
# CodeSourcery during the build process.
# 
# This file is provided as a guideline for users who wish to
# modify and rebuild a free or open-source component of
# Sourcery G++ from source. For a number of reasons, though,
# you may not be able to successfully run this script directly
# on your system. Certain aspects of the CodeSourcery build
# environment (such as directory names) are included in these
# commands. CodeSourcery uses Canadian cross compilers so you
# may need to modify various configuration options and paths
# if you are building natively. This sequence of commands
# includes those used to build proprietary components of
# Sourcery G++ for which source code is not provided.
# 
# Please note that Sourcery G++ support covers only your use
# of the original, validated binaries provided as part of
# Sourcery G++ -- and specifically does not cover either the
# process of rebuilding a component or the use of any binaries
# you may build.  In addition, if you rebuild any component,
# you must not use the --with-pkgversion and --with-bugurl
# configuration options that embed CodeSourcery trademarks in
# the resulting binary; see the "CodeSourcery Trademarks"
# section in the Sourcery G++ Software License Agreement.
set -e
inform_fd=2 
umask 022
exec < /dev/null

error_handler ()
{
    exit 1
}

check_status() {
    local status="$?"
    if [ "$status" -ne 0 ]; then
	error_handler
    fi
}

check_pipe() {
    local -a status=("${PIPESTATUS[@]}")
    local limit=$1
    local ix
    
    if [ -z "$limit" ] ; then
	limit="${#status[@]}"
    fi
    for ((ix=0; ix != $limit ; ix++)); do
	if [ "${status[$ix]}" != "0" ] ; then
	    error_handler
	fi
    done
}

error () {
    echo "$script: error: $@" >& $inform_fd
    exit 1
}

warning () {
    echo "$script: warning: $@" >& $inform_fd
}

verbose () {
    if $gnu_verbose; then
	echo "$script: $@" >& $inform_fd
    fi
}

copy_dir() {
    mkdir -p "$2"

    (cd "$1" && tar cf - .) | (cd "$2" && tar xf -)
    check_pipe
}

copy_dir_clean() {
    mkdir -p "$2"
    (cd "$1" && tar cf - \
	--exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc \
	--exclude="*~" --exclude=".#*" \
	--exclude="*.orig" --exclude="*.rej" \
	.) | (cd "$2" && tar xf -)
    check_pipe
}

update_dir_clean() {
    mkdir -p "$2"


    (cd "$1" && tar cf - \
	--exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc \
	--exclude="*~" --exclude=".#*" \
	--exclude="*.orig" --exclude="*.rej" \
	--after-date="$3" \
	. 2> /dev/null) | (cd "$2" && tar xf -)
    check_pipe
}

copy_dir_exclude() {
    local source="$1"
    local dest="$2"
    local excl="$3"
    shift 3
    mkdir -p "$dest"
    (cd "$source" && tar cfX - "$excl" "$@") | (cd "$dest" && tar xf -)
    check_pipe
}

copy_dir_only() {
    local source="$1"
    local dest="$2"
    shift 2
    mkdir -p "$dest"
    (cd "$source" && tar cf - "$@") | (cd "$dest" && tar xf -)
    check_pipe
}

clean_environment() {
    local env_var_list
    local var




    unset BASH_ENV CDPATH POSIXLY_CORRECT TMOUT

    env_var_list=$(export | \
	grep '^declare -x ' | \
	sed -e 's/^declare -x //' -e 's/=.*//')

    for var in $env_var_list; do
	case $var in
	    HOME|HOSTNAME|LOGNAME|PWD|SHELL|SHLVL|SSH_*|TERM|USER)


		;;
	    LD_LIBRARY_PATH|PATH| \
		FLEXLM_NO_CKOUT_INSTALL_LIC|LM_APP_DISABLE_CACHE_READ)


		;;
	    MAKEINFO)

		;;
	    *_LICENSE_FILE)












		if [ "" ]; then
		    local license_file_envvar
		    license_file_envvar=

		    if [ "$var" != "$license_file_envvar" ]; then
			export -n "$var" || true
		    fi
		else
		    export -n "$var" || true
		fi
		;;
	    *)

		export -n "$var" || true
		;;
	esac
    done


    export LANG=C
    export LC_ALL=C


    export CVS_RSH=ssh



    user_shell=$SHELL
    export SHELL=$BASH
    export CONFIG_SHELL=$BASH
}

pushenv() {
    pushenv_level=$(($pushenv_level + 1))
    eval pushenv_vars_${pushenv_level}=
}


pushenv_level=0
pushenv_vars_0=



pushenvvar() {
    local pushenv_var="$1"
    local pushenv_newval="$2"
    eval local pushenv_oldval=\"\$$pushenv_var\"
    eval local pushenv_oldset=\"\${$pushenv_var+set}\"
    local pushenv_save_var=saved_${pushenv_level}_${pushenv_var}
    local pushenv_savep_var=savedp_${pushenv_level}_${pushenv_var}
    eval local pushenv_save_set=\"\${$pushenv_savep_var+set}\"
    if [ "$pushenv_save_set" = "set" ]; then
	error "Pushing $pushenv_var more than once at level $pushenv_level"
    fi
    if [ "$pushenv_oldset" = "set" ]; then
	eval $pushenv_save_var=\"\$pushenv_oldval\"
    else
	unset $pushenv_save_var
    fi
    eval $pushenv_savep_var=1
    eval export $pushenv_var=\"\$pushenv_newval\"
    local pushenv_list_var=pushenv_vars_${pushenv_level}
    eval $pushenv_list_var=\"\$$pushenv_list_var \$pushenv_var\"
}

prependenvvar() {
    local pushenv_var="$1"
    local pushenv_newval="$2"
    eval local pushenv_oldval=\"\$$pushenv_var\"
    pushenvvar "$pushenv_var" "$pushenv_newval$pushenv_oldval"
}

popenv() {
    local pushenv_var=
    eval local pushenv_vars=\"\$pushenv_vars_${pushenv_level}\"
    for pushenv_var in $pushenv_vars; do
	local pushenv_save_var=saved_${pushenv_level}_${pushenv_var}
	local pushenv_savep_var=savedp_${pushenv_level}_${pushenv_var}
	eval local pushenv_save_val=\"\$$pushenv_save_var\"
	eval local pushenv_save_set=\"\${$pushenv_save_var+set}\"
	unset $pushenv_save_var
	unset $pushenv_savep_var
	if [ "$pushenv_save_set" = "set" ]; then
	    eval export $pushenv_var=\"\$pushenv_save_val\"
	else
	    unset $pushenv_var
	fi
    done
    unset pushenv_vars_${pushenv_level}
    if [ "$pushenv_level" = "0" ]; then
	error "Popping environment level 0"
    else
	pushenv_level=$(($pushenv_level - 1))
    fi
}

prepend_path() {
    if $(eval "test -n \"\$$1\""); then
	prependenvvar "$1" "$2:"
    else
	prependenvvar "$1" "$2"
    fi
}
pushenvvar CSL_SCRIPTDIR /scratch/julian/2010q1-release-eabi-lite/src/scripts-trunk
pushenvvar PATH /usr/local/tools/gcc-4.3.3/bin
pushenvvar LD_LIBRARY_PATH /usr/local/tools/gcc-4.3.3/i686-pc-linux-gnu/lib:/usr/local/tools/gcc-4.3.3/lib64:/usr/local/tools/gcc-4.3.3/lib
pushenvvar MAKEINFO 'makeinfo --css-ref=../cs.css'
clean_environment
# task [001/174] /init/dirs
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install
mkdir -p /scratch/julian/2010q1-release-eabi-lite/pkg
mkdir -p /scratch/julian/2010q1-release-eabi-lite/logs/data
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf
popenv

# task [002/174] /init/cleanup
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi.src.tar.bz2 /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi.backup.tar.bz2
popenv

# task [003/174] /init/source_package/binutils
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/binutils-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/binutils-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' binutils-2010q1
popd
popenv

# task [004/174] /init/source_package/gcc
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/gcc-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/gcc-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' gcc-4.4-2010q1
popd
popenv

# task [005/174] /init/source_package/gdb
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/gdb-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/gdb-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' gdb-2010q1
popd
popenv

# task [006/174] /init/source_package/zlib
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/zlib-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/zlib-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' zlib-1.2.3
popd
popenv

# task [007/174] /init/source_package/gmp
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/gmp-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/gmp-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' gmp-2010q1
popd
popenv

# task [008/174] /init/source_package/mpfr
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/mpfr-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/mpfr-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' mpfr-2010q1
popd
popenv

# task [009/174] /init/source_package/cloog
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/cloog-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/cloog-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' cloog-0.15
popd
popenv

# task [010/174] /init/source_package/ppl
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/ppl-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/ppl-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' ppl-0.10.2
popd
popenv

# task [011/174] /init/source_package/getting_started
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/getting_started-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/getting_started-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' getting-started-2010q1
popd
popenv

# task [012/174] /init/source_package/installanywhere
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/installanywhere-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/installanywhere-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' installanywhere-2010q1
popd
popenv

# task [013/174] /init/source_package/ph
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/ph-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/ph-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' ph-2010q1
popd
popenv

# task [014/174] /init/source_package/board_support
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/board_support-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/board_support-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' board-support-trunk
popd
popenv

# task [015/174] /init/source_package/arm_stub
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/arm_stub-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/arm_stub-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' arm_stub-2010q1
popd
popenv

# task [016/174] /init/source_package/newlib
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/newlib-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/newlib-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' newlib-2010q1
popd
popenv

# task [017/174] /init/source_package/cs3
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/cs3-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/cs3-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' cs3-2010q1
popd
popenv

# task [018/174] /init/source_package/csl_tests
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/csl_tests-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/csl_tests-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' csl-tests-trunk
popd
popenv

# task [019/174] /init/source_package/dejagnu_boards
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/dejagnu_boards-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/dejagnu_boards-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' dejagnu-boards-trunk
popd
popenv

# task [020/174] /init/source_package/scripts
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/scripts-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/scripts-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' scripts-trunk
popd
popenv

# task [021/174] /init/source_package/xfails
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/xfails-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/xfails-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' xfails-trunk
popd
popenv

# task [022/174] /init/source_package/portal
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/portal-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/portal-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' portal-trunk
popd
popenv

# task [023/174] /init/source_package/libiconv
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/libiconv-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/libiconv-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' libiconv-1.11
popd
popenv

# task [024/174] /init/source_package/expat
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/expat-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/expat-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' expat-mirror
popd
popenv

# task [025/174] /init/source_package/csl_docbook
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/csl_docbook-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/csl_docbook-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' csl-docbook-trunk
popd
popenv

# task [026/174] /init/source_package/make
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/make-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/make-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' make-3.81
popd
popenv

# task [027/174] /init/source_package/coreutils
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/coreutils-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi/coreutils-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' coreutils-5.94
popd
popenv

# task [028/174] /init/source_package/qmtest_ph
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/qmtest_ph-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/qmtest_ph-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' qmtest_ph-2010q1
popd
popenv

# task [029/174] /init/source_package/gdil
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
rm -f /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/gdil-2010q1-188.tar.bz2
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/src
tar cf /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup/gdil-2010q1-188.tar.bz2 --bzip2 --owner=0 --group=0 --exclude=CVS --exclude=.svn --exclude=.git --exclude=.pc '--exclude=*~' '--exclude=.#*' '--exclude=*.orig' '--exclude=*.rej' gdil-2010q1
popd
popenv

# task [030/174] /i686-pc-linux-gnu/host_cleanup
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
popenv

# task [031/174] /i686-pc-linux-gnu/zlib_first/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/zlib-1.2.3 /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
popenv

# task [032/174] /i686-pc-linux-gnu/zlib_first/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushenv
pushenvvar CC 'i686-pc-linux-gnu-gcc '
pushenvvar AR 'i686-pc-linux-gnu-ar rc'
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
./configure --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr
popenv
popd
popenv

# task [033/174] /i686-pc-linux-gnu/zlib_first/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv

# task [034/174] /i686-pc-linux-gnu/zlib_first/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv

# task [035/174] /i686-pc-linux-gnu/gmp/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/gmp-2010q1/configure --build=i686-pc-linux-gnu --target=i686-pc-linux-gnu --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-shared --host=i686-pc-linux-gnu --enable-cxx --disable-nls
popd
popenv
popenv
popenv

# task [036/174] /i686-pc-linux-gnu/gmp/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [037/174] /i686-pc-linux-gnu/gmp/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv
popenv
popenv

# task [038/174] /i686-pc-linux-gnu/gmp/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make check
popd
popenv
popenv
popenv

# task [039/174] /i686-pc-linux-gnu/mpfr/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/mpfr-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-shared --host=i686-pc-linux-gnu --disable-nls --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr
popd
popenv
popenv
popenv

# task [040/174] /i686-pc-linux-gnu/mpfr/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [041/174] /i686-pc-linux-gnu/mpfr/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv
popenv
popenv

# task [042/174] /i686-pc-linux-gnu/mpfr/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make check
popd
popenv
popenv
popenv

# task [043/174] /i686-pc-linux-gnu/ppl/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/ppl-0.10.2/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-shared --host=i686-pc-linux-gnu --disable-nls --with-libgmp-prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr
popd
popenv
popenv
popenv

# task [044/174] /i686-pc-linux-gnu/ppl/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [045/174] /i686-pc-linux-gnu/ppl/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv
popenv
popenv

# task [046/174] /i686-pc-linux-gnu/cloog/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/cloog-0.15/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-shared --host=i686-pc-linux-gnu --disable-nls --with-ppl=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr
popd
popenv
popenv
popenv

# task [047/174] /i686-pc-linux-gnu/cloog/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [048/174] /i686-pc-linux-gnu/cloog/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv
popenv
popenv

# task [049/174] /i686-pc-linux-gnu/cloog/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make check
popd
popenv
popenv
popenv

# task [050/174] /i686-pc-linux-gnu/toolchain/binutils/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/binutils-2010q1 /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
touch /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/.gnu-stamp
popenv
popenv
popenv

# task [051/174] /i686-pc-linux-gnu/toolchain/binutils/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-pc-linux-gnu '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --with-sysroot=/opt/codesourcery/arm-none-eabi --enable-poison-system-directories
popd
popenv
popenv
popenv

# task [052/174] /i686-pc-linux-gnu/toolchain/binutils/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [053/174] /i686-pc-linux-gnu/toolchain/binutils/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/share
popd
popenv
popenv
popenv

# task [054/174] /i686-pc-linux-gnu/toolchain/binutils/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/install
rm ./lib/libiberty.a
rmdir ./lib
popd
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/binutils-2010q1/include /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/libiberty/libiberty.a /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/bfd/.libs/libbfd.a /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/bfd/bfd.h /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
cp /scratch/julian/2010q1-release-eabi-lite/src/binutils-2010q1/bfd/elf-bfd.h /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/opcodes/.libs/libopcodes.a /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/configure.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/etc/configure.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/configure.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly configure
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/standards.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/etc/standards.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/standards.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly standards
rmdir /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/etc
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/bfd.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/bfd.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/bfd.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly bfd
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv
popenv

# task [055/174] /i686-pc-linux-gnu/toolchain/gcc_first/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gcc-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gcc-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/gcc-4.4-2010q1/configure --build=i686-pc-linux-gnu --host=i686-pc-linux-gnu --target=arm-none-eabi --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --enable-extra-sgxxlite-multilibs --with-gnu-as --with-gnu-ld '--with-specs=%{O2:%{!fno-remove-local-statics: -fremove-local-statics}} %{O*:%{O|O0|O1|O2|Os:;:%{!fno-remove-local-statics: -fremove-local-statics}}}' --enable-languages=c,c++ --disable-shared --disable-lto --with-newlib '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --prefix=/opt/codesourcery --disable-shared --disable-threads --disable-libssp --disable-libgomp --without-headers --with-newlib --disable-decimal-float --disable-libffi --enable-languages=c --with-sysroot=/opt/codesourcery/arm-none-eabi --with-build-sysroot=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-mpfr=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-ppl=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr '--with-host-libstdcxx=-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --with-cloog=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-libgomp --enable-poison-system-directories --with-build-time-tools=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin --with-build-time-tools=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin
popd
popenv
popenv

# task [056/174] /i686-pc-linux-gnu/toolchain/gcc_first/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4 LDFLAGS_FOR_TARGET=--sysroot=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi CPPFLAGS_FOR_TARGET=--sysroot=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi build_tooldir=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi
popd
popenv
popenv

# task [057/174] /i686-pc-linux-gnu/toolchain/gcc_first/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-first-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man install
popd
popenv
popenv

# task [058/174] /i686-pc-linux-gnu/toolchain/gcc_first/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushd /scratch/julian/2010q1-release-eabi-lite/install
rm bin/arm-none-eabi-gccbug
rm ./lib/libiberty.a
rmdir include
popd
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/gccinstall /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gcc/gccinstall.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/gccinstall.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly gccinstall
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/gccint /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gcc/gccint.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/gccint.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly gccint
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/cppinternals /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gcc/cppinternals.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/cppinternals.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly cppinternals
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv

# task [059/174] /i686-pc-linux-gnu/toolchain/newlib/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS_FOR_TARGET '-g -O2 -fno-unroll-loops'
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/newlib-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-pc-linux-gnu --enable-newlib-io-long-long --disable-newlib-supplied-syscalls --disable-libgloss --disable-newlib-supplied-syscalls --disable-nls
popd
popenv
popenv
popenv

# task [060/174] /i686-pc-linux-gnu/toolchain/newlib/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS_FOR_TARGET '-g -O2 -fno-unroll-loops'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [061/174] /i686-pc-linux-gnu/toolchain/newlib/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS_FOR_TARGET '-g -O2 -fno-unroll-loops'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/share
popd
popenv
popenv
popenv

# task [062/174] /i686-pc-linux-gnu/toolchain/newlib/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CFLAGS_FOR_TARGET '-g -O2 -fno-unroll-loops'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make pdf
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf
cp /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/arm-none-eabi/newlib/libc/libc.pdf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/libc.pdf
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf
cp /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/arm-none-eabi/newlib/libm/libm.pdf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/libm.pdf
make html
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/arm-none-eabi/newlib/libc/libc.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/libc
mkdir -p /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/newlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/arm-none-eabi/newlib/libm/libm.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/libm
popd
popenv
popenv
popenv

# task [063/174] /i686-pc-linux-gnu/toolchain/gcc_final/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
rm -f /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
ln -s . /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/gcc-4.4-2010q1/configure --build=i686-pc-linux-gnu --host=i686-pc-linux-gnu --target=arm-none-eabi --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --enable-extra-sgxxlite-multilibs --with-gnu-as --with-gnu-ld '--with-specs=%{O2:%{!fno-remove-local-statics: -fremove-local-statics}} %{O*:%{O|O0|O1|O2|Os:;:%{!fno-remove-local-statics: -fremove-local-statics}}}' --enable-languages=c,c++ --disable-shared --disable-lto --with-newlib '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --prefix=/opt/codesourcery --with-headers=yes --with-sysroot=/opt/codesourcery/arm-none-eabi --with-build-sysroot=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-mpfr=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-ppl=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr '--with-host-libstdcxx=-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --with-cloog=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-libgomp --enable-poison-system-directories --with-build-time-tools=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin --with-build-time-tools=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin
popd
popenv
popenv

# task [064/174] /i686-pc-linux-gnu/toolchain/gcc_final/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
rm -f /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
ln -s . /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4 LDFLAGS_FOR_TARGET=--sysroot=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi CPPFLAGS_FOR_TARGET=--sysroot=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi build_tooldir=/scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi
popd
popenv
popenv

# task [065/174] /i686-pc-linux-gnu/toolchain/gcc_final/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
rm -f /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
ln -s . /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man install
popd
popenv
popenv

# task [066/174] /i686-pc-linux-gnu/toolchain/gcc_final/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushd /scratch/julian/2010q1-release-eabi-lite/install
rm bin/arm-none-eabi-gccbug
rm ./lib/libiberty.a
rm ./arm-none-eabi/lib/libiberty.a
rm ./arm-none-eabi/lib/thumb2/libiberty.a
rm ./arm-none-eabi/lib/thumb/libiberty.a
rm ./arm-none-eabi/lib/armv6-m/libiberty.a
rmdir include
popd
rm -f /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/usr
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/gccinstall /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gcc/gccinstall.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/gccinstall.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly gccinstall
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/gccint /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gcc/gccint.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/gccint.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly gccint
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/cppinternals /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gcc/cppinternals.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/cppinternals.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly cppinternals
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv

# task [067/174] /i686-pc-linux-gnu/toolchain/zlib/0/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/zlib-1.2.3 /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
popenv

# task [068/174] /i686-pc-linux-gnu/toolchain/zlib/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushenv
pushenvvar CC 'i686-pc-linux-gnu-gcc '
pushenvvar AR 'i686-pc-linux-gnu-ar rc'
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
./configure --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr
popenv
popd
popenv

# task [069/174] /i686-pc-linux-gnu/toolchain/zlib/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv

# task [070/174] /i686-pc-linux-gnu/toolchain/zlib/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv

# task [071/174] /i686-pc-linux-gnu/toolchain/expat/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/expat-mirror/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-shared --host=i686-pc-linux-gnu --disable-nls
popd
popenv
popenv
popenv

# task [072/174] /i686-pc-linux-gnu/toolchain/expat/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [073/174] /i686-pc-linux-gnu/toolchain/expat/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv
popenv
popenv

# task [074/174] /i686-pc-linux-gnu/toolchain/gdb/0/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/gdb-2010q1 /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
touch /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/.gnu-stamp
popenv
popenv
popenv

# task [075/174] /i686-pc-linux-gnu/toolchain/gdb/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-pc-linux-gnu '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --with-libexpat-prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-system-gdbinit=/opt/codesourcery/i686-pc-linux-gnu/arm-none-eabi/lib/gdbinit '--with-gdb-datadir='\''${prefix}'\''/arm-none-eabi/share/gdb'
popd
popenv
popenv
popenv

# task [076/174] /i686-pc-linux-gnu/toolchain/gdb/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [077/174] /i686-pc-linux-gnu/toolchain/gdb/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/share
popd
popenv
popenv
popenv

# task [078/174] /i686-pc-linux-gnu/toolchain/gdb/0/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/annotate /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/annotate.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/annotate.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly annotate
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/gdbint /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/gdbint.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/gdbint.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly gdbint
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/stabs /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/stabs.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/stabs.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly stabs
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/configure.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/etc/configure.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/configure.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly configure
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/standards.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/etc/standards.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/standards.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly standards
rmdir /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/etc
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/bfd.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/bfd.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info/bfd.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info --remove-exactly bfd
rm -f /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv
popenv

# task [079/174] /i686-pc-linux-gnu/toolchain/cs3/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar CC arm-none-eabi-gcc
pushenvvar CXX arm-none-eabi-g++
pushenvvar AR arm-none-eabi-ar
pushenvvar RANLIB arm-none-eabi-ranlib
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/cs3-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=arm-none-eabi '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --with-intermediate-dir=/scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi '--with-configs=public-*' --with-multilib_default=@marm@march=armv4t
popd
popenv
popenv
popenv

# task [080/174] /i686-pc-linux-gnu/toolchain/cs3/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar CC arm-none-eabi-gcc
pushenvvar CXX arm-none-eabi-g++
pushenvvar AR arm-none-eabi-ar
pushenvvar RANLIB arm-none-eabi-ranlib
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [081/174] /i686-pc-linux-gnu/toolchain/cs3/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenvvar CC arm-none-eabi-gcc
pushenvvar CXX arm-none-eabi-g++
pushenvvar AR arm-none-eabi-ar
pushenvvar RANLIB arm-none-eabi-ranlib
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/share
popd
popenv
popenv
popenv

# task [082/174] /i686-pc-linux-gnu/getting_started/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/getting-started-2010q1 /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
touch /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/.gnu-stamp
cat > /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/4.4-arm-none-eabi-lite-libs.xml <<'EOF0'
<!DOCTYPE getting-started SYSTEM "getting-started.dtd">
<!-- automatically generated, do not edit -->
<section id="sec-multilibs">
  <title>Library Configurations</title>
  <xi:include href="library-intro.xml" xpointer="xpointer(*/*)"/>
  <section>
    <title>Included Libraries</title>
    <para>
      The following library configurations are available in
      &csl_prod; for &csl_target_name;.
    </para>
  <informaltable>
    <?dbfo keep-together="always" ?>
    <?dbfo table-width="100%" ?>
    <?dbhtml table-width="100%" ?>
    <tgroup cols="2" align="left">
      <colspec colname="c1" colwidth="1*" />
      <colspec colname="c2" colwidth="2*" />
      <thead>
	<row>
	  <entry namest="c1" nameend="c2">ARMv4 - Little-Endian, Soft-Float</entry>
	</row>
      </thead>
      <tbody>
	<row>
	  <entry>Command-line option(s):</entry>
	  <entry>default</entry>
	</row>
	<row>
	  <entry>Library subdirectory:</entry>
	  <entry><filename>./</filename></entry>
	</row>
      </tbody>
    </tgroup>
  </informaltable>
  <informaltable>
    <?dbfo keep-together="always" ?>
    <?dbfo table-width="100%" ?>
    <?dbhtml table-width="100%" ?>
    <tgroup cols="2" align="left">
      <colspec colname="c1" colwidth="1*" />
      <colspec colname="c2" colwidth="2*" />
      <thead>
	<row>
	  <entry namest="c1" nameend="c2">ARMv4 Thumb - Little-Endian, Soft-Float</entry>
	</row>
      </thead>
      <tbody>
	<row>
	  <entry>Command-line option(s):</entry>
	  <entry><option>-mthumb</option></entry>
	</row>
	<row>
	  <entry>Library subdirectory:</entry>
	  <entry><filename>thumb/</filename></entry>
	</row>
      </tbody>
    </tgroup>
  </informaltable>
  <informaltable>
    <?dbfo keep-together="always" ?>
    <?dbfo table-width="100%" ?>
    <?dbhtml table-width="100%" ?>
    <tgroup cols="2" align="left">
      <colspec colname="c1" colwidth="1*" />
      <colspec colname="c2" colwidth="2*" />
      <thead>
	<row>
	  <entry namest="c1" nameend="c2">ARMv7 Thumb-2 - Little-Endian, Soft-Float</entry>
	</row>
      </thead>
      <tbody>
	<row>
	  <entry>Command-line option(s):</entry>
	  <entry><option>-mthumb -march=armv7 -mfix-cortex-m3-ldrd</option></entry>
	</row>
	<row>
	  <entry>Library subdirectory:</entry>
	  <entry><filename>thumb2/</filename></entry>
	</row>
      </tbody>
    </tgroup>
  </informaltable>
  <informaltable>
    <?dbfo keep-together="always" ?>
    <?dbfo table-width="100%" ?>
    <?dbhtml table-width="100%" ?>
    <tgroup cols="2" align="left">
      <colspec colname="c1" colwidth="1*" />
      <colspec colname="c2" colwidth="2*" />
      <thead>
	<row>
	  <entry namest="c1" nameend="c2">ARMv6-M Thumb - Little-Endian, Soft-Float</entry>
	</row>
      </thead>
      <tbody>
	<row>
	  <entry>Command-line option(s):</entry>
	  <entry><option>-mthumb -march=armv6-m</option></entry>
	</row>
	<row>
	  <entry>Library subdirectory:</entry>
	  <entry><filename>armv6-m/</filename></entry>
	</row>
      </tbody>
    </tgroup>
  </informaltable>
    </section>
  <xi:include href="library-selection.xml"/>
</section>
EOF0
cat > /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/4.4-arm-none-eabi-lite.dtd <<'EOF0'
<!-- automatically generated, do not edit -->
<!ENTITY csl_multilib_sec "<xi:include href='/scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/4.4-arm-none-eabi-lite-libs.xml'/>">
<!ENTITY csl_subpackage_sec "">
<!ENTITY csl_binutils_component_license "&csl_gpl3.0_license;">
<!ENTITY csl_binutils_component_version "2.19.51">
<!ENTITY csl_gcc_component_license "&csl_gpl3.0_license;">
<!ENTITY csl_gcc_component_version "4.4.1">
<!ENTITY csl_gdb_component_license "&csl_gpl3.0_license;">
<!ENTITY csl_gdb_component_version "7.0.50">
<!ENTITY csl_arm_stub_component_license "&csl_cs_license;">
<!ENTITY csl_newlib_component_license "&csl_newlib_license;">
<!ENTITY csl_newlib_component_version "1.17.0">
<!ENTITY csl_cs3_component_license "&csl_cs_license;">
<!ENTITY csl_make_component_license "&csl_gpl2.0_license;">
<!ENTITY csl_coreutils_component_license "&csl_gpl2.0_license;">
EOF0
popenv
popenv
popenv

# task [083/174] /i686-pc-linux-gnu/getting_started/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/obj/getting_started-src-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-pc-linux-gnu --disable-nls --with-release-config=4.4-arm-none-eabi-lite '--with-components=binutils gcc gdb zlib gmp mpfr cloog ppl getting_started installanywhere ph board_support arm_stub newlib cs3 branding contents comparison csl_tests dejagnu_boards scripts xfails portal harness libiconv expat csl_docbook make coreutils qmtest_ph gdil no-mingw no-w32api no-alf no-argp no-atlas_install no-ccs no-cctools no-cfpe_stub no-cml no-com_codesourcery_util no-compiler_wrapper no-coremark no-csldoc no-cxxabi no-cygwin_wrapper no-dhrystone no-dinkum no-dtc no-eclipse no-eclipse_cdt no-eclipse_plugin no-eembc no-eglibc no-eglibc_configs no-elf2flt no-elfutils no-fbench no-flexlm_utils no-glibc no-glibc_linuxthreads no-glibc_localedef no-glibc_ports no-harness_test no-ide no-intel_sprite no-libcsftdi no-libelf no-libfdt no-libftdi no-libkcompat no-libosip2 no-libpng no-libsdl no-libsdl_macosx no-libunwind no-liburcu no-libusb no-libusb_win32 no-license no-linux no-mips_sprite no-mips_toolchain_manual no-mklibs no-mpatrol no-mpc no-mqx no-mqx_support no-msvcrt no-ncurses no-ocdremote no-omf2elf no-openposix no-osprey no-ph_old no-plex_skel no-prelink no-python no-python_macosx no-python_win32 no-qemu no-redboot no-rpm no-sde no-sdemdi no-sgxx_application_notes no-sgxx_demos no-simdmath no-sip_parser_benchmark no-spec2000 no-spec2000_configs no-srpm no-stellarisware no-stm32_generate_sgxx no-stm32_stdperiph_lib no-stm32_usb_fs_device_lib no-svp_docs no-sysroot_utils no-trace_processor no-uclibc no-uclibc_configs no-ust no-vpp_binary no-vpp_documentation no-vpp_fftw no-vpp_source no-windows_script_wrapper' '--with-features=armfloat portable_objects gdbsimulator tarball public elf sprite rdi flashpro altera newlib_newlib cs3' '--with-hosts=i686-pc-linux-gnu i686-mingw32' '--with-host_os-name=IA32 GNU/Linux' --with-target-arch-name=ARM --with-target-os-name=EABI --with-intermediate-dir=/scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi --with-csl-docbook=/scratch/julian/2010q1-release-eabi-lite/src/csl-docbook-trunk --with-version-string=2010q1-188 '--with-pkgversion=Sourcery G++ Lite 2010q1-188' '--with-brand=Sourcery G++ Lite' '--with-xml-catalog-files=/usr/local/tools/gcc-4.3.3/share/sgml/docbook/docbook-xsl/catalog.xml /etc/xml/catalog' --with-license=lite --with-cs3=/scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi/doc
popd
popenv
popenv
popenv

# task [084/174] /i686-pc-linux-gnu/getting_started/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [085/174] /i686-pc-linux-gnu/getting_started/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/share docdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi
popd
popenv
popenv
popenv

# task [086/174] /i686-pc-linux-gnu/csl_docbook
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
cp /scratch/julian/2010q1-release-eabi-lite/src/csl-docbook-trunk/css/cs.css /scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html
popenv

# task [087/174] /i686-pc-linux-gnu/gdil/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/gdil-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --disable-shared --host=i686-pc-linux-gnu --with-csl-docbook=/scratch/julian/2010q1-release-eabi-lite/src/csl-docbook-trunk '--with-xml-catalog-files=/usr/local/tools/gcc-4.3.3/share/sgml/docbook/docbook-xsl/catalog.xml /etc/xml/catalog' --disable-nls --with-expat=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr '--with-features=xml autoconf sprite doc'
popd
popenv
popenv
popenv

# task [088/174] /i686-pc-linux-gnu/gdil/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [089/174] /i686-pc-linux-gnu/gdil/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install
popd
popenv
popenv
popenv

# task [090/174] /i686-pc-linux-gnu/arm_stub/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
pushd /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
/scratch/julian/2010q1-release-eabi-lite/src/arm_stub-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-pc-linux-gnu '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ '--enable-backends=rdi flashpro altera' --enable-boards=all --disable-nls --with-gdil=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-expat=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-pc-linux-gnu/usr --with-boards=/scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi/boards
popd
popenv
popenv
popenv

# task [091/174] /i686-pc-linux-gnu/arm_stub/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make -j4
popd
popenv
popenv
popenv

# task [092/174] /i686-pc-linux-gnu/arm_stub/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-pc-linux-gnu
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install libdir=/scratch/julian/2010q1-release-eabi-lite/install/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/share
popd
popenv
popenv
popenv

# task [093/174] /i686-pc-linux-gnu/finalize_libc_installation
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
popenv

# task [094/174] /i686-pc-linux-gnu/pretidy_installation
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/install
rm ./lib/libiberty.a
popd
popenv

# task [095/174] /i686-pc-linux-gnu/remove_libtool_archives
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
find /scratch/julian/2010q1-release-eabi-lite/install -name '*.la' -exec rm '{}' ';'
popenv

# task [096/174] /i686-pc-linux-gnu/remove_copied_libs
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
popenv

# task [097/174] /i686-pc-linux-gnu/remove_fixed_headers
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
pushd /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/include-fixed
popd
popenv

# task [098/174] /i686-pc-linux-gnu/add_tooldir_readme
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
cat > /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/README.txt <<'EOF0'
The executables in this directory are for internal use by the compiler
and may not operate correctly when used directly.  This directory
should not be placed on your PATH.  Instead, you should use the
executables in ../../bin/ and place that directory on your PATH.
EOF0
popenv

# task [099/174] /i686-pc-linux-gnu/strip_host_objects
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-addr2line
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-ar
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-as
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-c++
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-c++filt
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-cpp
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-g++
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-gcc
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-gcc-4.4.1
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-gcov
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-gdb
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-gdbtui
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-gprof
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-ld
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-nm
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-objcopy
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-objdump
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-ranlib
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-readelf
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-run
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-size
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-sprite
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-strings
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/bin/arm-none-eabi-strip
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/ar
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/as
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/c++
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/g++
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/gcc
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/ld
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/nm
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/objcopy
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/objdump
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/ranlib
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/bin/strip
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/libexec/gcc/arm-none-eabi/4.4.1/cc1
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/libexec/gcc/arm-none-eabi/4.4.1/collect2
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/libexec/gcc/arm-none-eabi/4.4.1/install-tools/fixincl
/usr/local/tools/gcc-4.3.3/bin/i686-pc-linux-gnu-strip /scratch/julian/2010q1-release-eabi-lite/install/libexec/gcc/arm-none-eabi/4.4.1/cc1plus
popenv

# task [100/174] /i686-pc-linux-gnu/strip_target_objects
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libcs3hosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libg.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libcs3hosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libg.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libcs3micro.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libsupc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libcs3.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libcs3unhosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libcs3arm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb2/libstdc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libsupc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libcs3.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libcs3hosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libg.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libsupc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libcs3.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libcs3unhosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libcs3arm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/thumb/libstdc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libcs3unhosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libcs3arm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libcs3hosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libg.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libcs3micro.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libsupc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libcs3.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libcs3unhosted.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libcs3arm.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/armv6-m/libstdc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/arm-none-eabi/lib/libstdc++.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/crtend.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/crtn.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb2/crtend.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb2/crtn.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb2/libgcc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb2/crti.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb2/crtbegin.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb2/libgcov.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/libgcc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/crti.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb/crtend.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb/crtn.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb/libgcc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb/crti.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb/crtbegin.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/thumb/libgcov.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/crtbegin.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/armv6-m/crtend.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/armv6-m/crtn.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/armv6-m/libgcc.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/armv6-m/crti.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/armv6-m/crtbegin.o || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/armv6-m/libgcov.a || true
arm-none-eabi-objcopy -R .comment -R .note -R .debug_info -R .debug_aranges -R .debug_pubnames -R .debug_abbrev -R .debug_line -R .debug_str -R .debug_ranges -R .debug_loc /scratch/julian/2010q1-release-eabi-lite/install/lib/gcc/arm-none-eabi/4.4.1/libgcov.a || true
popenv

# task [101/174] /i686-pc-linux-gnu/package_tbz2
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
rm -f /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi-i686-pc-linux-gnu.tar.bz2
pushd /scratch/julian/2010q1-release-eabi-lite/obj
rm -f arm-2010q1
ln -s /scratch/julian/2010q1-release-eabi-lite/install arm-2010q1
tar cjf /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi-i686-pc-linux-gnu.tar.bz2 --owner=0 --group=0 --exclude=host-i686-pc-linux-gnu --exclude=host-i686-mingw32 arm-2010q1/arm-none-eabi arm-2010q1/bin arm-2010q1/lib arm-2010q1/libexec arm-2010q1/share
rm -f arm-2010q1
popd
popenv

# task [102/174] /i686-pc-linux-gnu/package_installanywhere
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-pc-linux-gnu-gcc
pushenvvar CXX i686-pc-linux-gnu-g++
pushenvvar AR i686-pc-linux-gnu-ar
pushenvvar RANLIB i686-pc-linux-gnu-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/install/bin
/scratch/julian/2010q1-release-eabi-lite/src/scripts-trunk/gnu-installanywhere -i /scratch/julian/2010q1-release-eabi-lite/install -l /scratch/julian/2010q1-release-eabi-lite/logs -o /scratch/julian/2010q1-release-eabi-lite/obj -p /scratch/julian/2010q1-release-eabi-lite/pkg -s /scratch/julian/2010q1-release-eabi-lite/src -T /scratch/julian/2010q1-release-eabi-lite/testlogs -h i686-pc-linux-gnu -f /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi/license.html sgxx/2010q1/arm-none-eabi-lite.cfg
popenv

# task [103/174] /i686-mingw32/host_cleanup
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
popenv

# task [104/174] /i686-mingw32/host_unpack
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32
mkdir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32
ln -s . arm-2010q1
tar xf /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi-i686-pc-linux-gnu.tar.bz2 --bzip2
rm arm-2010q1
popd
popenv

# task [105/174] /i686-mingw32/libiconv/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/libiconv-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/libiconv-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/libiconv-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/libiconv-1.11/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --disable-nls
popd
popenv
popenv
popenv

# task [106/174] /i686-mingw32/libiconv/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/libiconv-2010q1-188-arm-none-eabi-i686-mingw32
make -j1
popd
popenv
popenv
popenv

# task [107/174] /i686-mingw32/libiconv/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/libiconv-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [108/174] /i686-mingw32/make/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/make-src-2010q1-188-arm-none-eabi-i686-mingw32
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/make-3.81 /scratch/julian/2010q1-release-eabi-lite/obj/make-src-2010q1-188-arm-none-eabi-i686-mingw32
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/make-src-2010q1-188-arm-none-eabi-i686-mingw32
touch /scratch/julian/2010q1-release-eabi-lite/obj/make-src-2010q1-188-arm-none-eabi-i686-mingw32/.gnu-stamp
popenv
popenv
popenv

# task [109/174] /i686-mingw32/make/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/make-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/make-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/make-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/obj/make-src-2010q1-188-arm-none-eabi-i686-mingw32/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-mingw32 '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --disable-nls --program-prefix=cs-
popd
popenv
popenv
popenv

# task [110/174] /i686-mingw32/make/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/make-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [111/174] /i686-mingw32/make/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/make-2010q1-188-arm-none-eabi-i686-mingw32
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 libdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share
popd
popenv
popenv
popenv

# task [112/174] /i686-mingw32/coreutils/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-src-2010q1-188-arm-none-eabi-i686-mingw32
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/coreutils-5.94 /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-src-2010q1-188-arm-none-eabi-i686-mingw32
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-src-2010q1-188-arm-none-eabi-i686-mingw32
touch /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-src-2010q1-188-arm-none-eabi-i686-mingw32/.gnu-stamp
popenv
popenv
popenv

# task [113/174] /i686-mingw32/coreutils/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/obj/coreutils-src-2010q1-188-arm-none-eabi-i686-mingw32/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-mingw32 '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --disable-nls --program-prefix=cs-
popd
popenv
popenv
popenv

# task [114/174] /i686-mingw32/coreutils/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [115/174] /i686-mingw32/coreutils/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/coreutils-2010q1-188-arm-none-eabi-i686-mingw32
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 libdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share
popd
popenv
popenv
popenv

# task [116/174] /i686-mingw32/zlib_first/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-mingw32
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/zlib-1.2.3 /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-mingw32
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-mingw32
popenv

# task [117/174] /i686-mingw32/zlib_first/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-mingw32
pushenv
pushenvvar CC 'i686-mingw32-gcc '
pushenvvar AR 'i686-mingw32-ar rc'
pushenvvar RANLIB i686-mingw32-ranlib
./configure --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr
popenv
popd
popenv

# task [118/174] /i686-mingw32/zlib_first/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv

# task [119/174] /i686-mingw32/zlib_first/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-first-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv

# task [120/174] /i686-mingw32/gmp/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/gmp-2010q1/configure --build=i686-pc-linux-gnu --target=i686-mingw32 --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --enable-cxx --disable-nls
popd
popenv
popenv
popenv

# task [121/174] /i686-mingw32/gmp/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [122/174] /i686-mingw32/gmp/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gmp-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [123/174] /i686-mingw32/gmp/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CFLAGS '-g -O2'
popenv
popenv
popenv

# task [124/174] /i686-mingw32/mpfr/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/mpfr-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --disable-nls --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr
popd
popenv
popenv
popenv

# task [125/174] /i686-mingw32/mpfr/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [126/174] /i686-mingw32/mpfr/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/mpfr-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [127/174] /i686-mingw32/mpfr/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
popenv
popenv
popenv

# task [128/174] /i686-mingw32/ppl/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/ppl-0.10.2/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --disable-nls --with-libgmp-prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr
popd
popenv
popenv
popenv

# task [129/174] /i686-mingw32/ppl/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [130/174] /i686-mingw32/ppl/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/ppl-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [131/174] /i686-mingw32/cloog/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/cloog-0.15/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --disable-nls --with-ppl=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr
popd
popenv
popenv
popenv

# task [132/174] /i686-mingw32/cloog/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [133/174] /i686-mingw32/cloog/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/cloog-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [134/174] /i686-mingw32/cloog/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
popenv
popenv
popenv

# task [135/174] /i686-mingw32/toolchain/binutils/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-mingw32
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/binutils-2010q1 /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-mingw32
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-mingw32
touch /scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-mingw32/.gnu-stamp
popenv
popenv
popenv

# task [136/174] /i686-mingw32/toolchain/binutils/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/obj/binutils-src-2010q1-188-arm-none-eabi-i686-mingw32/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-mingw32 '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --with-sysroot=/opt/codesourcery/arm-none-eabi --enable-poison-system-directories
popd
popenv
popenv
popenv

# task [137/174] /i686-mingw32/toolchain/binutils/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [138/174] /i686-mingw32/toolchain/binutils/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 libdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share
popd
popenv
popenv
popenv

# task [139/174] /i686-mingw32/toolchain/binutils/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32
rm lib/charset.alias
rm ./lib/libiberty.a
rmdir ./lib
popd
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/binutils-2010q1/include /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32/libiberty/libiberty.a /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32/bfd/.libs/libbfd.a /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32/bfd/bfd.h /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
cp /scratch/julian/2010q1-release-eabi-lite/src/binutils-2010q1/bfd/elf-bfd.h /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
cp /scratch/julian/2010q1-release-eabi-lite/obj/binutils-2010q1-188-arm-none-eabi-i686-mingw32/opcodes/.libs/libopcodes.a /scratch/julian/2010q1-release-eabi-lite/obj/host-binutils-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/configure.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/etc/configure.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/configure.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly configure
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/standards.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/etc/standards.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/standards.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly standards
rmdir /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/etc
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/bfd.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/bfd.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/bfd.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly bfd
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv
popenv

# task [140/174] /i686-mingw32/toolchain/copy_libs
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/share/doc/arm-arm-none-eabi/html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/share/doc/arm-arm-none-eabi/pdf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/share/doc/arm-arm-none-eabi/info /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/share/doc/arm-arm-none-eabi/man /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man
cp /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/share/doc/arm-arm-none-eabi/LICENSE.txt /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/lib /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/lib
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/include /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/include
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/include/c++ /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/include/c++
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/lib/gcc/arm-none-eabi /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib/gcc/arm-none-eabi
popenv

# task [141/174] /i686-mingw32/toolchain/gcc_final/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushenvvar CC_FOR_TARGET arm-none-eabi-gcc
pushenvvar GCC_FOR_TARGET arm-none-eabi-gcc
pushenvvar CXX_FOR_TARGET arm-none-eabi-g++
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
ln -s . /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/gcc-4.4-2010q1/configure --build=i686-pc-linux-gnu --host=i686-mingw32 --target=arm-none-eabi --enable-threads --disable-libmudflap --disable-libssp --disable-libstdcxx-pch --enable-extra-sgxxlite-multilibs --with-gnu-as --with-gnu-ld '--with-specs=%{O2:%{!fno-remove-local-statics: -fremove-local-statics}} %{O*:%{O|O0|O1|O2|Os:;:%{!fno-remove-local-statics: -fremove-local-statics}}}' --enable-languages=c,c++ --disable-shared --disable-lto --with-newlib '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --prefix=/opt/codesourcery --with-headers=yes --with-sysroot=/opt/codesourcery/arm-none-eabi --with-build-sysroot=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi --with-libiconv-prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-gmp=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-mpfr=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-ppl=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr '--with-host-libstdcxx=-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --with-cloog=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-libgomp --enable-poison-system-directories --with-build-time-tools=/scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/bin --with-build-time-tools=/scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/bin
popd
popenv
popenv

# task [142/174] /i686-mingw32/toolchain/gcc_final/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushenvvar CC_FOR_TARGET arm-none-eabi-gcc
pushenvvar GCC_FOR_TARGET arm-none-eabi-gcc
pushenvvar CXX_FOR_TARGET arm-none-eabi-g++
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
ln -s . /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-mingw32
make -j4 LDFLAGS_FOR_TARGET=--sysroot=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi CPPFLAGS_FOR_TARGET=--sysroot=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi build_tooldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi all-gcc
popd
popenv
popenv

# task [143/174] /i686-mingw32/toolchain/gcc_final/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushenvvar CC_FOR_TARGET arm-none-eabi-gcc
pushenvvar GCC_FOR_TARGET arm-none-eabi-gcc
pushenvvar CXX_FOR_TARGET arm-none-eabi-g++
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
ln -s . /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gcc-2010q1-188-arm-none-eabi-i686-mingw32
make prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 libdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man install-gcc
popd
popenv
popenv

# task [144/174] /i686-mingw32/toolchain/gcc_final/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenvvar AR_FOR_TARGET arm-none-eabi-ar
pushenvvar NM_FOR_TARGET arm-none-eabi-nm
pushenvvar OBJDUMP_FOR_TARET arm-none-eabi-objdump
pushenvvar STRIP_FOR_TARGET arm-none-eabi-strip
pushenvvar CC_FOR_TARGET arm-none-eabi-gcc
pushenvvar GCC_FOR_TARGET arm-none-eabi-gcc
pushenvvar CXX_FOR_TARGET arm-none-eabi-g++
pushd /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32
rm bin/arm-none-eabi-gccbug
rmdir include
popd
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/lib/gcc/arm-none-eabi /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib/gcc/arm-none-eabi
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/lib /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/lib
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/arm-none-eabi/include/c++ /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/include/c++
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/usr
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/gccinstall /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/gcc/gccinstall.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/gccinstall.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly gccinstall
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/gccint /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/gcc/gccint.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/gccint.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly gccint
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/cppinternals /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/gcc/cppinternals.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/cppinternals.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly cppinternals
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv

# task [145/174] /i686-mingw32/toolchain/zlib/0/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-mingw32
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/zlib-1.2.3 /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-mingw32
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-mingw32
popenv

# task [146/174] /i686-mingw32/toolchain/zlib/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-mingw32
pushenv
pushenvvar CC 'i686-mingw32-gcc '
pushenvvar AR 'i686-mingw32-ar rc'
pushenvvar RANLIB i686-mingw32-ranlib
./configure --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr
popenv
popd
popenv

# task [147/174] /i686-mingw32/toolchain/zlib/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv

# task [148/174] /i686-mingw32/toolchain/zlib/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/obj/zlib-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv

# task [149/174] /i686-mingw32/toolchain/expat/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/expat-mirror/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --disable-nls
popd
popenv
popenv
popenv

# task [150/174] /i686-mingw32/toolchain/expat/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [151/174] /i686-mingw32/toolchain/expat/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/expat-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [152/174] /i686-mingw32/toolchain/gdb/0/copy
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-mingw32
copy_dir_clean /scratch/julian/2010q1-release-eabi-lite/src/gdb-2010q1 /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-mingw32
chmod -R u+w /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-mingw32
touch /scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-mingw32/.gnu-stamp
popenv
popenv
popenv

# task [153/174] /i686-mingw32/toolchain/gdb/0/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/obj/gdb-src-2010q1-188-arm-none-eabi-i686-mingw32/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-mingw32 '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ --disable-nls --with-libexpat-prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-libiconv-prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-system-gdbinit=/opt/codesourcery/i686-mingw32/arm-none-eabi/lib/gdbinit '--with-gdb-datadir='\''${prefix}'\''/arm-none-eabi/share/gdb'
popd
popenv
popenv
popenv

# task [154/174] /i686-mingw32/toolchain/gdb/0/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [155/174] /i686-mingw32/toolchain/gdb/0/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdb-2010q1-188-arm-none-eabi-i686-mingw32
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 libdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share
popd
popenv
popenv
popenv

# task [156/174] /i686-mingw32/toolchain/gdb/0/postinstall
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushenvvar CPPFLAGS -I/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/include
pushenvvar LDFLAGS -L/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr/lib
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/annotate /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/annotate.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/annotate.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly annotate
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/gdbint /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/gdbint.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/gdbint.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly gdbint
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/stabs /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/stabs.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/stabs.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly stabs
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/configure.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/etc/configure.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/configure.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly configure
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/standards.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/etc/standards.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/standards.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly standards
rmdir /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/etc
rm -rf /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/bfd.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/bfd.pdf
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info/bfd.info
install-info --infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info --remove-exactly bfd
rm -f /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html/libiberty.html /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf/libiberty.pdf
popenv
popenv
popenv

# task [157/174] /i686-mingw32/gdil/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/gdil-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --disable-shared --host=i686-mingw32 --with-csl-docbook=/scratch/julian/2010q1-release-eabi-lite/src/csl-docbook-trunk '--with-xml-catalog-files=/usr/local/tools/gcc-4.3.3/share/sgml/docbook/docbook-xsl/catalog.xml /etc/xml/catalog' --disable-nls --with-expat=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr '--with-features=xml autoconf sprite doc'
popd
popenv
popenv
popenv

# task [158/174] /i686-mingw32/gdil/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [159/174] /i686-mingw32/gdil/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/gdil-2010q1-188-arm-none-eabi-i686-mingw32
make install
popd
popenv
popenv
popenv

# task [160/174] /i686-mingw32/arm_stub/configure
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
rm -rf /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-mingw32
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-mingw32
pushd /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-mingw32
/scratch/julian/2010q1-release-eabi-lite/src/arm_stub-2010q1/configure --build=i686-pc-linux-gnu --target=arm-none-eabi --prefix=/opt/codesourcery --host=i686-mingw32 '--with-pkgversion=Sourcery G++ Lite 2010q1-188' --with-bugurl=https://support.codesourcery.com/GNUToolchain/ '--enable-backends=rdi flashpro altera' --enable-boards=all --disable-nls --with-gdil=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-expat=/scratch/julian/2010q1-release-eabi-lite/obj/host-libs-2010q1-188-arm-none-eabi-i686-mingw32/usr --with-boards=/scratch/julian/2010q1-release-eabi-lite/obj/cs3-2010q1-188-arm-none-eabi/boards
popd
popenv
popenv
popenv

# task [161/174] /i686-mingw32/arm_stub/build
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-mingw32
make -j4
popd
popenv
popenv
popenv

# task [162/174] /i686-mingw32/arm_stub/install
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushenv
pushenv
pushd /scratch/julian/2010q1-release-eabi-lite/obj/arm_stub-2010q1-188-arm-none-eabi-i686-mingw32
make install prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 exec_prefix=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 libdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib htmldir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/html pdfdir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/pdf infodir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/info mandir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share/doc/arm-arm-none-eabi/man datadir=/scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/share
popd
popenv
popenv
popenv

# task [163/174] /i686-mingw32/pretidy_installation
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32
rm ./lib/libiberty.a
popd
popenv

# task [164/174] /i686-mingw32/remove_libtool_archives
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
find /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 -name '*.la' -exec rm '{}' ';'
popenv

# task [165/174] /i686-mingw32/remove_copied_libs
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
popenv

# task [166/174] /i686-mingw32/remove_fixed_headers
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
pushd /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/lib/gcc/arm-none-eabi/4.4.1/include-fixed
popd
popenv

# task [167/174] /i686-mingw32/add_tooldir_readme
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
cat > /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/README.txt <<'EOF0'
The executables in this directory are for internal use by the compiler
and may not operate correctly when used directly.  This directory
should not be placed on your PATH.  Instead, you should use the
executables in ../../bin/ and place that directory on your PATH.
EOF0
popenv

# task [168/174] /i686-mingw32/strip_host_objects
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-addr2line.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-ar.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-as.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-c++.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-c++filt.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-cpp.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-g++.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-gcc-4.4.1.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-gcc.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-gcov.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-gdb.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-gprof.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-ld.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-nm.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-objcopy.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-objdump.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-ranlib.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-readelf.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-run.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-size.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-sprite.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-strings.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/arm-none-eabi-strip.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/cs-make.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/bin/cs-rm.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/ar.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/as.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/c++.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/g++.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/gcc.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/ld.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/nm.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/objcopy.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/objdump.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/ranlib.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/arm-none-eabi/bin/strip.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/libexec/gcc/arm-none-eabi/4.4.1/cc1.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/libexec/gcc/arm-none-eabi/4.4.1/collect2.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/libexec/gcc/arm-none-eabi/4.4.1/install-tools/fixincl.exe
i686-mingw32-strip /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32/libexec/gcc/arm-none-eabi/4.4.1/cc1plus.exe
popenv

# task [169/174] /i686-mingw32/package_tbz2
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
rm -f /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi-i686-mingw32.tar.bz2
pushd /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32
popd
pushd /scratch/julian/2010q1-release-eabi-lite/obj
rm -f arm-2010q1
ln -s /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 arm-2010q1
tar cjf /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi-i686-mingw32.tar.bz2 --owner=0 --group=0 --exclude=host-i686-pc-linux-gnu --exclude=host-i686-mingw32 arm-2010q1/arm-none-eabi arm-2010q1/bin arm-2010q1/lib arm-2010q1/libexec arm-2010q1/share
rm -f arm-2010q1
popd
popenv

# task [170/174] /i686-mingw32/package_installanywhere
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
pushenvvar CC i686-mingw32-gcc
pushenvvar CXX i686-mingw32-g++
pushenvvar AR i686-mingw32-ar
pushenvvar RANLIB i686-mingw32-ranlib
prepend_path PATH /scratch/julian/2010q1-release-eabi-lite/obj/tools-i686-pc-linux-gnu-2010q1-188-arm-none-eabi-i686-mingw32/bin
/scratch/julian/2010q1-release-eabi-lite/src/scripts-trunk/gnu-installanywhere -i /scratch/julian/2010q1-release-eabi-lite/install/host-i686-mingw32 -l /scratch/julian/2010q1-release-eabi-lite/logs -o /scratch/julian/2010q1-release-eabi-lite/obj -p /scratch/julian/2010q1-release-eabi-lite/pkg -s /scratch/julian/2010q1-release-eabi-lite/src -T /scratch/julian/2010q1-release-eabi-lite/testlogs -h i686-mingw32 -f /scratch/julian/2010q1-release-eabi-lite/obj/getting_started-2010q1-188-arm-none-eabi/license.html sgxx/2010q1/arm-none-eabi-lite.cfg
popenv

# task [171/174] /fini/build_summary
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
cat > /scratch/julian/2010q1-release-eabi-lite/obj/gnu-2010q1-188-arm-none-eabi.txt <<'EOF0'
Version Information
===================

Version:           2010q1-188
Host spec(s):      i686-pc-linux-gnu i686-mingw32
Target:            arm-none-eabi

Build Information
=================

Build date:             20100417
Build machine:          henry2
Build operating system: lenny/sid
Build uname:            Linux henry2 2.6.24-26-server #1 SMP Tue Dec 1 18:26:43 UTC 2009 x86_64 GNU/Linux
Build user:             julian

EOF0
popenv

# task [172/174] /fini/extras_package
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.extras
pushd /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi
tar cjf /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi.extras.tar.bz2 --owner=0 --group=0 arm-2010q1-188-arm-none-eabi.extras
popd
popenv

# task [173/174] /fini/backups_package
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi.backup
pushd /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi
tar cjf /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi.backup.tar.bz2 --owner=0 --group=0 arm-2010q1-188-arm-none-eabi.backup
popd
popenv

# task [174/174] /fini/sources_package
pushenv
pushenvvar CC_FOR_BUILD i686-pc-linux-gnu-gcc
mkdir -p /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
cp /scratch/julian/2010q1-release-eabi-lite/obj/gnu-2010q1-188-arm-none-eabi.txt /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
cp /scratch/julian/2010q1-release-eabi-lite/logs/arm-2010q1-188-arm-none-eabi.sh /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi/arm-2010q1-188-arm-none-eabi
pushd /scratch/julian/2010q1-release-eabi-lite/obj/pkg-2010q1-188-arm-none-eabi
tar cjf /scratch/julian/2010q1-release-eabi-lite/pkg/arm-2010q1-188-arm-none-eabi.src.tar.bz2 --owner=0 --group=0 arm-2010q1-188-arm-none-eabi
popd
/scratch/julian/2010q1-release-eabi-lite/src/scripts-trunk/gnu-test -i /scratch/julian/2010q1-release-eabi-lite/install -l /scratch/julian/2010q1-release-eabi-lite/logs -o /scratch/julian/2010q1-release-eabi-lite/obj -p /scratch/julian/2010q1-release-eabi-lite/pkg -s /scratch/julian/2010q1-release-eabi-lite/src -T /scratch/julian/2010q1-release-eabi-lite/testlogs -T /scratch/julian/2010q1-release-eabi-lite/obj/testlogs-2010q1-188-arm-none-eabi sgxx/2010q1/arm-none-eabi-lite.cfg
copy_dir /scratch/julian/2010q1-release-eabi-lite/obj/testlogs-2010q1-188-arm-none-eabi /scratch/julian/2010q1-release-eabi-lite/testlogs
/scratch/julian/2010q1-release-eabi-lite/src/scripts-trunk/gnu-test-package -i /scratch/julian/2010q1-release-eabi-lite/install -l /scratch/julian/2010q1-release-eabi-lite/logs -o /scratch/julian/2010q1-release-eabi-lite/obj -p /scratch/julian/2010q1-release-eabi-lite/pkg -s /scratch/julian/2010q1-release-eabi-lite/src -T /scratch/julian/2010q1-release-eabi-lite/testlogs -T /scratch/julian/2010q1-release-eabi-lite/obj/testlogs-2010q1-188-arm-none-eabi sgxx/2010q1/arm-none-eabi-lite.cfg
