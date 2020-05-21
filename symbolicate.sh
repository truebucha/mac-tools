#!/bin/bash

if [ "$#" -ne 2 ]; then
        echo "Argument missing [symbolicate @logLocation @xcarchiveLocation]"
        exit 0
fi

if test -e "$1"; then
    echo "$1 exists"
else
    echo "$1 does not exist!"
    exit 1
fi

if test -e "$2"; then
    echo "$2 exists"
else
    echo "$2 does not exist!"
    exit 1
fi

parentdir=`pwd`
export DEVELOPER_DIR=`xcode-select -p`
PATH=$PATH:$DEVELOPER_DIR
echo $PATH
cd $DEVELOPER_DIR
cd ../SharedFrameworks/
commanddir=`pwd`
command=$commanddir/`find . -name symbolicatecrash`
cd $parentdir
crashlog="$1"
archive="$2"
outputdir=`dirname "$crashlog"`
nfile=$(echo $1 | rev | cut -f 2- -d '.' | rev)
outputfile="$nfile"_symbolicated.crash
echo $nfile
desymfile="$archive"/dSYMs/*.dSYM
$command -v "$crashlog" "$desymfile" > "$outputfile"