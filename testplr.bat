cd c:\projects\postgresql\src\tools\msvc
perl install.pl c:\pgsql
pushd c:\pgsql
bin\initdb -D data
bin\pg_ctl -D data -l logfile start
popd
pushd c:\projects\postgresql\src\pl\plr
cp plr.control c:\pgsql\share\extension
cp plr--8.3.0.17.sql c:\pgsql\share\extension
..\..\..\Release\pg_regress\pg_regress --bindir=c:\pgsql\bin --dbname=pl_regression plr


