#!/bin/bash
set -x -v -e

if [ ! -f "${GITHUB_ENV}" ]; then touch discard.txt; export GITHUB_ENV=discard.txt; fi

# Docs
# resolute (26.04)
# https://wiki.postgresql.org/wiki/Apt
# https://apt.postgresql.org/pub/repos/apt/dists/
# 
# Image available ?
# SEEN OCT 2026
# YAML Label
# ubuntu-26.04
# https://github.com/actions/runner-images
#
# Pre-built PG available?
# SEEN OCT 2026
# https://ftp.postgresql.org/pub/repos/apt/dists/resolute-pgdg/
# file "Packages" Regular expression search - "Package: postgresql-18$"
# https://ftp.postgresql.org/pub/repos/apt/dists/resolute-pgdg/main/binary-amd64/Packages

# Inputs
# PG: Major postgres version
# PG=<major>
# Input examples
# PG=18
export PG="$1"
if [ "${PG}" == "" ]; then echo "Passed variable PG is missing."; exit 99; fi

# Outputs
# PG_HOME PG_PATHS
# PostgreSQL is installed and started
#

# Christoph Berg
# 12:01, 2 April 2026‎ Myon 
# https://wiki.postgresql.org/index.php?title=Apt&oldid=43140
# https://wiki.postgresql.org/wiki/Apt
# non-snapshots
sudo apt-get install -qq curl ca-certificates -y
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
#
. /etc/os-release
sudo tee /etc/apt/sources.list.d/pgdg.sources <<EOF
Types: deb deb-src
URIs: https://apt.postgresql.org/pub/repos/apt
Suites: $VERSION_CODENAME-pgdg
Architectures: $(dpkg --print-architecture)
Components: main
Signed-By: /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc
EOF

cat /etc/apt/sources.list.d/pgdg.sources

# REQUIRED (at least by "non-snapshots")
sudo apt-get update -qq

# check your setup using the apt-cache policy command to see if "200" shows up in the output:
apt-cache policy postgresql-${PG}

sudo apt-get install -qq postgresql-${PG} -y

# On Ubuntu/Debian, the PostgreSQL packaging infrastructure 
# creates the Unix account "postgres" during package installation. 
# The PostgreSQL cluster-management tooling then uses that account as the default cluster owner.
#
# 30 seconds long
# sudo useradd -r -s /bin/bash -m -d /var/lib/postgresql postgres

# on Ubuntu, installing postgresql-${PG} normally creates a default ${PG}/main cluster 
# and starts it automatically
#
# verify
pg_lsclusters

export PG_HOME="/usr/lib/postgresql/${PG}"
echo "PG_HOME=${PG_HOME}" >> ${GITHUB_ENV}
echo "PG_HOME: ${PG_HOME}"

export PG_PATHS="${PG_HOME}/bin"
echo "PG_PATHS=${PG_PATHS}" >> ${GITHUB_ENV}
echo "PG_PATHS: ${PG_PATHS}"

export PATH=${PG_PATHS}:${PATH}
pg_config

sudo apt-get install -qq postgresql-server-dev-${PG} -y

sudo --preserve-env=PATH -u postgres psql -d postgres             -c "\du"
sudo --preserve-env=PATH -u postgres psql -d postgres             -c "\l"

# In a PG database created from an Ubuntu package the user "postgres" is created.
# In a database created from an Ubuntu package, the database "postgres" is created.
# The owner of the database "postgres" database is the user "postgres".

sudo --preserve-env=PATH -u postgres psql -d postgres             -c "CREATE ROLE runner WITH LOGIN SUPERUSER;"
sudo --preserve-env=PATH -u postgres psql -d postgres             -c "CREATE DATABASE runner OWNER runner;"

psql -c "SELECT version();"
psql -c "SELECT current_setting('server_version_num') "server_version_num";"

psql -c "CREATE ROLE root WITH LOGIN SUPERUSER;"
psql -c "CREATE DATABASE root OWNER root;"

if [ -f "discard.txt" ]; then rm discard.txt; fi

