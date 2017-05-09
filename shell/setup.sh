#!/bin/sh

# update package list
rospack profile >/dev/null 2>/dev/null

# pkg lists
_pkgs_and_paths=$(rospack list | grep "$UCH_ROS_WS")
export UCH_PACKAGES_BASE="$(echo "$_pkgs_and_paths" | grep ".*base_ws.*" | sed 's/ [^.*]*//')"
export UCH_PACKAGES_SOFT="$(echo "$_pkgs_and_paths" | grep ".*soft_ws.*" | sed 's/ [^.*]*//')"
export UCH_PACKAGES_HIGH="$(echo "$_pkgs_and_paths" | grep ".*high_ws.*" | sed 's/ [^.*]*//')"
export UCH_PACKAGES="$(printf "%s\n%s\n%s" "$UCH_PACKAGES_BASE" "$UCH_PACKAGES_SOFT" "$UCH_PACKAGES_HIGH")"

# uch_* stacks lists
export UCH_STACKS="$(rosstack list | grep "$UCH_ROS_WS" | cut -d' ' -f1)"

##############################################################################################
#   bender system tools
##############################################################################################
# the source order is important!, at least functions.sh must be placed first.

# sh utilities named with "_uch_" preffix
. "$UCH_SYSTEM"/shell/functions.sh

# utilities useful when working on bash/sh
. "$UCH_SYSTEM"/shell/tools.sh

# utilities for doing git stuff on the whole workspace
. "$UCH_SYSTEM"/shell/gittools.sh


# autocomplete
if _uch_check_if_bash_or_zsh ; then

    # common autocompletion
    . "$UCH_SYSTEM"/shell/complete/common.sh

    # tools autocompletion
    . "$UCH_SYSTEM"/shell/complete/tools.sh
    . "$UCH_SYSTEM"/shell/complete/gittools.sh

fi



##############################################################################################
#   source setup.sh files
##############################################################################################

# source .sh files
if _uch_check_if_zsh ; then
    setopt shwordsplit
fi
for _pkg in $UCH_PACKAGES
do
    _pkg_path="$(echo "$_pkgs_and_paths" | grep "$_pkg " | sed 's/^.* //')"

    # deprecated
    _setup_file="$_pkg_path"/bash/setup.sh

    # source if neccesary.
    if [ -f "$_setup_file" ]; then
    	#echo " - [DEPRECATED] loading $_setup_file. Please rename the bash/ to shell/."
        . "$_setup_file"
    fi
    
    _setup_file="$_pkg_path"/shell/setup.sh
    if [ -f "$_setup_file" ]; then
        . "$_setup_file"
    fi
done
if _uch_check_if_zsh ; then
    unsetopt shwordsplit
fi
unset _pkgs_and_paths
unset _pkg
unset _pkg_path
unset _setup_file

