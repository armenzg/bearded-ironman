@echo OFF
REM WARNING: This script has not been tested to be run in one shot
REM WARNING: Each of these steps running with care will get you a working machine

REM This script helps to setup up a fresh Windows 8 64-bit machine
REM This script cannot yet be run silently

SET PACKAGES_URL="http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/"
SET DOWN_PATH=%USERPROFILE%%\\Desktop\\Downloads
SET WGET=C:\\mozilla-build\\wget\wget.exe
SET CP=C:\\mozilla-build\\msys\\bin\\cp.exe
SET MOZILLABUILD=C:\mozilla-build

IF NOT EXIST %MOZILLABUILD%\nul (
  ECHO "Please install mozilla-build first."
  EXIT /b 1
)

REM Setup paths that are needed for buildbot and Apache
MKDIR C:\slave
MKDIR C:\slave\talos-data\talos
CD C:\slave
%WGET% "http://hg.mozilla.org/build/puppet-manifests/raw-file/2d1b0425711e/modules/buildslave/files/runslave.py"
%WGET% "%PACKAGES_URL%/win8_64bit/startTalos.bat"
wget -OC:\\slave\\talosslave.xml "%PACKAGE_URL%/win8_64bit/talosslave.xml"
schtasks /create /tn talosslave /xml "C:\slave\talosslave.xml"

REM where we will download everything
MKDIR %DOWN_PATH%
CD %DOWN_PATH%

REM download and install PyWin32 for Python 2.7
REG ADD "HKLM\Software\Wow6432Node\Python\PythonCore\2.7\InstallPath" /t REG_SZ /d "C:\mozilla-build\python" /f
%WGET% "http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/python/pywin32-217.win32-py2.7.exe"
pywin32-217.win32-py2.7.exe

REM Mozilla Build 1.6 was used for Windows 8 64-bit and python is not under a numbered path
REM This is need for backward compatibility
MKDIR %MOZILLABUILD%/python27
%CP% -r %MOZILLABUILD%/python/* %MOZILLABUILD%/python27

REM install buildbot
%WGET% "%PACKAGES_URL%/win8_64bit/install_buildbot.bat"
install_buildbot.bat

REM setup gvim
REM TODO: find silent installation
%WGET% "%PACKAGES_URL%/misc/gvim73_46.exe""
gvim73_46.exe

REM setup Apache
%WGET% "%PACKAGES_URL%/misc/httpd-2.2.22-win32-x86-no_ssl.msi"
httpd-2.2.22-win32-x86-no_ssl.msi /q /norestart
rm "C:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\conf\\httpd.conf"
%WGET% -OC:\\Program Files (x86)\\Apache Software Foundation\\Apache2.2\\conf\\httpd.conf "%PACKAGES_URL%/win8_64bit/httpd.conf"

REM setup UltraVNC
%WGET% "%PACKAGES_URL%/win8_64bit/UltraVnc_10962_x64.msi"
UltraVnc_10962_x64.msi /q /norestart
rm "C:\\Program Files\\uvnc bvba\UltraVNC\ultravnc.ini"
REM TODO: The ini has a dummy password; it has to be fixed manually
%WGET% -O"C:\\Program Files\\uvnc bvba\UltraVNC\ultravnc.ini" "%PACKAGES_URL%/win8_64bit/ultravnc.ini"

REM setup the VC10 Debug CRT
%WGET% "%PACKAGES_URL%/CRTs/Microsoft_VC100_DebugCRT_x86.msi"
Microsoft_VC100_DebugCRT_x86.msi /q /norestart

REM schedule showing the Desktop
%WGET% "%PACKAGES_URL%/win8-64bit/showDesktop.scf" 
schtasks /create /tn ShowDesktop /tr "C:\slave\showDesktop.scf" /sc onlogon /ru cltbld

REM setup coreutils for talos' need for nohup
REM we might not need this with mozharness
REM You will need to use the GUI
REM %WGET% "%PACKAGES_URL%/misc/coreutils-5.3.0.exe"
REM coreutils-5.3.0.exe
