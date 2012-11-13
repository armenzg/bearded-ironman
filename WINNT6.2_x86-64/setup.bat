@echo OFF
REM This script helps to setup up a fresh Windows 8 64-bit machine

set PACKAGES_URL="http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/"
set DOWN_PATH=%USERPROFILE%%\\Desktop\\Downloads
set WGET=C:\\mozilla-build\\wget\wget.exe

mkdir /p %DOWN_PATH%
cd %DOWN_PATH%

REM download and install PyWin32 for Python 2.7
REG ADD "HKLM\Software\Wow6432Node\Python\PythonCore\2.7\InstallPath" /t REG_SZ /d "C:\mozilla-build\python" /f
%WGET% "http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/python/pywin32-217.win32-py2.7.exe"
pywin32-217.win32-py2.7.exe

REM setup C:\\slave
cd C:\slave
%WGET% "http://hg.mozilla.org/build/puppet-manifests/raw-file/2d1b0425711e/modules/buildslave/files/runslave.py"
%WGET% "%PACKAGES_URL%/win8_64bit/startTalos-win8-64.bat"
schtasks /create /tn talosslave /tr "C:\\slave\\startTalos.bat" /sc onlogon  /ru cltbld

REM setup gvim
%WGET% "%PACKAGES_URL%/misc/gvim73_46.exe""
gvim73_46.exe

REM setup Apache
%WGET% "%PACKAGES_URL%/misc/httpd-2.2.22-win32-x86-no_ssl.msi"
httpd-2.2.22-win32-x86-no_ssl.msi
