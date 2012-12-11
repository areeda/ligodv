#!/bin/bash
#
# package the working version of ligodv as our new release
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

# remove temorary directory if it already exists
if [ -e $tdir ]; then
    rm -rf $tdir
fi

# make a temporary directory to hold the "release"
mkdir $tdir
cp -r ligodv $tdir

# copy the auxiliary files we want in the tarball
cp ligodv.bash LigoDV_icon.png ligodv.bat $tdir

cdir=$PWD
cd $tdir
# delete any versioning directories and files
find . -name .svn -exec rm -rf {} \;

tar -zcf ${cdir}/${name}.tgz *
zip -9rp ${cdir}/${name}.zip * >/dev/null

# back to the source dir for any clean up if necessary
cd $cdir

rm -rf $tdir

# and finally back to the original directory when we were called
cd $odir
