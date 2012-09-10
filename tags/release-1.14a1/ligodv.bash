#!/bin/bash
#-----------
# ligoDV start script
# please edit the _LOCATION values to match your installation

# Set these variables for your install:
# (I'm working on doing it automatically but you're better than my code right now)

# set this to the NDS2 directory that contains the lib subdirectory

#export NDS2_LOCATION=$HOME/nds2_client

#export LD_LIBRARY_PATH=<enter location of nds libraries if necessary here>
#export MATLABPATH=<put the path to any additional matlab .m or .mex<arch> files here>
#------------------------
# this part should be good as it is as long as the above is set correctly
#
err=0		# we haven't found anything wrong yet
me=$0

if [ -e $me ]
then
   LIGODV_LOCATION=`dirname $me`
fi


if [ -z $LIGODV_LOCATION ] || [ "$LIGODV_LOCATION" = "." ]  
then
   LIGODV_LOCATION=`pwd`
fi

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

if [ -z $NDS2_LOCATION ] ; then
   # try to guess where they put it
   dl="/Applications/ligodv-1.13 /opt/local $HOME /usr/local"
   ndsNames="nds2*client NDS2*CLIENT NDS2*client"
   for dir in $dl ; do
      if [ -d $dir ]; then
        for dname in $ndsNames ; do
            dsc="find $dir -name $dname -type d"
            nds=`find $dir -maxdepth 1 -name "$dname" -type d`
            n=`echo $nds | wc | awk '{print $1;}'`
            if [ "$n"="1" ]; then
                if [ -d $nds/local ]; then nds=$nds/local; fi
                if [ -z $NDS2_LOCATION ]; then export NDS2_LOCATION=$nds; fi
                break
            fi  
        done
      fi
   done

fi

if [ -z $NDS2_LOCATION ]; then
   echo "NDS2 was not found.  Please define the environment variable NDS2_LOCATION"
   err=1
elif [ ! -d $NDS2_LOCATION ]; then
   echo "NDS2_LOCATION is defined but it does not point to a directory"
   err=1
elif [ ! -d $NDS2_LOCATION/lib ]; then
   echo "NDS2_LOCATION is defined but it does not contain the lib subdirectory."
   err=1
fi


if [ -z $LD_LIBRARY_PATH ]; then
    export LD_LIBRARY_PATH=$NDS2_LOCATION/lib
else
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NDS2_LOCATION/lib
fi

if [ $err -eq 0 ]; then
  
    echo "Matlab is located in $MATLAB_LOCATION"
    echo "NDS2 libraries and executables are in $NDS2_LOCATION"
    echo "Load Library path is $LD_LIBRARY_PATH"
    echo "ligoDV is located in $LIGODV_LOCATION/ligodv"
    cd $LIGODV_LOCATION/ligodv

   $MATLAB -r ligoDV
else
  echo "Problem detected."
  echo "Please resolve and try again"
fi
exit