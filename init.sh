
cd "$(dirname "$0")"

# mypaint/windows/msys2-build.sh
# https://github.com/mypaint/mypaint/blob/4141a6414b77dcf3e3e62961f99b91d466c6fb52/windows/msys2-build.sh
#
# ANSI control codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

loginfo() {
  # set +v +x
  echo -ne "${CYAN}"
  echo -n "$@"
  echo -e "${NC}"
  # set -v -x
}

logok() {
  # set +v +x
  echo -ne "${GREEN}"
  echo -n "$@"
  echo -e "${NC}"
  # set -v -x
}

logerr() {
  # set +v +x
  echo -ne "${RED}ERROR: "
  echo -n "$@"
  echo -e "${NC}"
  # set -v -x
}

logok "BEGIN init.sh"

set -v -x -e
# set -e

# pwd
# /c/projects/plr

loginfo "uname -a $(uname -a)"

export R_HOME=$(cygpath "${R_HOME}")
loginfo "R_HOME ${R_HOME}"

#
# "pgsource" variable
# is only used about a custom PostgreSQL build (not an MSYS2 or CYGWIN already compiled binary)
# 

if [ ! "${pg}" == "none" ]
then
  export pgsource=$(cygpath "c:\projects\postgresql")
  loginfo "pgsource ${pgsource}"
fi

export APPVEYOR_BUILD_FOLDER=$(cygpath "${APPVEYOR_BUILD_FOLDER}")
# echo $APPVEYOR_BUILD_FOLDER
# /c/projects/plr

# 
# echo ${MINGW_PREFIX}
# /mingw64

if [ ! "${pg}" == "none" ]
then
  export pgroot=$(cygpath "${pgroot}")
else
  export pgroot=${MINGW_PREFIX}
  # cygwin override
  if [ "${compiler}" == "cygwin" ]
  then
    # override (not all executables use "/usr/bin": initdb, postgres, and pg_ctl are in "/usr/sbin")
    export pgroot=/usr
  fi
fi
loginfo "pgroot $pgroot"

# proper for "initdb" - see the PostgreSQL docs
export TZ=UTC

# e.g., in the users home directory

# msys2 case
if [ "${compiler}" == "msys2" ]
then
     export PGAPPDIR="C:/msys64$HOME"${pgroot}/postgresql/Data
fi
#
# cygwin case
if [ "${compiler}" == "cygwin" ]
then
  if [ "${Platform}" == "x64" ]
  then
    export PGAPPDIR=/cygdrive/c/cygwin64${HOME}${pgroot}/postgresql/Data
  else
    export PGAPPDIR=/cygdrive/c/cygwin${HOME}${pgroot}/postgresql/Data
  fi
fi
#
# add OTHER cases HERE: future arm* (guessing now)
if [ "${PGAPPDIR}" == "" ]
then
    export PGAPPDIR="$HOME"${pgroot}/postgresql/Data
fi

export     PGDATA=${PGAPPDIR}
export      PGLOG=${PGAPPDIR}/log.txt

# R.dll in the PATH
# not required in compilation
#     required in "CREATE EXTENSION plr;" and regression tests

# R in msys2 does sub architectures
if [ "${compiler}" == "msys2" ]
then
  export PATH=${R_HOME}/bin${R_ARCH}:${PATH}
else 
  # cygwin does-not-do R sub architectures
  export PATH=${R_HOME}/bin:${PATH}
fi
loginfo "R_HOME is in the PATH $(echo ${PATH})"

set +v +x +e
# set +e

logok "END   init.sh"
