#!/bin/bash

# ENV
echo "[Environment Variable Info]"
echo '$0 : ' "$0"
echo '$# : ' "$#"
echo '$$ : ' "$$"
echo ""

# Arguments
echo "[Arguments]"
echo '$1 : ' "$1"
echo '$* : ' "$*"
echo '$@ : ' "$@"
echo ""

# Paramenter Extension
A=${AA:-dos}
B=${#1}
C=${1%l*}
D=${1%%l*}
E=${1#*l}
F=${1##*l}
echo "[Parameter Extension]"
echo '${AA:-dos}: ' "$A"
echo '${#1} 	: ' "$B"
echo '${1%l*} 	: ' "$C"
echo '${1%%l*} 	: ' "$D"
echo '${1#*l} 	: ' "$E"
echo '${1##*l} 	: ' "$F"
echo ""

# Operator
echo "[Operator]"
echo '$((1 + 3)): ' "$((1 + 3))"
echo ""
