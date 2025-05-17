## Installation <a name='installation'></a>

All of the following presume that you have installed R before starting.
From within R you can find R_HOME with ```R.home(component="home")```

### Redhat/Centos Family

This presumes you installed PostgreSQL using the PGDG repositories found [here](https://www.postgresql.org/download/linux/redhat/)

```bash
yum install plr-nn
```

Where nn is the major version number such as 17 for PostgreSQL version 17.x

To set R_HOME for use by PostgreSQL.

First we need to customize the systemd service

```bash
systemctl edit postgresql-nn.service
```

again where nn is the major version of PostgreSQL installed on the system

Add the following to this file

```
[Service]
Environment=R_HOME=<The location of R_HOME found using R.home(component="home")>
```

Now restart PostgreSQL using

```bash
systemctl restart postgresql-nn
```

### Debian deriviatives

This presumes you installed PostgreSQL using the PGDG repositories found [here](https://www.postgresql.org/download/linux/debian/)

```bash
apt-get install postgresql-nn-plr
```

In the `/etc/postgresql/nn/main` directory there is a file named environment.
Edit this file and add the following:

`R_HOME=<The location of R_HOME found using R.home(component="home")>`

### Compiling from source

If you are going to compile R from the source, then do the following:

```bash
./configure --enable-R-shlib --prefix=/opt/postgres_plr && make && make install
```

If you are going to compile PostgreSQL from the source, use the following commands from the untared
and unzipped file downloaded from [http://www.postgresql.org/ftp/source/](http://www.postgresql.org/ftp/source/):

Place source tar file in the contrib dir in the PostgreSQL source tree and untar it. The shared object for the R
call handler is built and installed in the PostgreSQL library directory via the following commands (starting
from /path/to/postgresql_source/contrib):

```bash
cd plr
make
make install
```
You may explicitly include the path of pg_config to `PATH`, such as

```bash
cd plr
PATH=/usr/pgsql-17/bin/:$PATH; USE_PGXS=1 make
echo "PATH=/usr/pgsql-17/bin/:$PATH; USE_PGXS=1 make install" | sudo sh
```
If you want to use git to pull the repository, run the following command before the make command:

```bash
git clone https://github.com/postgres-plr/plr
```
As of PostgreSQL 8.0.0, PL/R can also be built without the PostgreSQL source tree. Untar PL/R
where ever you prefer. The shared object for the R call handler is built and installed in the PostgreSQL
library directory via the following commands (starting from/path/to/plr):

```bash
cd plr
USE_PGXS=1 make
USE_PGXS=1 make install
```


In MSYS:
```
export R_HOME=/c/progra~1/R/R-4.5.0 
export PATH=$PATH:/c/progra~1/PostgreSQL/17/bin
USE_PGXS=1 make
USE_PGXS=1 make install
```

In Mingw, MSYS, or MSYS2:

If R is built and installed using a sub-architecture, as explained in the section Sub-architectures in
https://cran.r-project.org/doc/manuals/r-release/R-admin.html
for example, in an R
```
R-x.y.z for Windows (32/64 bit) and version 4.1.3 or earlier
R-x.y.z for Windows (64 bit) and version 4.2.0 or later
```
that has been downloaded (and installed) from
[https://cran.r-project.org/bin/windows/base/old/](https://cran.r-project.org/bin/windows/base/old/)

then, include the environment variable R_ARCH.
For example R_ARCH=/x64 (or R_ARCH=/i386 as appropriate):
```
export R_HOME=/c/progra~1/R/R-4.5.0
export PATH=$PATH:/c/progra~1/PostgreSQL/17/bin
export R_ARCH=/x64
USE_PGXS=1 make
USE_PGXS=1 make install
```
```
export R_HOME=/c/progra~1/R/R-4.1.3
export PATH=$PATH:/c/progra~1/PostgreSQL/17/bin
export R_ARCH=/i386
USE_PGXS=1 make
USE_PGXS=1 make install
```
Note, R 4.2.0 and greater is not "single architecture."
It is still "subarchitecture" with only 64bit.
32bit has been removed.

### Compiling from source and using R for Windows 4.3.0 and later

PL/R that uses R for Windows 4.3.0 and later can no longer be compiled using Microsoft Visual Studio.
One may read the following.

Status: CLOSED WONTFIX
[Bug 18544 - private_data_c Visual Studio 2022 R-4.3.0 Complex.h(81,21): syntax error: missing ';' before identifier 'private_data_c'](https://bugs.r-project.org/show_bug.cgi?id=18544)

[The new definition does not work with MSVC compilers because they don't support the C99 _Complex type](https://learn.microsoft.com/en-us/cpp/c-runtime-library/complex-math-support?view=msvc-170)

[C Complex Numbers in C++?](https://stackoverflow.com/questions/10540228/c-complex-numbers-in-c)

Instead, for PL/R that uses R for Windows 4.3.0 and later, compile PL/R with MSYS2(UCRT64 or MINGW32).

### Compiling from source using the meson build system

Needed is the PostgreSQL version 16 or later source code, libR installed, PATH set, and R_HOME set. One passes -DR_HOME=value to the `meson setup` command.

Alternately, needed are the PostgreSQL pre-compiled binaries. PostgreSQL can be a version lower than 16. Also needed are the libR installed, libpq installed, libpostgres configured and installed, PATH set, and R_HOME set.  One passes -DR_HOME=value and -DPG_HOME=value2 to the `meson setup` command.

### Installing from a Pre-Built "plr"

Win32 - adjust paths according to your own setup, and be sure to restart the PostgreSQL service after
changing:

In Windows environment (generally):
```
R_HOME=C:\Progra~1\R\R-4.5.0
Path=%PATH%;%R_HOME%\x64\bin
```

#### Detailed Windows Environment

If wanting to install R 4.2.0 or later on a system older than Windows 10, then the following applies.

In R 4.2.0 or greater, support for 32-bit builds has been dropped.

R 4.2.0 and later uses UTF-8 as the native encoding on recent Windows systems
(at least Windows 10 version 1903, Windows Server 2022 or Windows Server 1903).
As a part of this change, R 4.2.0 and later uses UCRT as the C runtime.
UCRT should be installed manually on systems older than Windows 10 or Windows Server 2016 before installing R.

This is documented at `CHANGES IN R 4.2.0`
https://cran.r-project.org/doc/manuals/r-release/NEWS.html

Acquire UCRT through `Windows Update` or at the following URL query result:
https://www.google.com/search?q=download+UCRT

In a Windows environment, with a PL/R compiled using MSYS2(UCRT64 or MINGW32) or Microsoft Visual Studio
[https://github.com/postgres-plr/plr/releases/latest](https://github.com/postgres-plr/plr/releases/latest), with a PostgreSQL compiled
with Microsoft Visual Studio [https://www.enterprisedb.com/downloads/postgres-postgresql-downloads](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads),
and an R acquired from CRAN [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/) do the following.




#### First:

Download and install PostgreSQL compiled with Microsoft Visual Studio
[https://www.enterprisedb.com/downloads/postgres-postgresql-downloads](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)
For R versions earlier than 4.3.0 Download PL/R compiled using Microsoft Visual Studio
For R versions greather or equal to 4.3.0 Download PL/R compiled using MSYS2 (UCRT64 or MINGW32)
[https://github.com/postgres-plr/plr/releases/latest](https://github.com/postgres-plr/plr/releases/latest)

Unzip the plr.zip file into a folder, that is called the "unzipped folder".
If your installation of PostgreSQL had been installed into "C:\Program Files\PostgreSQL\16",
then from the unzipped PL/R folder, place the following

 * .sql files and the plr.control file, all found in the "share\extension" folder
   into "C:\Program Files\PostgreSQL\16\share\extension" folder.

 * plr.dll file found in the "lib" folder into "C:\Program Files\PostgreSQL\16\lib" folder.



#### Second:

Install R with the feature checked [x] "Save version number in registry"."
See the "Tip" item below.

### Alternately:

Acquire R from the same location
and choose [ ] "Save version number in registry".
At a Command Prompt run (and may have to be an Administrator Command Prompt)
and using wherever your path to R may be, do:
```
setx R_HOME "C:\Program Files\R\R-4.5.0" /M
```
### Optionally:

Acquire R from the same location
and choose [ ] "Save version number in registry".
Choose Control Panel -> System -> advanced system settings -> Environment Variables button.
In the "System variables" area, create the System Variable, called R_HOME.
Give R_HOME the value of the PATH to the R home,
for example (without quotes) "C:\Program Files\R\R-4.5.0".

If you forgot to set the R_HOME environment variable (by any method),
then (eventually) you may get this error:
```postgresql
postgres=# CREATE EXTENSION plr;
CREATE EXTENSION
postgres=# SELECT r_version();
ERROR:  environment variable R_HOME not defined
HINT:  R_HOME must be defined in the environment of the user that starts the postmaster process.
```


### Third:



Put the R.dll in your PATH. This is required, so do the following:
Control Panel -> System -> Advanced System Settings -> Environment Variables button
In the "System variables" area, choose the System Variable, called "Path".
Click on the Edit button.
Add the R.dll folder to the "Path".
For example (without quotes), add "C:\Program Files\R\R-4.5.0\bin\x64" or
or "C:\Program Files\R\R-4.1.3\bin\i386".
If you are running R version 2.11 or earlier on Windows, the R.dll folder is different;
instead of "bin\i386" or "bin\x64", it is "bin".
Note, a 64bit compiled PL/R can only run with a 64bit compiled PostgreSQL.
A 32bit compiled PL/R can only run with a 32bit compiled PostgreSQL.
The last 32bit PostgreSQL was version ten(10) from  [https://www.enterprisedb.com/downloads/postgres-postgresql-downloads](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads).
Of course, you, yourselfm may try to compile a 32bit PostgreSQL using Microsoft Visual Studio.

Note, R 4.2.0 and greater is not "single architecture."
It is still "subarchitecture" with only 64bit.
32bit has been removed.

### Fourth:

Restart the PostgreSQL cluster, do:

At a Command Prompt run (and you may have to be in an Administrator Command Prompt):
Use the service name of whatever service your PostgreSQL is running under.
```
net stop postgresql-x64-17
```
Alternately, do the following:
Control Panel -> Administrative Tools -> Services
Find postgresql-x64-17 (or whatever service your PostgreSQL is running under).
Right click and choose "Stop"

At a Command Prompt run (and you may have to be in an Administrator Command Prompt):
Use the service name of whatever service your PostgreSQL is running under.
```
net start postgresql-x64-17
```
Alternately, do the following:
Control Panel -> Administrative Tools -> Services
Find postgresql-x64-17 (or whatever service your PostgreSQL is running under).
Right click and choose "Start"


**Tip** R headers are required. Download and install R prior to building PL/R. R must have been built
with the `--enable-R-shlib` option when it was configured, in order for the libR shared object library
to be available.

**Tip:** Additionally, libR must be findable by your runtime linker. On Linux, this involves adding an entry
in /etc/ld.so.conf for the location of libR (typically $R_HOME/bin or $R_HOME/lib), and then running
ldconfig. Refer to `man ldconfig` or its equivalent for your system.

**Tip:** R_HOME must be defined in the environment of the user under which PostgreSQL is started,
before the postmaster is started. Otherwise PL/R will refuse to load. See plr_environ(), which allows
examination of the environment available to the PostgreSQL postmaster process.

**Tip:** On the Win32 platform, from a PL/R compiled by Microsoft Visual Studio, and from an R,
installabled by an installer from [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/),
R will consider a registry entry created by the R installer if
it fails to find R_HOME environment variable. If you choose the installer option ‘Save version number in registry’,
as explained in ‘Does R use the Registry?’ at [https://cran.r-project.org/bin/windows/base/rw-FAQ.html](https://cran.r-project.org/bin/windows/base/rw-FAQ.html)
there is no need to set R_HOME on this platform. Be careful removing older version of R as it may take
away InstallPath entry away from HKLM\SOFTWARE\R-core\R a.k.a. Computer\HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R.


### Creating the PLR Extension


As of PostgreSQL 9.1 you can use the new ```CREATE EXTENSION``` command:

```postgresql
CREATE EXTENSION plr;
```

This is not only simple, it has the added advantage of tracking all PL/R installed objects as dependent on
the extension, and therefore they can be removed just as easily if desired:

```postgresql
DROP EXTENSION plr;
```


**Tip** If a language is installed into `template1`, all subsequently created databases will have the
language installed automatically.

**Tip** In addition to the documentation, the plr.out.* files in the plr/expected folder
are a good source of usage examples.
