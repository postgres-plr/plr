
set -v -x -e
# set -e

pwd

# ls -alrt /c/projects/plr
# ls -alrt /c/projects/postgresql

export PGSLNLOCATION=/c/projects/postgresql/pgsql.sln
echo PGSLNLOCATION: $PGSLNLOCATION

# GUID to later delete
export BRACEDGUID=`cat $PGSLNLOCATION | grep '"plr", "plr"' | grep -Po '"{[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+}"$' | grep -Po '{[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+-[0-9A-Z]+}'`

echo From pgsql.sln the extra BRACEDGUID to Remove: $BRACEDGUID
  
# remove GlobalSection(NestedProjects) entry GUID
sed -i "/= $BRACEDGUID/d" $PGSLNLOCATION

# remove entry of Project line (and its GUID) and its EndProject line
sed -i '/"plr", "plr"/,+1d' $PGSLNLOCATION

set +v +x +e
# set +e