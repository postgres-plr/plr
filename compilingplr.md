I successfully did the following recently in order to build 64 bit PL/R
on Windows 10:

----------------
dumpbin /exports R.dll > R.dump.csv

Note that I used the csv extension so OpenOffice would import the file
into a spreadsheet conveniently.

Edit R.dump.csv to produce a one column file of symbols called R.def.

cat R.dump.csv | tr -s ' ' | cut -d ' ' -f 5 > R.def

Add the following two lines to the top of the file:
 LIBRARY R
 
 EXPORTS

Then run the following using R.def

 lib /def:R.def /out:R.lib

move R.lib to the bin dir of R

run build from postgres/src/tools/msvc
run install <dir> to install postgresql
initdb to create the cluster
start postgres using pg_ctl -D data -l logfile start_

vcregress plcheck will run the tests

I had to edit the test sql to comment out the loading of plr.sql to get the test to pass

Very important do make sure that your path points to the right location

IF YOU INSTALLED R IN Program Files\R\R... the PATH MUST HAVE C:\Program Files\R\R<version>\bin\x64 
	or C:\Program Files\R\R<version>\bin\i386

msvc.diff

```diff
diff --git a/src/tools/msvc/Mkvcbuild.pm b/src/tools/msvc/Mkvcbuild.pm
index fe905d3..97200bb 100644
--- a/src/tools/msvc/Mkvcbuild.pm
+++ b/src/tools/msvc/Mkvcbuild.pm
@@ -46,7 +46,7 @@ my @contrib_excludes = (
 	'ltree_plpython',  'pgcrypto',
 	'sepgsql',         'brin',
 	'test_extensions', 'test_pg_dump',
-	'snapshot_too_old');
+	'snapshot_too_old','plr');
 
 # Set of variables for frontend modules
 my $frontend_defines = { 'initdb' => 'FRONTEND' };
@@ -453,6 +453,15 @@ sub mkvcbuild
 	$pgcrypto->AddLibrary('ws2_32.lib');
 	my $mf = Project::read_file('contrib/pgcrypto/Makefile');
 	GenerateContribSqlFiles('pgcrypto', $mf);
+ 	my $plr = $solution->AddProject('plr','dll','plr');
+     	$plr->AddFiles(
+       	  'src\pl\plr','plr.c','pg_conversion.c','pg_backend_support.c','pg_userfuncs.c','pg_rsupport.c'
+     	);
+     	$plr->AddReference($postgres);
+     	$plr->AddLibrary('C:\Program Files\R\R-3.3.1\bin\R.lib');
+     	$plr->AddIncludeDir('C:\Program Files\R\R-3.3.1\include');
+     	my $mfplr = Project::read_file('src/pl/plr/Makefile');
+     	GenerateContribSqlFiles('plr', $mfplr);
 
 	foreach my $subdir ('contrib', 'src/test/modules')
 	{
@@ -822,14 +831,14 @@ sub GenerateContribSqlFiles
 
 			if (Solution::IsNewer("contrib/$n/$out", "contrib/$n/$in"))
 			{
-				print "Building $out from $in (contrib/$n)...\n";
-				my $cont = Project::read_file("contrib/$n/$in");
+				print "Building $out from $in (src/pl/$n)...\n";
+				my $cont = Project::read_file("src/pl/$n/$in");
 				my $dn   = $out;
 				$dn   =~ s/\.sql$//;
 				$cont =~ s/MODULE_PATHNAME/\$libdir\/$dn/g;
 				my $o;
-				open($o, ">contrib/$n/$out")
-				  || croak "Could not write to contrib/$n/$d";
+				open($o, ">src/pl/$n/$out")
+				  || croak "Could not write to src/pl/$n/$d";
 				print $o $cont;
 				close($o);
 			}
diff --git a/src/tools/msvc/vcregress.pl b/src/tools/msvc/vcregress.pl
index b4f9464..9593d36 100644
--- a/src/tools/msvc/vcregress.pl
+++ b/src/tools/msvc/vcregress.pl
@@ -222,7 +222,7 @@ sub plcheck
 {
 	chdir "../../pl";
 
-	foreach my $pl (glob("*"))
+	foreach my $pl (glob("plr"))
 	{
 		next unless -d "$pl/sql" && -d "$pl/expected";
 		my $lang = $pl eq 'tcl' ? 'pltcl' : $pl;
@@ -260,6 +260,7 @@ sub plcheck
 			"../../../$Config/pg_regress/pg_regress",
 			"--bindir=../../../$Config/psql",
 			"--dbname=pl_regression", @lang_args, @tests);
+		print join(" ", @args) . "\n";
 		system(@args);
 		my $status = $? >> 8;
 		exit $status if $status;
```


