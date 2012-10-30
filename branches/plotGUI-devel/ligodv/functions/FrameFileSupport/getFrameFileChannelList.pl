#!/usr/bin/perl

# M Hewitson
#
# $Id$


# Check input args
if($#ARGV < 1)
{
	print "# getFrameFileChannelList\n";
	print "# \n";
	print "# usage: getFrameFileChannelList <input frame file>\n";
	print "#\n";
	print "# M Hewitson 25-07-06\n";
	print "#\n";
  exit;
}


$framefile = $ARGV[0];


# run FrDump -d 2 -i then parse for adc: and proc: and get the lines following
#
# i.e. we want all lines between 
#       'Positions for proc:' and 'FrEvent:'
# and   'Positions for ADC:' and 'FrEvent:'
#
# Then for 
#

# OR write a C code that gets a channel list from a frame file
