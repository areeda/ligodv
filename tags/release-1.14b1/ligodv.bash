#!/bin/bash

# ligoDV v1.14+ start script
#
#======================================================================================
#
# We expect you will not need to edit this file if your system is set up as we expect.
# However, that is a big and often incorrect assumption.
#
# This section of the file defines a the environment variable you may need to change:

# Set these variables for your install:
# (I'm working on doing it automatically but you're better than my code right now)

# set this to the root NDS2 directory that contains the lib subdirectory
# this environment variable can be set with etc/nds2-client-user-env.sh in the NDS tree
# if the NDS2 libraries are not specified you can set them in LigoDV.

#export NDS2_LOCATION=$HOME/nds2_client

# which version of Matlab to use
# set this to select one of multiple Matlab versions or if Matlab is not in your path

#export MATLAB=/usr/local/MATLAB/R2012b/bin/matlab

# the following variables are NOT used by the current version LigoDV but may be useful 
# if you want to use other Matlab libraries (like MatApps) with LigoDV

#export LD_LIBRARY_PATH=<enter location of nds libraries if necessary here>
#export MATLABPATH=<put the path to any additional matlab .m or .mex<arch> files here>

# You would only need to set the following variable if the start script (this file) is
# moved out of the LigoDV directory tree.  It should be set to the installation directory
# containing the ligodv directory not to the LigoDV<ver>/ligodv.
# In other words: the directory in which you originally found this file.

# export  LIGODV_LOCATION=<path to LigoDV install dir>
#
#========================================================================================
# this part should be good as it is as long as the above is set correctly
#
err=0		# we haven't found anything wrong yet
me=$0		# the full path to this script

# Get the directory of this script and ASSUME the LigoDV Matlab sources and auxiliary
# files are in the directory tree below us.
if [ -z $LIGODV_LOCATION ]
then
	if [ -e $me ]
	then
   		LIGODV_LOCATION=`dirname $me`
	fi
fi

# one last straw to grasp at
if [ -z $LIGODV_LOCATION ] || [ "$LIGODV_LOCATION" = "." ]  
then
   LIGODV_LOCATION=`pwd`
fi

# verify we can find the Matlab executable some installations expect Matlab
# to be only run from a menu
if [ -z $MATLAB ] ; then

	MATLAB=`which matlab`
	if [ -z $MATLAB ] ; then 
	    err=1
	    echo Matlab does not seem to be in your path
	    echo see the ligoDV wiki page on Installation Problems 
	    echo "https://wiki.ligo.org/LDG/DASWG/LigoDVInstall"
	else
	    d=`dirname $MATLAB`
	    echo $d | grep "/bin" >/dev/null
	    if [ $? == 0 ] ; then d=`dirname $d`; fi
	
	    export MATLAB_LOCATION=$d
	fi
fi

if [ ! -z $NDS2_LOCATION ]; then
	if [ ! -d $NDS2_LOCATION ]; then
	   echo "NDS2_LOCATION is defined as ($NDS2_LOCATION) but it does not point to a directory"
	   err=1
	elif [ ! -d $NDS2_LOCATION/lib ]; then
	   echo "NDS2_LOCATION is defined as ($NDS2_LOCATION) but it does not contain the lib subdirectory."
	   err=1
	fi
fi


if [ $err -eq 0 ]; then
  
    echo "Matlab is located in $MATLAB"
	if [ ! -z $NDS2_LOCATION ]; then
	    echo "NDS2 libraries and executables are in $NDS2_LOCATION"
	fi
    echo "Load Library path is $LD_LIBRARY_PATH"
	if [ ! -z $MATLABPATH ]; then
	    echo "The Matlab path contains $MATLABPATH"
	fi
	echo "ligoDV is located in $LIGODV_LOCATION/ligodv"
    cd $LIGODV_LOCATION/ligodv

	klist -s
	if [ $? == 1 ] ; then
  		echo "You need to do a kinit if you want to pull data"
		echo "eg: kinit albert.einstein@LIGO.ORG"

  		read -p "Continue anyway [y/N]?"
  		if [ $REPLY != "y" ] ; then
  		  exit 1;
  		fi
	fi
  
	# finally we get to start it
   	$MATLAB -r ligoDV_start 2>&1 | grep -v "exclude an item from Time Machine"
else
  echo "Problem detected."
  echo "Please resolve and try again"
fi
exit
