@echo off
rem Set environment variable needed to run ligoDV
rem
rem we may need to specify which matlab to run.  
rem NDS2 only supports 2010b on Windows 64
set MATLAB=L:\Programs\MATLAB\R2010bSP1\bin\matlab.exe
rem
rem NDS directory location
set NDS2_LOCATION=L:\Programs\nds2-client 0.8.2
rem
rem this sets the path we need to find nds client.lib
rem
path %NDS2_LOCATION%\bin;%PATH%
rem
rem I haven't figured how to tell on Windows where this batch file is so
rem Please set this to the location of ligodv.m
set LIGODV_LOCATION=C:\ligodv-1.13rc3\ligodv
cd %LIGODV_LOCATION%
rem
rem Windows calls it something different, deal with it here
rem
rem set HOME=%HOMEPATH%
rem
echo current directory is %LIGODV_LOCATION%
echo  
echo NDS2_LOCATION is   %NDS2_LOCATION%
echo  
echo PATH is  %PATH%
echo  
echo MATLAB being used is  %MATLAB%

echo  
"%MATLAB%" -r ligoDV
