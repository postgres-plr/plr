### PL/R - PostgreSQL support for R as a procedural language (PL)
[![GitHub license](https://img.shields.io/github/license/postgres-plr/plr.svg?cacheSeconds=2592000)](https://github.com/postgres-plr/plr/blob/master/LICENSE)
[![daily plr](https://github.com/postgres-plr/plr/actions/workflows/schedule.yml/badge.svg)](https://github.com/postgres-plr/plr/actions/workflows/schedule.yml)
[![daily Meson Builds PL/R](https://github.com/postgres-plr/plr/actions/workflows/buildPLRschedule.yml/badge.svg)](https://github.com/postgres-plr/plr/actions/workflows/buildPLRschedule.yml)
[![plr CI](https://github.com/postgres-plr/plr/actions/workflows/build.yml/badge.svg)](https://github.com/postgres-plr/plr/actions/workflows/build.yml)
[![Meson Builds PL/R](https://github.com/postgres-plr/plr/actions/workflows/buildPLR.yml/badge.svg)](https://github.com/postgres-plr/plr/actions/workflows/buildPLR.yml)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/postgres-plr/plr?svg=true)](https://ci.appveyor.com/project/davecramer/plr-daun5 "Get your fresh Windows build here!")
[![Code coverage](https://img.shields.io/codecov/c/github/postgres-plr/plr.svg?logo=codecov&cacheSeconds=2592000)](https://codecov.io/github/postgres-plr/plr)
[![Chat on Slack](https://img.shields.io/badge/Slack-chat-orange.svg?logo=slack&cacheSeconds=2592000)](https://postgresteam.slack.com/messages/CJQUZ1475/ "Join the conversation!")

 Copyright (c) 2003 by Joseph E. Conway ALL RIGHTS RESERVED

 Joe Conway <mail@joeconway.com>

 Based on pltcl by Jan Wieck
 and inspired by REmbeddedPostgres by
 Duncan Temple Lang <duncan@research.bell-labs.com>
 http://www.omegahat.org/RSPostgres/

### License
- GPL V2 see [LICENSE](LICENSE) for details

### Changes
- See [changelog](changelog.md) for release notes for latest docs

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
