@echo off

rem *** Execute timed command ***
set STARTTIME=%TIME%

rem *** Execute commandline ***
%*

set ENDTIME=%TIME%

echo.
echo Timed Execution Results:
echo.
echo Command:  %*
echo Start:    %STARTTIME%
echo End:      %ENDTIME%
echo  ---------------

rem *** Now do the tokenization and math:

for /F "tokens=1-4 delims=:.," %%a in ("%STARTTIME%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

for /F "tokens=1-4 delims=:.," %%a in ("%ENDTIME%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem *** Calculate elapsed time ***
set /A elapsed=end-start

rem *** Format the results ***
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %hh% lss 10 set hh=0%hh%
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%

set RUNTIME=%hh%:%mm%:%ss%.%cc%

echo Elapsed:  %RUNTIME%
