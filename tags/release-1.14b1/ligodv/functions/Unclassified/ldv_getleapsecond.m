function leapSeconds = ldv_getleapsecond(GPS_time)

%	Usage: leapSeconds = ldv_getleapsecond(GPS_time)
%   
%	Returns number of leap second since start of GPS for a given GPS time
%
%	Example:
%	>> leapSeconds = ldv_gps2utc(820108815)
%	will return leapSeconds = 14
%
%   J. Smith 1/28/08
%
%   Based on XLaLLeapSeconds.h
%
%   $Id$

% Pared down table of the GPS times at which leap seconds have been added 
% since the start of GPS. Source: XLaLLeapSeconds.h, which had sources:
% http://maia.usno.navy.mil/  and http://maia.usno.navy.mil/ser7/tai-utc.dat

leapGPS = ...
[46828800  % /* 1981-Jul-01 */
78364801   % /* 1982-Jul-01 */
109900802  % /* 1983-Jul-01 */
173059203  % /* 1985-Jul-01 */
252028804  % /* 1988-Jan-01 */
315187205  % /* 1990-Jan-01 */
346723206  % /* 1991-Jan-01 */
393984007  % /* 1992-Jul-01 */
425520008  % /* 1993-Jul-01 */
457056009  % /* 1994-Jul-01 */
504489610  % /* 1996-Jan-01 */
551750411  % /* 1997-Jul-01 */
599184012  % /* 1999-Jan-01 */
820108813  % /* 2006-Jan-01 */
914803214  % /* 2009-Jan-01 */
1025135955 % /* 2012-Jul-01 */
];

% find number of leap seconds by index
if GPS_time >=46828800
leapSeconds = max(find(leapGPS<=GPS_time));
else 
leapSeconds = 0;
end
