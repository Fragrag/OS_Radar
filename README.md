//////////////////////////////////
//////   OS_RADAR v3.1.1    //////
//////////////////////////////////

Date 2017/07/06

Created by Jasper Janssens for OLYMPIA STADION
a video installation by David Claerbout

This is a Processing v3.3.5 script written in Java
using the controlP5 library for the user interface

-----
Date 2018/02/05
v3.1 release

This version was reworked by Haryo Sukmawanto and reviewed by Jasper Janssens for OLYMPIA STADION
a video installation by David Claerbout

OS_Radar now displays the weatherValues and weatherMode in the GUI. 
It now also has a logger that will record these values for each session 
for up three weeks in a .csv file found in log/

-----
Date 2018/12/26
v3.2 release

OS_Radar now displays the last moment it updated its data in the GUI. 
Fixed crashes when OS_RADAR couldn't reach its remote sources for data. When this occurs
it instead loads fallback data for the image and WeatherData
