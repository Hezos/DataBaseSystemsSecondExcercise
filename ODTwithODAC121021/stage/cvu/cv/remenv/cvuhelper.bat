@echo off
rem
rem WINDOWS file
rem
rem cvuhelper.sbs 
rem
rem Copyright (c) 2003, 2014, Oracle and/or its affiliates. 
rem All rights reserved.
rem
rem    NAME
rem      cvuhelper.bat - executes heavy weight APIs in compatible way
rem
rem    DESCRIPTION
rem      This requires these environmental variables.
rem      GI_HOME: clustware home
rem      CVUHELPER_VERSION: version of cvuhelper to use
rem      JAR_FILE_PATH: location of cvuhelper*.jar to use
rem      CV_HOME: home for CV tools
rem      Command and args: The command to execute and arugments for that command
rem      OR
rem      -client: flag indicating an earlier version trying to run a command
rem      CV_HOME_VERSION: version of the client
rem
rem    NOTES
rem      THIS IS A WINDOWS SPECIFIC FILE
rem
rem    MODIFIED   090325


if (%5) == () (
echo ^<CVH_EMSG^>
echo.
echo ERROR:
echo Usage %0 ^<GI_HOME^> ^<CVUHELPER_VERSION^> ^<JAR_PATH^> ^<CV_HOME^> ^<COMMAND^> [^<args^>]
echo Earlier version CVU will call cvuhelper with following arguments
echo Usage %0 -client ^<GI_HOME^> ^<GI_VERSION^> ^<CV_HOME^> ^<CV_HOME_VERSION^> ^<COMMAND^> [^<args^>]
echo ^</CVH_EMSG^>^<CVH_ERES^>2^</CVH_ERES^>^<CVH_VRES^>2^</CVH_VRES^>
goto ERROR
)

if (%1)==(-client) goto CLIENT_PROCESSING

@set ORACLE_HOME=%1
@set CVUHELPER_CLASS=helper%2.CVUHelper%2
@set CVUHELPERJAR_PATH=%3
@set CV_HOME=%4
goto SHIFT_ARGS

rem process -client args
:CLIENT_PROCESSING
@set ORACLE_HOME=%2
@set GI_VERSION=%3
@set CV_HOME=%4
@set CV_HOME_VERSION=%5
@set CVUHELPER_CLASS=helper12101.CVUHelper12101
@set CVUHELPERJAR_PATH=%ORACLE_HOME%\jlib\cvuhelper121.jar
shift

:SHIFT_ARGS
rem pop four args
shift
shift
shift
shift

setlocal
set all_arg=
:begin
if (%1) == () goto :done_arg 
set all_arg=%all_arg% %1
shift
goto begin
:done_arg

set REM_ENV=-DCV_HOME=%CV_HOME% -DGI_HOME=%ORACLE_HOME%

if exist %ORACLE_hOME%\jdk\jre set JREDIR=%ORACLE_HOME%\jdk\jre

if not exist %JREDIR%\bin\java.exe (
    @echo ^<CVH_EMSG^>set ORACLE_HOME variable so that %ORACLE_HOME%\jdk\jre points to a valid JRE location^</CVH_EMSG^>^<CVH_ERES^>2^</CVH_ERES^>^<CVH_VRES^>2^</CVH_VRES^>
    goto ERROR
)

REM SRVM jar file
@set SRVMJAR=%ORACLE_HOME%\jlib\srvm.jar

@set LDAPJAR=%ORACLE_HOME%\jlib\ldapjclnt12.jar
@set NETCFGJAR=%ORACLE_HOME%\jlib\netcfg.jar
@set INSTALLJAR=%ORACLE_HOME%\oui\jlib\OraInstaller.jar
@set PREREQJAR=%ORACLE_HOME%\oui\jlib\OraPrereq.jar
@set FIXUPJAR=%ORACLE_HOME%\oui\jlib\prov_fixup.jar
@set XMLPARSERJAR=%ORACLE_HOME%\oui\jlib\xmlparserv2.jar
@set SHAREJAR=%ORACLE_HOME%\oui\jlib\share.jar
@set MAPPINGJAR=%ORACLE_HOME%\oui\jlib\orai18n-mapping.jar
@set SRVMHASJAR=%ORACLE_HOME%\jlib\srvmhas.jar
@set SRVMASMJAR=%ORACLE_HOME%\jlib\srvmasm.jar
@set GNSJAR=%ORACLE_HOME%\jlib\gns.jar
@set OPATCHJAR=%ORACLE_HOME%\OPatch\jlib\opatch.jar
@set OPATCHSDKJAR=%ORACLE_HOME%\OPatch\jlib\opatchsdk.jar
@set OPLANJAR=%ORACLE_HOME%\OPatch\oplan\jlib\oplan.jar
@set OPLANPATCHSDKJAR=%ORACLE_HOME%\OPatch\oplan\jlib\patchsdk.jar
@set OUI_LIBRARY_PATH=%ORACLE_HOME%\oui\lib\win64

if not exist %OPATCHJAR% (
  @set OPATCHJAR=%ORACLE_HOME%\opatch\OPatch\jlib\opatch.jar
  @set OPATCHSDKJAR=%ORACLE_HOME%\opatch\OPatch\jlib\opatchsdk.jar
  @set OPLANJAR=%ORACLE_HOME%\opatch\OPatch\oplan\jlib\oplan.jar
  @set OPLANPATCHSDKJAR=%ORACLE_HOME%\opatch\OPatch\oplan\jlib\patchsdk.jar
)

if not exist %OUI_LIBRARY_PATH% (
  @set OUI_LIBRARY_PATH=%ORACLE_HOME%\oui\lib\win32
)

REM JRE Executable and Class File Variables
@set JRE=%JREDIR%\bin\java.exe
@set JREJAR=%JREDIR%\lib\rt.jar

@set CLASSPATH=%JREJAR%;%CVUHELPERJAR_PATH%;%SRVMJAR%;%INSTALLJAR%;%PREREQJAR%;%FIXUPJAR%;%XMLPARSERJAR%;%SHAREJAR%;%MAPPINGJAR%;%SRVMHASJAR%;%SRVMASMJAR%;%GNSJAR%;%NETCFGJAR%;%LDAPJAR%;%OPATCHJAR%;%OPATCHSDKJAR%;%OPLANJAR%;%OPLANPATCHSDKJAR%;
@set PATH=%ORACLE_HOME%\bin;%PATH%;

REM set tracing info
@set TRACE=
@set TRACEOPT=

if not '%SRVM_TRACE%'=='' (
  if /I '%SRVM_TRACE%' == 'false' (
    @set TRACE=-DTRACING.ENABLED=false
  ) else (
    if not '%SRVM_TRACE_LEVEL%' == '' (
      @set TRACE=-DTRACING.ENABLED=true -DTRACING.LEVEL=%SRVM_TRACE_LEVEL%
    ) else (
      @set TRACE=-DTRACING.ENABLED=true -DTRACING.LEVEL=2
    )
  )
)

REM Run cvuhelper

%JRE% -classpath %CLASSPATH% %REM_ENV% %TRACE% -Doracle.installer.library_loc=%OUI_LIBRARY_PATH% -Djava.net.preferIPv4Stack=true oracle.ops.verification.helper.%CVUHELPER_CLASS% %all_arg%

exit /B %errorlevel%
goto :EOF

:ERROR
endlocal
exit /B 1
