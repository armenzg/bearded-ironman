@ECHO OFF
REM Desc:   The Windows SDK for Windows 8 + modified asyncinfo.h was requested in 
REM         bug 810141 for the Windows 8 support project. The SDK was downloaded from Microsoft [1][2].
REM         We have created an Standalone version based on the SDK releases on Nov. 15th, 2012
REM Date:   November 15th, 2012
REM Files:  sdksetup.zip, asyncinfo.h
REM
REM [1] http://msdn.microsoft.com/en-us/windows/desktop/hh852363.aspx
REM [2] http://download.microsoft.com/download/F/1/3/F1300C9C-A120-4341-90DF-8A52509B23AC/standalonesdk/sdksetup.exe

SET PACKAGES_URL=http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32
SET WGET=C:\mozilla-build\wget\wget.exe
SET UNZIP=C:\mozilla-build\info-zip\unzip.exe
SET ASYNCINFO_PATH="C:\Program Files (x86)\Windows Kits\8.0\Include\winrt\asyncinfo.h"

IF EXIST %ASYNCINFO_PATH% (
  echo "The Windows SDK 8.0 is already installed."
  exit /b 0
) ELSE (
  echo "The Windows SDK 8.0 is not installed."
)

REM This packages is 434MB
%WGET% -q "%PACKAGES_URL%/sdks/sdksetup.zip"
ECHO "Unpacking the SDK..."
%UNZIP% sdksetup.zip
ECHO "Installing the SDK..."
sdksetup.exe /q /norestart /l sdksetup.txt

IF EXIST %ASYNCINFO_PATH% (
  ECHO "Replacing asyncinfo.h..."
  %WGET%  -q -Oasyncinfo.h "%PACKAGES_URL%/win8_64bit/asyncinfo.h"
  rm %ASYNCINFO_PATH%
  cp asyncinfo.h %ASYNCINFO_PATH%
  ECHO "asyncinfo.h has been replaced!"
)

rm sdksetup.exe
rm asyncinfo.h

IF EXIST %ASYNCINFO_PATH% (
  echo "The Windows SDK 8.0 has been installed correctly."
  exit /b 0
) ELSE (
  echo "ERROR: The Windows SDK 8.0 should have been installed but something must have failed."
  exit /b 1
)
