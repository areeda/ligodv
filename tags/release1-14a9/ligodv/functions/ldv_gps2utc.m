function utc_time = ldv_gps2utc(GPS_time)

%	utc_time = ldv_gps2utc(GPS_time)
%	converts GPS seconds to UTC time
%
%	Example:
%	>> UTC_time = ldv_gps2utc(711129613)
%	will return UTC_time='2002-07-19 16:00:00'
%
% Based on GPS2UTC.m
% Original by Karsten Koetter. Maintained by M Hewitson.
%
% $Id$
%

GPS_Epoch=datenum('01-06-1980 00:00:00')*86400;
leapSeconds = ldv_getleapsecond(GPS_time); % Leap seconds since GPS start
NUM_time=GPS_Epoch+double(GPS_time)-leapSeconds;

utc_time=datestr(NUM_time/86400,31);
