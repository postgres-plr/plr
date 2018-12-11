### PL/R - PostgreSQL support for R as a procedural language (PL)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/postgres-plr/plr)](https://ci.appveyor.com/project/davecramer/plr-daun5) [![Travis build Status](https://travis-ci.org/postgres-plr/plr.png)](https://travis-ci.org/postgres-plr/plr) [![Code coverage](https://img.shields.io/codecov/c/github/postgres-plr/plr.svg?maxAge=2592000)](https://codecov.io/github/postgres-plr/plr)

 Copyright (c) 2003-2018 by Joseph E. Conway ALL RIGHTS RESERVED

 Joe Conway <mail@joeconway.com>

 Based on pltcl by Jan Wieck
 and inspired by REmbeddedPostgres by
 Duncan Temple Lang <duncan@research.bell-labs.com>
 http://www.omegahat.org/RSPostgres/

### License
- GPL V2 see [LICENSE](LICENSE) for details

### Changes
- See [changelog](CHANGELOG.md) for release notes for latest docs

#### Installation:
- See [installation](userguide.md#installation) for the most up-to-date instructions.

#### Documentation:
- See [userguide](userguide.md) for complete documentation.

### Notes:
 - R headers are required. Download and install R prior to building PL/R.
 - R must have been built with the ```--enable-R-shlib``` option when it was
      configured, in order for the libR shared object library to be available.
 - R_HOME must be defined in the environment of the user under which
      PostgreSQL is started, before the postmaster is started. Otherwise
      PL/R will refuse to load.

-- Joe Conway
