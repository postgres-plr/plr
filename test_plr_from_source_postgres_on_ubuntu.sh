#!/bin/bash
set -x -v -e

if [ "${PG_PATHS}" == "" ];  then echo "Environment variable PG_PATHS is missing.";  exit 99; fi
if [ "${R_PATHS}" == "" ];   then echo "Environment variable R_PATHS is missing.";   exit 99; fi
if [ "${R_HOME}" == "" ];    then echo "Environment variable R_HOME is missing.";    exit 99; fi
if [ "${PG_SOURCE}" == "" ]; then echo "Environment variable PG_SOURCE is missing."; exit 99; fi

# # PREVIOUSLY DONE ALREADY in "build_install_postgres_from_source_on_ubuntu.sh"
# pg_ctl -D data -l logfile -w start


# added to the PATH
export PATH=${R_PATHS}:${PG_PATHS}:${PATH}


## # Older case
## # This worked when (1) I compiled PG from source AND (2) DID NOT compile contrib/plr AT THE SAME TIME
##
## # In the file "build_install_plr_and_postgres_from_source_on_ubuntu.sh"
## # if the following had been done ... without the "plr" folder
## #   being in the "contrib" directory (without "plr" being installed)
##
## ./configure --enable-depend --disable-rpath --without-icu
## make
## sudo make install
##
## # pgxs make
## # pgxs install
## # pgxs regression tests (THIS WORKS!) - requires "PATH=/usr/local/pgsql/bin:$PATH"
## #
## unset R_HOME ??
## export PATH=${R_PATHS}:${PG_PATHS}:${PATH}
## 
## USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
## sudo --preserve-env=PATH USE_PGXS=1 make install
##                          USE_PGXS=1 make installcheck || (cat regression.diffs && false)
## USE_PGXS=1  make clean
## 
## # #I HAVE NOT TESTED THIS
## # sudo USE_PGXS=1 make uninstall

if [ "${buildpgFromSRCmethod}" == "make" ]
then

  pushd  ${PG_SOURCE}/contrib/plr

  unset R_HOME
  USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
  sudo --preserve-env=PATH USE_PGXS=1 make install
                           USE_PGXS=1 make installcheck || (cat regression.diffs && false)

  # Uploads code coverage to codecov.io
  # {"message":"Token required - not valid tokenless upload"}
  bash <(curl -s https://codecov.io/bash)

  # USE_PGXS=1  make clean

  popd # from ${PG_SOURCE}/contrib/plr back

fi

# meson
if [ "${buildpgFromSRCmethod}" != "make" ]
then

  pushd  ${PG_SOURCE}

  #
  # regression tests ( buildpgANDplrInSRCcontrib == 'true' )
  #

  # make -C contrib/amcheck installcheck
  # https://wiki.postgresql.org/wiki/Meson
  meson test -C build -v --print-errorlogs --setup running --suite cube-running
  meson test -C build -v --print-errorlogs --setup running --suite plr-running

  # FAILED: [code=1] meson-internal__coverage-xml
  # (WARNING) Unrecognized GCOV output for /PGSOURCE/src/backend/utils/adt/numeric.c
  # (ERROR) Exiting because of parse errors.
  # You can run gcovr with --gcov-ignore-parse-errors
  #
  # export CC_GCOV_ARGS="--gcov-ignore-parse-errors" (DID NOT WORK)
  # ninja      -C build -v coverage-xml 

  # so, so that the coverage.info file is written to the Github Workspace
  lcov --capture --directory build/contrib/plr/plr.so.p -o ${GITHUB_WORKSPACE}/coverage.info

  popd # from ${PG_SOURCE} back

fi


# STILL meson (seems wrong directory for the "make" method)
if [ "${buildpgFromSRCmethod}" != "make" ]
then

  #
  # manual regression tests
  #

  export PKGLIBDIR=$(pg_config | grep "^PKGLIBDIR" | sed "s/ = /=/" | sed "s/^.*=//")
  echo "pg_config PKGLIBDIR: ${PKGLIBDIR}"

  export BINDIR=$(pg_config | grep "^BINDIR" | sed "s/ = /=/" | sed "s/^.*=//")
  echo "pg_config BINDIR: ${BINDIR}"

  # export PGUSER=$(whoami)
  # echo "PGUSER: ${PGUSER}"

  psql -d postgres                 -c "SELECT version();"
  psql -d postgres                 -c "SELECT current_setting('server_version_num') "server_version_num";"

  pushd     "${PG_SOURCE}/contrib/cube"
  "${PKGLIBDIR}/pgxs/src/test/regress/pg_regress" --bindir="${BINDIR}" --dbname=pl_regression cube cube_sci || (cat regression.diffs && false)
  popd # from "${PG_SOURCE}/contrib/cube"

  pushd     "${PG_SOURCE}/contrib/plr"
  "${PKGLIBDIR}/pgxs/src/test/regress/pg_regress" --bindir="${BINDIR}" --dbname=pl_regression plr bad_fun opt_window do out_args plr_transaction opt_window_frame parallel || (cat regression.diffs && false)
  popd # from "${PG_SOURCE}/contrib/plr"

fi

pg_ctl -D data -l logfile stop
