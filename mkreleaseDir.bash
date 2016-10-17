#!/bin/bash

# create a directory with release files only

if [ $# -ne 1 ] ; then
    echo "Usage: mkrelease.bash <version string>"
    echo "Where <version string> is something 1.13a4 and is used to name the directory, tar and zip file "
    exit 1  
fi
me=$0       # the full path to this script

if [ -e $me ]
then    
    ldvdir=`dirname $me`
else
    echo "oops. can't find the ligodv directory"
    exit 1  
fi

# always remember where you came from young man
odir=$PWD

cd $ldvdir 
./mkbkup 

ver=$1
name=ligodv-$ver
tdir=/tmp/${name}
echo "Packaging scripts and ligodv directory as $name"

tar -zcf ${name}.tgz --exclude=.svn --exclude=\*.prj --exclude=\*.log \
    --exclude=\*.mlappinstall ligodv ligodv.spec ligodv.dir  LigoDV_icon.png \
	LigoDV_icon24.png ligodv.bat

if [ $? -ne 0 ]
then
	echo "exit because of error on tar"
	exit 2
fi
rm -rf t
mkdir t
cd t
tar -zxf ../${name}.tgz
zip -9rp ../${name}.zip * >/dev/null

cd ${odir}
if [ -e ligodv.mlappinstall ]; then
   rm ligodv.mlappinstall
fi

echo "now it's time to package the matlab installer"

