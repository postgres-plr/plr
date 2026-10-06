#!/bin/bash
set -x -v -e

if [ -f "/etc/init.d/postgresql" ]
then
  sudo /etc/init.d/postgresql stop
fi

sudo apt-get remove -qq --purge postgresql\* -y
sudo rm -Rf /etc/postgresql /var/lib/postgresql

if [ $(id postgres >/dev/null 2>&1 && echo 0) ]
then 
  sudo deluser --remove-home postgres
fi

# dpkg -S /usr/bin/pg_config
#   libpq-dev: /usr/bin/pg_config
sudo apt-get remove -qq --purge libpq\* -y

# Additionally, you will likely need to define a higher "pinning" priority 
#  as otherwise the versions of the packages provided 
#   by the operating system would be preferred (SEEN AUG 2026)
# https://wiki.postgresql.org/wiki/Apt/FAQ#Development_snapshots

sudo touch     /etc/apt/preferences.d/pgdg.pref
sudo chmod 777 /etc/apt/preferences.d/pgdg.pref
echo "
Package: *
Pin: release o=apt.postgresql.org
Pin-Priority: 800
" >> /etc/apt/preferences.d/pgdg.pref

cat /etc/apt/preferences.d/pgdg.pref
