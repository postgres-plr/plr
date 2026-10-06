#!/bin/bash
set -x -v -e

if [ "${PG_PATHS}" == "" ]; then echo "Environment variable PG_PATHS is missing."; exit 99; fi
if [ "${R_HOME}"   == "" ]; then echo "Environment variable R_HOME is missing.";   exit 99; fi
if [ "${R_PATHS}"  == "" ]; then echo "Environment variable R_PATHS is missing.";  exit 99; fi

export PATH=${R_PATHS}:${PG_PATHS}:${PATH}
unset R_HOME

# sudo pg_lsclusters
# export USE_PGXS=1
# SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
# sudo USE_PGXS=1 make install
# # make installcheck PGUSER=postgres || (cat regression.diffs && false)
# make installcheck || (cat regression.diffs && false)

# sudo pg_lsclusters
# 

# USE_PGXS=1 make clean
# USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
# # "install" can not read environment variables nor pre-sudo variables
# sudo USE_PGXS=1 make install
# USE_PGXS=1 make installcheck || (cat regression.diffs && false)


#### USE_PGXS=1 SHLIB_LINK=-lgcov PG_CPPFLAGS="-fprofile-arcs -ftest-coverage -O0" make
#### sudo USE_PGXS=1 make install
     USE_PGXS=1 make installcheck || (cat regression.diffs && false)

# Uploads code coverage to codecov.io
# {"message":"Token required - not valid tokenless upload"}
bash <(curl -s https://codecov.io/bash)

# USE_PGXS=1 make clean
