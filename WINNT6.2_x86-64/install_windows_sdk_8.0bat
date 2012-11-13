@ECHO OFF
SET PACKAGES_URL="http://dev-stage01.build.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/sdks"
SET WGET="C:\mozilla-build\wget\wget.exe"
SET ASYNCINFO_PATH="C:\Program Files (x86)\Windows Kits\8.0\Include\winrt\asyncinfo.h"

IF EXIST %ASYNCINFO_PATH% (
  echo "The Windows SDK 8.0 is already installed."
  exit /b 0
) ELSE (
  echo "The Windows SDK 8.0 is not installed."
)

%WGET% -q "%PACKAGES_URL%/sdksetup.exe"
ECHO "Installing the SDK..."
sdksetup.exe /q /norestart

IF EXIST %ASYNCINFO_PATH% (
  ECHO "Replacing asyncinfo.h..."
  %WGET%  -q -Oasyncinfo.h "https://bugzilla.mozilla.org/attachment.cgi?id=678752"
  rm "C:\Program Files (x86)\Windows Kits\8.0\Include\winrt\asyncinfo.h"
  cp asyncinfo.h "C:\Program Files (x86)\Windows Kits\8.0\Include\winrt\asyncinfo.h"
  ECHO "asyncinfo.h has been replaced!"
)

IF EXIST %ASYNCINFO_PATH% (
  echo "The Windows SDK 8.0 has been installed correctly."
  exit /b 0
) ELSE (
  echo "ERROR: The Windows SDK 8.0 should have been installed but something must have failed."
  exit /b 1
)
