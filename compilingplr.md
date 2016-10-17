I successfully did the following recently in order to build 64 bit PL/R
on Windows 7:

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


cd ../../../contrib/plr
"../../Release/pg_regress/pg_regress" --psqldir="../../Release/psql" --dbname=contrib_regression plr


msvc.diff

```diff
diff -cNr msvc.orig/config.pl msvc/config.pl
*** msvc.orig/config.pl	1969-12-31 16:00:00.000000000 -0800
--- msvc/config.pl	2011-08-26 09:24:56.734375000 -0700
***************
*** 0 ****
--- 1,27 ----
+ # Configuration arguments for vcbuild.
+ use strict;
+ use warnings;
+ 
+ our $config = {
+     asserts=>0,			# --enable-cassert
+     # integer_datetimes=>1,   # --enable-integer-datetimes - on is now default
+     # float4byval=>1,         # --disable-float4-byval, on by default
+     # float8byval=>0,         # --disable-float8-byval, off by default
+     # blocksize => 8,         # --with-blocksize, 8kB by default
+     # wal_blocksize => 8,     # --with-wal-blocksize, 8kb by default
+     # wal_segsize => 16,      # --with-wal-segsize, 16MB by default
+     ldap=>1,				# --with-ldap
+     nls=>undef,				# --enable-nls=<path>
+     tcl=>undef,				# --with-tls=<path>
+     perl=>undef, 			# --with-perl
+     python=>undef,			# --with-python=<path>
+     krb5=>undef,			# --with-krb5=<path>
+     openssl=>undef,			# --with-ssl=<path>
+     uuid=>undef,			# --with-ossp-uuid
+     xml=>undef,				# --with-libxml=<path>
+     xslt=>undef,			# --with-libxslt=<path>
+     iconv=>undef,			# (not in configure, path to iconv)
+     zlib=>undef				# --with-zlib=<path>
+ };
+ 
+ 1;
diff -cNr msvc.orig/Mkvcbuild.pm msvc/Mkvcbuild.pm
*** msvc.orig/Mkvcbuild.pm	2010-07-02 16:25:27.000000000 -0700
--- msvc/Mkvcbuild.pm	2011-08-26 13:08:41.796875000 -0700
***************
*** 35,41 ****
      'cube' => ['cubescan.l','cubeparse.y'],
      'seg' => ['segscan.l','segparse.y']
  };
! my @contrib_excludes = ('pgcrypto','intagg','sepgsql');
  
  sub mkvcbuild
  {
--- 35,41 ----
      'cube' => ['cubescan.l','cubeparse.y'],
      'seg' => ['segscan.l','segparse.y']
  };
! my @contrib_excludes = ('pgcrypto','intagg','sepgsql','plr');
  
  sub mkvcbuild
  {
***************
*** 377,382 ****
--- 377,392 ----
      my $mf = Project::read_file('contrib/pgcrypto/Makefile');
      GenerateContribSqlFiles('pgcrypto', $mf);
  
+     my $plr = $solution->AddProject('plr','dll','plr');
+     $plr->AddFiles(
+         'contrib\plr','plr.c','pg_conversion.c','pg_backend_support.c','pg_userfuncs.c','pg_rsupport.c'
+     );
+     $plr->AddReference($postgres);
+     $plr->AddLibrary('C:\R\R-2.13.1\bin\R.lib');
+     $plr->AddIncludeDir('C:\R\R-2.13.1\include');
+     my $mfplr = Project::read_file('contrib/plr/Makefile');
+     GenerateContribSqlFiles('plr', $mfplr);
+ 
      my $D;
      opendir($D, 'contrib') || croak "Could not opendir on contrib!\n";
      while (my $d = readdir($D))
***************
*** 596,601 ****
--- 606,619 ----
              }
          }
      }
+ 	else
+ 	{
+ 		print "GenerateContribSqlFiles skipping $n\n";
+ 		if ($n eq 'plr')
+ 		{
+ 			print "mf: $mf\n";
+ 		}
+ 	}
  }
  
  sub AdjustContribProj
diff -cNr msvc.orig/Solution.pm msvc/Solution.pm
*** msvc.orig/Solution.pm	2010-04-09 06:05:58.000000000 -0700
--- msvc/Solution.pm	2010-10-04 10:54:52.507549000 -0700
***************
*** 443,448 ****
--- 443,449 ----
          $proj->AddIncludeDir($self->{options}->{xslt} . '\include');
          $proj->AddLibrary($self->{options}->{xslt} . '\lib\libxslt.lib');
      }
+ 	$proj->AddIncludeDir('C:\Program Files\Microsoft Platform SDK\Include');
      return $proj;
  }
  
diff -cNr msvc.orig/vcregress.pl msvc/vcregress.pl
*** msvc.orig/vcreg   }
          }
      }
+ 	else
+ 	{
+ 		print "ress.pl	2010-04-09 06:05:58.000000000 -0700
--- msvc/vcregress.pl	2011-08-26 13:32:32.593750000 -0700
***************
*** 184,190 ****
  {
      chdir "../../../contrib";
      my $mstat = 0;
!     foreach my $module (glob("*"))
      {
          next if ($module eq 'xml2' && !$config->{xml});
          next
--- 184,190 ----
  {
      chdir "../../../contrib";
      my $mstat = 0;
!     foreach my $module (glob("plr"))
      {
          next if ($module eq 'xml2' && !$config->{xml});
          next
***************
*** 201,206 ****
--- 201,207 ----
              "--psqldir=../../$Config/psql",
              "--dbname=contrib_regression",@opts,@tests
          );
+ 		print join(" ", @args) . "\n";
          system(@args);
          my $status = $? >> 8;
          $mstat ||=   }
          }
      }
+ 	else
+ 	{
+ 		print " $status;
```


