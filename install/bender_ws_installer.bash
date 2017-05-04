#!/bin/bash
#
# installation instructions
# --------------------------
#
# just run this script anywhere (anywhere but the same workspace path!)
#
# $ chmod +x maqui_framework_install.bash
# $ ./maqui_framework_install.bash
#

export WS_FOR_ROBOT=bender

cd $(dirname "$BASH_SOURCE")
bash "ws_installer.bash"