#!/bin/bash
set -x -v -e

# uses ./get_uname_info.sh

# Cygwin does not currently have an official, native ARM64 release, 
# but x86_64 binaries can run via Windows 11 on ARM's built-in x86 emulation (FUTURE)
#
# ddltool USERS
#
# Late brute force detection.  I need some thing or some system more elegant here.
#
if [ "${OperatingSystem}" == "Mingw" ] || [ "${OperatingSystem}" == "Cygwin" ]
then
  gendef  -         R.dll >     R.def
fi

if [ "${isKernelNamedARM}" == "false" ] && ( [ "${OperatingSystem}" == "Mingw" ] || [ "${OperatingSystem}" == "Cygwin" ] )
then
  dlltool --dllname R.dll --def R.def --output-lib libR.dll.a
fi
#
# Linux ARM does have (llvm support and) gcc support.
# Windows 11 ARM has ONLY llvm support and does not have any gcc support.
# uname -a on Github Actions windows-11-arm CLANGARM64 (SEEN AUG 2026)
#   MINGW64_NT-10.0-26200-ARM64 runnervmmioek 3.6.10-8fbd9808.x86_64 2026-08-13 11:15 UTC x86_64 Msys
if [ "${isKernelNamedARM}" == "true" ] && ( [ "${OperatingSystem}" == "Mingw" ] || [ "${OperatingSystem}" == "Cygwin" ] )
then 
  if [ "${isMachineHardwareNamed64}" == "true" ]
  then
    llvm-dlltool -m arm64 -D R.dll -d R.def -l libR.dll.a
  else
    llvm-dlltool -m arm   -D R.dll -d R.def -l libR.dll.a
  fi
fi
