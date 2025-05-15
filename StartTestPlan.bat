@echo off
REM Встановіть шлях до JMeter (зміні на свій)
set JMETER_PATH=""

set TEST_PLAN=".\TestPlan.jmx"

set RESULTS_FOLDER=".\tests\results"

if not exist %RESULTS_FOLDER% mkdir %RESULTS_FOLDER%

%JMETER_PATH%\jmeter.bat -n -t %TEST_PLAN% -l %RESULTS_FOLDER%\results.jtl -e -o %RESULTS_FOLDER%\dashboard

pause
