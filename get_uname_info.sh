#!/bin/bash
set -x -v -e

if [ ! -f "${GITHUB_ENV}" ]; then touch discard.txt; export GITHUB_ENV=discard.txt; fi

export SystemInformation=$(uname -a)
echo "SystemInformation=${SystemInformation}" >> ${GITHUB_ENV}
echo "SystemInformation: ${SystemInformation}"

export KernelName=$(uname -s)
echo "KernelName=${KernelName}" >> ${GITHUB_ENV}
echo "KernelName: ${KernelName}"

# Windows OS computers -- Mingw and Cygwin [generally] only a good ARM detection
export isKernelNamedARM="notset"
if [ $(uname -s | grep -qEi "arm" && echo 0) ];
then
  export isKernelNamedARM="true"
else
  export isKernelNamedARM="false"
fi
echo "isKernelNamedARM=${isKernelNamedARM}" >> ${GITHUB_ENV}
echo "isKernelNamedARM: ${isKernelNamedARM}"

export KernelVersion=$(uname -v)
echo "KernelVersion=${KernelVersion}" >> ${GITHUB_ENV}
echo "KernelVersion: ${KernelVersion}"

export NetworkNodeHostName=$(uname -n)
echo "NetworkNodeHostName=${NetworkNodeHostName}" >> ${GITHUB_ENV}
echo "NetworkNodeHostName: ${NetworkNodeHostName}"

export KernelRelease=$(uname -r)
echo "KernelRelease=${KernelRelease}" >> ${GITHUB_ENV}
echo "KernelRelease: ${KernelRelease}"

export MachineHardwareName=$(uname -m)
echo "MachineHardwareName=${MachineHardwareName}" >> ${GITHUB_ENV}
echo "MachineHardwareName: ${MachineHardwareName}"

# Everywhere
# Windows ARM still called x86_64 
export isMachineHardwareNamed64="notset"
if [ $(uname -m | grep -qEi "64" && echo 0) ]
then
  export isMachineHardwareNamed64="true"
else
  export isMachineHardwareNamed64="false"
fi
echo "isMachineHardwareNamed64=${isMachineHardwareNamed64}" >> ${GITHUB_ENV}
echo "isMachineHardwareNamed64: ${isMachineHardwareNamed64}"

export Processor=$(uname -p)
echo "Processor=${Processor}" >> ${GITHUB_ENV}
echo "Processor: ${Processor}"

export HardwarePlatform=$(uname -i)
echo "HardwarePlatform=${HardwarePlatform}" >> ${GITHUB_ENV}
echo "HardwarePlatform: ${HardwarePlatform}"

export OperatingSystem=$(uname -o)
if [ "${OperatingSystem}" == "Msys" ]; then OperatingSystem="Mingw"; fi
echo "OperatingSystem=${OperatingSystem}" >> ${GITHUB_ENV}
echo "OperatingSystem: ${OperatingSystem}"

if [ -f "discard.txt" ]; then rm discard.txt; fi
