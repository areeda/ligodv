function gps_time = ldv_utc2gps(UTC_time)

%	gps_time = ldv_utc2gps(UTC_time)
%	converts UTC time to GPS seconds
%	UTC_time can also be an array of UTC times
%
%	Examples:
%	gps_time = ldv_utc2gps('2002-07-19 16:00:00')
%	will return gps_time=711129613
%
%
% Original by Karsten Koetter. Maintained by M Hewitson.
%
% $Id$
%


GPS_Epoch=datenum('01-06-1980 00:00:00')*86400;

[p q]=size(UTC_time);

for(i=1:p)
    CurrUTC=UTC_time(i,:);
    % reformt string to stupid matlab format MM-DD-YYY
    CurrUTC=strcat(CurrUTC(6:10),'-',CurrUTC(1:4),CurrUTC(11:length(CurrUTC)));
    NUM_time=datenum(CurrUTC)*86400;
    leapSeconds = ldv_getleapsecond(NUM_time-GPS_Epoch);
    gps_time(i)=round(NUM_time-GPS_Epoch+leapSeconds);
end
