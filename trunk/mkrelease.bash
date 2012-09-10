#!/bin/bash
#
# package the working version of ligodv as our new release
if [ $# -ne 1 ] ; then
    echo "Usage: mkrelease.bash <version string>"
    echo "Where <version string> is something 1.13a4 and is used to name the directory, tar and zip file "
    exit 1
fi
cd $HOME/ligodv-working
./mkbkup 

ver=$1
name=ligodv-$ver
echo "Packaging scripts and ligodv directory as $name"

# remove temorary directory if it already exists
if [ -d $name ]; then
    rm -rf $name
fi

# make a temporary directory to hold the "release"
mkdir $name
cp -r ligodv $name

rm -rf $name/ligodv/.git

cp ligodv.bash LigoDV_icon.png ligodv.bat $name

tar -zcf $name.tgz $name
zip -9rp $name.zip $name >/dev/null

rm -rf $name

