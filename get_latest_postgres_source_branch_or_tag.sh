#!/bin/bash
set -x -v -e

if [ ! -f "${GITHUB_ENV}" ]; then touch discard.txt; export GITHUB_ENV=discard.txt; fi

# Inputs
# PGSRCVERSION=REL_<major>_
export PGSRCVERSION="$1"
if [ "${PGSRCVERSION}" == "" ]; then echo "Passed 1st variable PGSRCVERSION is missing."; exit 99; fi

# Input examples
# export PGSRCVERSION=master
# export PGSRCVERSION=REL_19_
# Outputs
# PG_SOURCE
# a new Git postgres directory located at /PGSOURCE

if [ "${PGSRCVERSION}" == "master" ]
then
  set +x +v +e
  export SPECGITTAG="master"
  set -x -v -e
else
  set +x +v +e
  export ALLGITTAGS=$(git ls-remote --tags https://github.com/postgres/postgres.git | cut -c 52-)
  set -x -v -e
  quantity() { set +x +v +e; echo ${ALLGITTAGS} | tr " " "\n" | grep -c "${PGSRCVERSION}${MARK}[0-9]"; set -x -v -e; }
  quality()  { set +x +v +e; echo ${ALLGITTAGS} | tr " " "\n" | grep -e "${PGSRCVERSION}${MARK}[0-9]" | tail -n 1; set -x -v -e; }
  export MARK=""
  export RET=$(quantity)
  if [ "${RET}" -gt "0" ]
  then
    export SPECGITTAG=$(quality)
    echo -n "Release(s) are found.  Taking the last Release . . . SPECGITTAG: ${SPECGITTAG}"
  else
    export MARK="RC"
    export RET=$(quantity)
    echo "Release(s) are not found.  Trying Release Candidates."
    if [ "${RET}" -gt "0" ]
    then
      export SPECGITTAG=$(quality)
      echo -n "Release Candidate(s) are found.  Taking the last Release Candidate . . . SPECGITTAG: ${SPECGITTAG}"
    else
      export MARK="BETA"
      export RET=$(quantity)
      echo "Release Candidate(s) are not found. Trying Betas."
      if [ "${RET}" -gt "0" ]
      then
        export SPECGITTAG=$(quality)
        echo -n "Beta(s) are found. Taking the last Beta . . . SPECGITTAG: ${SPECGITTAG}"
      else
        echo -n "Beta(s) are not found."
      fi
    fi
  fi
fi
echo "SPECGITTAG: ${SPECGITTAG}"

export PG_SOURCE="/PGSOURCE"
echo "PG_SOURCE=${PG_SOURCE}" >> ${GITHUB_ENV}
echo "PG_SOURCE: ${PG_SOURCE}"

# --branch: downloads a remote repository and automatically checks out the 
#           specific branch or tag you name, instead of the repository's default branch 
# Note, if SPECGITTAG is a tag, then You are in 'detached HEAD' state.
sudo git clone --branch "${SPECGITTAG}" --depth=1 https://github.com/postgres/postgres.git "${PG_SOURCE}"
sudo chmod -R 777                                                                          "${PG_SOURCE}"

if [ -f "discard.txt" ]; then rm discard.txt; fi
