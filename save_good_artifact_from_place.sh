#!/bin/bash
set -x -v -e

echo "pwd: $(pwd)"

export PG_PLACE="$1"
echo "PG_PLACE: ${PG_PLACE}"
export PG_PLACE=$(cygpath "${PG_PLACE}")
echo "PG_PLACE: ${PG_PLACE}"

export PGROOT2="$2"
echo "PGROOT2: ${PGROOT2}"
export PGROOT2=$(cygpath "${PGROOT2}")
echo "PGROOT2: ${PGROOT2}"

export CURRENT_WORKSPACE="$3"
echo "CURRENT_WORKSPACE: ${CURRENT_WORKSPACE}"
export CURRENT_WORKSPACE=$(cygpath "${CURRENT_WORKSPACE}")
echo "CURRENT_WORKSPACE: ${CURRENT_WORKSPACE}"

# save GOOD artifact plr.dll
#
if [ -f "${PG_PLACE}/contrib/plr/plr.dll" ]
then
  echo "Save plr.dll to be an artifact."
  mkdir -p                                             ${CURRENT_WORKSPACE}/tmp/lib
  cp    LICENSE                                        ${CURRENT_WORKSPACE}/tmp/PLR_LICENSE
  cp    "${PG_PLACE}/contrib/plr/plr.dll"              ${CURRENT_WORKSPACE}/tmp/lib
  ls -alrt                                             ${CURRENT_WORKSPACE}/tmp/lib/plr.dll
  mkdir -p                                             ${CURRENT_WORKSPACE}/tmp/share/extension
  cp    *.control                                      ${CURRENT_WORKSPACE}/tmp/share/extension
  cp    *.sql                                          ${CURRENT_WORKSPACE}/tmp/share/extension
fi

export CURRENT_WORKSPACE=$(cygpath "${CURRENT_WORKSPACE}")
#
# save GOOD artifact plr.dll.a
#
if [ -f "${PG_PLACE}/contrib/plr/plr.dll.a" ]
then
  echo "Save plr.dll.a to be an artifact."
  mkdir -p                                               ${CURRENT_WORKSPACE}/tmp/lib
  cp    "${PG_PLACE}/contrib/plr/plr.dll.a"              ${CURRENT_WORKSPACE}/tmp/lib
  ls -alrt                                               ${CURRENT_WORKSPACE}/tmp/lib/plr.dll.a
fi

# 7z GOOD PL/R Artifact for LATER Release
echo "7z: $(which 7z)"
echo 7z a -r ${CURRENT_WORKSPACE}/plr-artifact.zip  ${CURRENT_WORKSPACE}/tmp/*
if [ -f "${CURRENT_WORKSPACE}/tmp/PLR_LICENSE" ]
then
  echo "Create PL/R Artifact .zip for future Release"
  7z a -r ${CURRENT_WORKSPACE}/plr-artifact.zip  ${CURRENT_WORKSPACE}/tmp/*
fi

# if "PostgreSQL for Windows" exists, then
# copy "Mingw artifacts into "PostgreSQL for Windows" for future testing if env.MingwtestonpgWIN == 'true'.
#
if ( [ ! "${PGROOT2}" == "notset" ] && [ ! "${PGROOT2}" == "" ] ) && [ "${OperatingSystem}" == "Mingw" ]
then
  export PGROOT2=$(cygpath "${PGROOT2}")
  echo  "cygpath PGROOT2: ${PGROOT2}"

  if [ -d "${PGROOT2}" ]
  then
    if [ -f "${PG_PLACE}/contrib/plr/plr.dll" ]
    then
      echo "PGROOT2 is found. Preparing PostgreSQL for Windows testing."

      cp  "${PG_PLACE}/contrib/plr/plr.dll"          "${PGROOT2}/lib"
      ls -alrt                                       "${PGROOT2}/lib/plr.dll"
      cp plr.control                                 "${PGROOT2}/share/extension"
      ls -alrt                                       "${PGROOT2}/share/extension/plr.control"
      cp plr--*.sql                                  "${PGROOT2}/share/extension"
      ls -alrt                                       "${PGROOT2}"/share/extension/plr--*.sql

    fi
  fi
fi
