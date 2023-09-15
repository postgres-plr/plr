
cd "$(dirname "$0")"

. ./init.sh

logok "BEGIN test_script.sh"

set -v -x -e
# set -e

# put this in all non-init.sh scripts - pgroot is empty, if using an msys2 binary
# but psql is already in the path
if [ -f "${pgroot}/bin/psql" ]
then
  export PATH=${pgroot}/bin:${PATH}
fi
#
# cygwin # pgroot: /usr - is the general location of binaries (psql) and already in the PATH
#
# $ echo $(cygpath "C:\cygwin\bin")
# /usr/bin
#
# cygwin # initdb, postgres, and pg_ctl are here "/usr/sbin"
if [ -f "${pgroot}/sbin/postgres" ]
then
  export PATH=${pgroot}/sbin:${PATH}
fi

loginfo "BEGIN verified that PLR has linked to the correct postgreSQL"
loginfo "which psql : $(which psql)"
loginfo "which pg_ctl: $(which pg_ctl)"
loginfo "which initdb: $(which initdb)"
loginfo "which postgres: $(which postgres)"
loginfo "which pg_config: $(which pg_config)"
logok   "pg_config . . ."
pg_config
loginfo "END   verified that PLR has linked to the correct postgreSQL"

pg_ctl -D ${PGDATA} -l logfile start

loginfo "BEGIN plr INSTALLCHECK"
USE_PGXS=1 make installcheck || (cat regression.diffs && false)
loginfo "END plr INSTALLCHECK"

# must stop, else Appveyor job will hang.
pg_ctl -D ${PGDATA} -l logfile stop

# USE_PGXS=1 make clean
# rm -r ${PGDATA}

set +v +x +e
# set +e

logok "END   test_script.sh"
