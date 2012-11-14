@ECHO OFF
REM Desc:   The Windows SDK 8.0 + modified asyncinfo.h was requested in bug 810141 for the Windows 8
REM         support project. The SDK was downloaded from Microsoft [1].
REM Date:   November 13th, 2012
REM Files:  sdksetup.exe, asyncinfo.h
REM
REM [1] http://msdn.microsoft.com/en-us/windows/desktop/hh852363.aspx

SET PACKAGES_URL=http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32
SET WGET=C:\mozilla-build\wget\wget.exe
SET ASYNCINFO_PATH="C:\Program Files (x86)\Windows Kits\8.0\Include\winrt\asyncinfo.h"

IF EXIST %ASYNCINFO_PATH% (
  echo "The Windows SDK 8.0 is already installed."
  exit /b 0
) ELSE (
  echo "The Windows SDK 8.0 is not installed."
)

%WGET% -q "%PACKAGES_URL%/sdks/sdksetup.exe"
ECHO "Installing the SDK..."
sdksetup.exe /q /norestart

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
