# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [8.5]
### Added
- Accept composite argument type. [@ikasou](https://github.com/ikasou)

### Changed
- R can pass to PG arrays of any dimensions.
- Major duplicate code removal in R to PG conversion.

## [8.4] - 2019-05-28
### Fixed
- pg12 deprecated setting the hash function directly, pg13 removed it. This was fixed
- wrap functions in {} for validation only fixes issue #65

### Added
- PostgreSQL 12 support. [@davecramer](https://github.com/davecramer)
- Inline language handler and basic syntax checking validator.
- Multiple OUT arguments / return RECORD.
- pg.throwlog & pg.throwwarning (#9).
- AppVeyor build artifacts & CodeCov coverage.

### Changed
- No need for R_HOME on Windows (provided registry setting is correct).
- Special case optimization for window functions with unbounded frame (#18).
- User guide and changelog converted to Markdown.
- Streamline arguments list building in plr_convertargs.
- throw_pg_notice renamed to throw_pg_log that takes level as well.
- Checked whether argument converts to float successfully, use NaN
  otherwise. Affects PostgreSQL < 11 on Windows (platform toolset v120
  and below).
- REALSXP vector/array to numeric[] conversion.

### Removed
- SGML docs.

### Fixed
- Safeguard function body parsing to prevent possible backend crash.
- r_typenames() tolerates non-canonical table names.

#### CHANGE LOG: 8.3.0.17 TO 8.3.0.18
- Internal code changes to accommodate PostgreSQL V11 internal API Changes

#### CHANGE LOG: 8.3.0.16 TO 8.3.0.17
- no changes release simply to add binaries

#### CHANGE LOG: 8.3.0.15 TO 8.3.0.16
- Update for PostgreSQL 9.5 dev compatibility
- Update copyrights
- Add check and throw an error when don't have an expectedDesc.
- Remove autocommit setting -- it has been removed in PostgreSQL 9.5, and it has been ineffective for a long time. Reported by Peter E.
- Fix RPM spec file

#### CHANGE LOG: 8.3.0.14 TO 8.3.0.15
- Update for PostgreSQL 9.3 compatibility
- Ensure certain errors in R code do not crash postgres
- Unbreak compilation with older versions of postgres not having rangetypes
- Allow use of OUT parameters

#### CHANGE LOG: 8.3.0.13.1 TO 8.3.0.14
- Update copyright for 2013
- Remove hack to take signal back from R interpreter (Mark Kirkwood)
- Set R_SignalHandlers = 0, the proper way to prevent R from taking signals in the first place (Mark Kirkwood)
- Adjust RPM spec file
- As of pg9.2 the syntax "LANGUAGE 'C'" no longer works. Use "LANGUAGE C" instead.
- The MacPorts installation has the header filed distributed across two different directories, so there is no single "rincludedir" to query from pkg-config. Instead, do it the proper way and ask pkg-config for the cflags, which should work for all installation variants. (Peter Eisentraut)

#### CHANGE LOG: 8.3.0.13 TO 8.3.0.13.1
- Fix CREATE FUNCTION statements so that they work with PostgreSQL 9.2.x

#### CHANGE LOG: 8.3.0.12 TO 8.3.0.13
- Fix Makefile so that msvc scripts can process it successfully
- Add support for pgsql 9.1 CREATE EXTENSION
- Put in safeguard to prevent attempted return of non-data (e.g. closure) types from R unless the pg return type is BYTEA
- Correct thinko from earlier pass-by-val array optimization
- Fix crashbug related to conversion of R data.frame to Postgres array on function return
- Add plr_version() function: outputs a version string
- New feature: allow PL/R functions to be declared and used as WINDOW functions
- Minor fixes for compiler warnings by updated gcc
- Fix missing calls to UNPROTECT. Report and patch by Ben Leiting.
- Take SIGINT back into Postgres control from R. Report and test case by Terry Schmitt.
- Don't try to free an array element value when the array element is NULL
- Allow pg.spi.prepare/pg.spi.execp to use parameters which are 1D arrays

#### CHANGE LOG: 8.3.0.11 TO 8.3.0.12
- Fix Windows only, latent crashbug. Only actually crashes on new Win64 port, but only by luck

#### CHANGE LOG: 8.3.0.10 TO 8.3.0.11
- Minor improvements to how/when SPI is connected which reduces unnecessary memory context switching/thrashing
- Special case array marshaling, in and out, for int4 and float8 arrays if certain conditions are met. This results in dramatic performance improvement when, for example, passing very large float8 arrays on a 64 bit machine from pg to R.
- Fix crashbug where array datum is NULL under certain circumstances
- Fix failure under recursive SPI calls
- Fix crashbug where error message used dangling pointer
- Add plr.spec thanks to Tom Payne. Based on CentOS 5.5, but builds fine on Fedora 13.
- silence compiler warning

#### CHANGE LOG: 8.3.0.9 TO 8.3.0.10
- Fixed array data type columns incorrectly converted when part of a return tuple
- Ensure input datum gets detoasted prior to copying to R object for bytea inputs

#### CHANGE LOG: 8.3.0.8 TO 8.3.0.9
- Make PL/R compile under MSVC to produce usable win32 binaries
- Updated copyright notices for 2010
- Remove obsolete info from README and point to web site instead
- Consolidate and reorder all header files in order to avoid namespace conflicts between postgres/R/Win32
- Rather than referencing pkglib_path and Dynamic_library_path, reference my_exec_path instead. This is because the former are not exported in win32 and the latter is. Instead get Dynamic_library_path by calling GetConfigOptionByName() and pkglib_path by calling get_pkglib_path().
- Recognize hex input since bytea output is formatted that way by default starting with PostgreSQL 9.0
- Avoid dynamic assignments with array constructors since MSVC cannot handle them.
- Workaround fact that "char **environ" is not available on win32 for
plr_environ()

#### CHANGE LOG: 8.3.0.7 TO 8.3.0.8

#### CHANGE LOG: 8.2.0.9 TO 8.2.0.10
- Makefile fix for Mac OSX per kostas savvidis
- Added RPostgreSQL compatability functions
- Added ability to send serialized R objects to Postgres as bytea return values
- Added ability to convert bytea arguments from Postgres back into the original R object
- Added function to unserialize bytea value in order to restore object outside of R (useful for image data)
- Work on this release was carried out in collaboration with the Chief Information Officer Branch, Treasury Board Secretariat, of the Canadian Government

#### CHANGE LOG: 8.3.0.6 TO 8.3.0.7

#### CHANGE LOG: 8.2.0.8 TO 8.2.0.9

#### CHANGE LOG: 0.6.2.9 TO 0.6.2.10
- Fixed "Rdevices.h" not found error related to R-2.8.x
- Fixed crashbug reported by Jeff Hamann. When a data frame had a factor column with a value in the first row, but NA in a subsequent row, a non-trapped R error would cause a segfault (PL/R's bug, not R)
- Corrected Makefile for use on Gentoo per Ian Stakenvicius
- Add facility to create pdf version of docs

#### CHANGE LOG: 8.3.0.5-BETA TO 8.3.0.6

#### CHANGE LOG: 8.2.0.7 TO 8.2.0.8

#### CHANGE LOG: 0.6.2.8 TO 0.6.2.9
- Fix Makefile for include directory names with embedded spaces
- Eliminate warnings that started with R-2.6.0 related to lack of const declarations
- Add --no-restore to startup options
- Fix old bug related to Rversion.h appearing after user of R_VERSION in precompiler tests. Led to Rembedded.h not getting included
- Added explicit define for KillAllDevices as it has been removed from Rdevices.h as of R-2.7.0

#### CHANGE LOG: 8.3.0.4-BETA TO 8.3.0.5-BETA

#### CHANGE LOG: 8.2.0.6 TO 8.2.0.7

#### CHANGE LOG: 0.6.2.7 TO 0.6.2.8
- fix for non-portable use of setenv

#### CHANGE LOG: 8.3.0.3-BETA TO 8.3.0.4-BETA

#### CHANGE LOG: 8.2.0.5 TO 8.2.0.6

#### CHANGE LOG: 0.6.2.6 TO 0.6.2.7
- If R_HOME environment variable is not defined, attempt to find it using pkg-config. (idea from Dirk Eddelbuettel)
- In any case, create define for default R_HOME based on pkg-config. Use the default R_HOME during R interpreter init if the environment variable is unset. (idea from Dirk Eddelbuettel)
- Use PGdlLIMPORT instead of dlLIMPORT if it is defined.
- Switch to Rf_isVectorList instead of IS_LIST for spi_execp argument test. Prior to R-2.4.0, the latter allows bad arguments to get past, causing a segfault in an R internal type coersion function. (found by Steve Singer)
- New spi cursor manipulation functions (patch courtesy of Steve Singer).
- Force R interpreter non-interactive mode. Fixes some cases that previously appeared to be hung postgres backends in certain errors occured in R (R was actually waiting for user input). On some platforms this situation caused segfaults instead. (found by Jie Zhang)
- When a plr function source is empty, plr tries to find a function by the same name within the R interpreter environment. If the function could not be found, it would cause a hang or segfault. This was not easily trapped in the R interpreter. Now, build and compile the equivalent plr source. This allows the R interpreter to trap the error properly when the function does not exist. (found by Jie Zhang)
- PG_VERSION_NUM if available. (patch courtesy of Neal Conway)
- Plug memory leak in POP_PLERRCONTEXT. (patch courtesy of Steve Singer)

#### CHANGE LOG: 8.3.0.2-BETA TO 8.3.0.3-BETA

#### CHANGE LOG: 8.2.0.4 TO 8.2.0.5

#### CHANGE LOG: 0.6.2.5 TO 0.6.2.6
- modify Makefile so that the build works on win32 without workarounds
- strip or replace embedded carriage returns to prevent R engine syntax errors
- Win32 Binaries and installers courtesy of Mike Leahy

#### CHANGE LOG: 8.3.0.1-BETA TO 8.3.0.2-BETA

#### CHANGE LOG: 8.2.0.3 TO 8.2.0.4

#### CHANGE LOG: 0.6.2.4 TO 0.6.2.5
- add dlLIMPORT to Dynamic_library_path declaration for Win32 support (thanks to Mike Leahy for the critical clues)
- add pkglib_path[] declaration for Win32 support
- modify debug code for PROTECT/UNPROTECT
- add missing UNPROTECT(1) in spi code -- fix for "stack imbalance" warning
- see the docs for notes on Windows installation.

#### CHANGE LOG: 8.3.0-BETA TO 8.3.0.1-BETA

#### CHANGE LOG: 8.2.0.2 TO 8.2.0.3

#### CHANGE LOG: 0.6.2.3 TO 0.6.2.4
- fix crash related to mishandling of R parse errors; thanks to Steve Singer for report and test case

#### CHANGE LOG: 8.2.0.1-BETA TO 8.3.0-BETA
- preserve callers memory context rather than assuming query memory context
- register plr_atexit using atexit() so that when R interpreter exit()'s on failure to initialize (e.g. if R_HOME is incorrect) we throw an error instead of killing the postgres backend unexpectedly
- fix crash related to HeapTupleHeaderGetCmin() no longer working as before
- replace call to R function lcons() with explicit call to Rf_lcons() since postgres also has an lcons() function (Neil Conway)
- use PG_DETOAST_DATUM() on array arguments to ensure they get detoasted if needed
- R and Postgres attempt to define symbols with the same name in their header files. Change to workaround alternative that is less of a kludge (Neil Conway)
- fix for R_VERSION >= 2.5.0, R_ParseVector has extra arguments

#### CHANGE LOG: 8.2.0.1-BETA TO 8.2.0.2
- preserve callers memory context rather than assuming query memory context
- register plr_atexit using atexit() so that when R interpreter exit()'s on failure to initialize (e.g. if R_HOME is incorrect) we throw an error instead of killing the postgres backend unexpectedly
- replace call to R function lcons() with explicit call to Rf_lcons() since postgres also has an lcons() function (Neil Conway)
- use PG_DETOAST_DATUM() on array arguments to ensure they get detoasted if needed
- R and Postgres attempt to define symbols with the same name in their header files. Change to workaround alternative that is less of a kludge (Neil Conway)
- fix for R_VERSION >= 2.5.0, R_ParseVector has extra arguments

#### CHANGE LOG: 0.6.2.2-ALPHA TO 0.6.2.3
- preserve callers memory context rather than assuming query memory context
- register plr_atexit using atexit() so that when R interpreter exit()'s on failure to initialize (e.g. if R_HOME is incorrect) we throw an error instead of killing the postgres backend unexpectedly
- replace call to R function lcons() with explicit call to Rf_lcons() since postgres also has an lcons() function (Neil Conway)
- use PG_DETOAST_DATUM() on array arguments to ensure they get detoasted if needed
- fix for R_VERSION >= 2.5.0, R_ParseVector has extra arguments

#### CHANGE LOG: 8.2.0-BETA TO 8.2.0.1-BETA
*Security related fix (thanks to Jeffrey R. Greco):*
- plr_modules table must now exist in the same schema as the language handler of the first executing PL/R function
- added to install script: REVOKE EXECUTE ON FUNCTION install_rcmd (text) FROM PUBLIC

#### CHANGE LOG: 0.6.2.1-ALPHA TO 0.6.2.2-ALPHA
*Security related fix (thanks to Jeffrey R. Greco):*
- plr_modules table must now exist in the same schema as the language handler of the first executing PL/R function
- added to install script: REVOKE EXECUTE ON FUNCTION install_rcmd (text) FROM PUBLIC

#### CHANGE LOG: 0.6.2-ALPHA TO 8.2.0-BETA
*Update:*
- Modify to work properly with PostgreSQL 8.2 (soon-to-be-beta) and R 2.3.x.
- Support for previous versions of PostgreSQL removed. From this point forward PL/R releases will be kept in sync with PostgreSQL major releases
- Added support for NULL array elements
Security related fix (thanks to Jeffrey R. Greco):
- plr_modules table must now exist in the same schema as the executing PL/R function

#### CHANGE LOG: 0.6.2-ALPHA TO 0.6.2.1-ALPHA
- Security related fix (thanks to Jeffrey R. Greco):
  - plr_modules table must now exist in the same schema as the executing PL/R function

#### CHANGE LOG: 0.6.1-ALPHA TO 0.6.2-ALPHA
*Update:*
- Modify to work properly with PostgreSQL 8.1beta and R 2.1.x.
*Bug fixes:*
- Adjust makefiles to ensure PKGLIBDIR and dlSUFFIX are defined to non-empty strings before trying to use them.
- Fix crash bug when plr.so could not be found by expand_dynamic_library_name().
- Add missing include for "utils/memutils.h".
- Fix problem of $libdir not being found on pgxs builds.
- Eliminate installcheck override warning.

#### CHANGE LOG: 0.6.0B-ALPHA TO 0.6.1-ALPHA
*Update:*
- Modify to work properly with PostgreSQL 8.0.0 and R 2.0.x.
*Bug fixes:*
- Initialize flinfo struct properly
- Fix improper casting of factor levels to integers. Original works fine on 32 bit Intel systems, but causes compiler warnings and segfaults on 64 bit systems.
- Added PGXS makefile
- Fix resource leak -- one PROTECT() was missing its compliment UNPROTECT in pg_conversion.

#### CHANGE LOG: 0.6.0-ALPHA TO 0.6.0B-ALPHA
*Packaging fix:*
- Package now untars to ./plr instead of ./plr-0.6.0, allowing `make installcheck` to work properly.

#### CHANGE LOG: 0.5.4-ALPHA TO 0.6.0-ALPHA
*Bug fixes:*
- Handle dropped columns correctly.
- Adjust Makefile for dylib suffix expected on libR on Mac OS X machines.
- Transform '_' to '.' in data.frame column names derived from Postgres tuples for R < 1.9.0.
*Enhancements:*
- Several adjustments to stay current with Postgres 7.5 and R-1.9.0.
- Add support for explicit argument names (requires Postgres 7.5devel).
*Documentation:*
- Update sgml to DocBook V4.2.
- Add tip regarding /etc/ld.so.conf & ldconfig.
- Mention explicit argument support.
- Correct instances of "returns record" to "returns setof record".
- Add mention of load_r_typenames() (was missing entirely).

#### CHANGE LOG: 0.5.3-ALPHA TO 0.5.4-ALPHA
*Bug fixes:*
- Added additional R interpreter clean shutdown actions.

#### CHANGE LOG: 0.5.2-ALPHA TO 0.5.3-ALPHA
*Bug fixes:*
- Detect R version. Starting with R version 1.8.0 eliminate the need to use declarations from non-exported R headers.

#### CHANGE LOG: 0.5.1-ALPHA TO 0.5.2-ALPHA
*Bug fixes:*
- Fix portability issue when compiling for pg7.3 with older gcc versions.
Documentation:
- Document pg.state.firstpass

#### CHANGE LOG: 0.5.0-ALPHA TO 0.5.1-ALPHA
*Bug fixes:*
- Fix crash bug -- if ERROR occurred during SQL call, e.g. while using pg.spi.exec, R never got the chance to clean up properly. In some cases this would lead to a crash. Now sections that might possibly generate elog/ereports beneath plr's control while executing code called from the R interpreter are wrapped in "if (sigsetjmp(Warn_restart...". This grabs back control before it is returned to the postmaster, and allows us to call R's "error()" function. Now we can allow the R interpreter to gracefully clean up and exit with an error flagged. On the other side of the R eval call, we grab the error flag, and generate another error.
- Fix for Rtmp[pid] directories left unremoved on backend exit -- add an exit callback using Postgres on_proc_exit() function. The callback function then calls Rstd_CleanUp().
- Match change to PL/pgSQL by Tom Lane. When compiling a plr trigger function, include the OID of the table the trigger is attached to in the hashkey. This ensures that we will create separate compiled trees for each table the trigger is used with, avoiding possible datatype-mismatch problems if the tables have different rowtypes.
- Minor documentation improvments

#### CHANGE LOG: 0.4.5-ALPHA TO 0.5.0-ALPHA
Author's Note: This release is probably the last alpha release. With the addition of trigger support, I think PL/R is (nearly?) feature complete. Note that there are some significant changes to semantics with respect to NULLs and NAs in this release.
I'm very interested in feedback -- please find my email address in README.plr to report bugs, obvious omissions, etc. I'd also be interested in hearing how PL/R is being used.
Enhancements:
- Added trigger support, and corresponding documentation and regression test support
- Adapted error reporting to new PostgreSQL 7.4 style, including error codes and nested contexts
- Backported PostgreSQL 7.4 backend error reporting functions and enabled when building against Postgres 7.3
- Modified compiled function caching to uniquely cache polymorphic functions based on runtime argument types
Behavior changes/Bug fixes:
- Fix behavior of empty vector return values when pg return type is a pg array. Did return NULL; now returns empty pg array of correct data type.
- Fix behavior of NULL arguments for Postgres scalars and arrays. Did produce a single element vector with the element value of NA. Now produces a true R NULL object instead.
- Fix behavior of NULL fields in Postgres composite types used as arguments. Now produces R object with NA in the corresponding column position.
- Fix behavior when returning R data.frames or matrixes as Postgres composite types. Now correctly converts R "NA" values to Postgres "NULL" values in the result set.
- Minor adjustment of returning of empty arrays; fix case of empty multidimensional arrays and data.frames
- Adjust to change in call interface of get_fn_expr_rettype and get_fn_expr_argtype in PostgreSQL 7.4devel.
- Changes needed to fix compilation under Postgres 7.3.
- Now have two regression expected files -- one for 7.3 and one for 7.4.
- Remove dims and dimnames attribute from data.frames created by pg_tuple_get_r_frame(). This fixes a problem that lm() was having with plr created data.frames, and appears to be correct based on the docs and data.frames created by R itself (examined using dput()).
- Remove the preloaded TYPEOIDS and provide instead a new function, load_r_typenames(), that provides the same global variables in the R interpreter. But instead of making *every* connection pay the price, now it can be used on demand only when needed.
- Reworked initialization functions -- now use plr_init when using the postgresql.conf preload_libraries parameter
- Fixed problem with plr_SPI_context global not handling reentrancy correctly, leading to crash when throw_pg_notice was called from a nested plr function.
 LOG: 0.4.4-ALPHA TO 0.4.5-ALPHA
*Bug fixes:*
- Adjust to a change in the call interface of get_fn_expr_rettype() and get_fn_expr_argtype in PostgreSQL 7.4devel.

#### CHANGE LOG: 0.4.2-ALPHA TO 0.4.4-ALPHA
*Bug fixes:*
- Changed declaration of environ to something (hopefully) more portable
Documentation:
- Fixed synchronization of actual function names with those in the text/examples.

#### CHANGE LOG: 0.4.0-ALPHA TO 0.4.2-ALPHA
*Enhancements:*
- Remove the --gui=none argument from the embedded interpreter initialization. This allows use of a graphics device such as jpeg, so that charts can be rendered and spooled to disk for, e.g., pickup by a PHP script.
*Bug fixes:*
- Add missing include (exposed by recent Postgres 7.4devel change)

#### CHANGE LOG: 0.3.1-ALPHA TO 0.4.0-ALPHA
*Enhancements:*
- Added support for Postgres 7.4 polymorphic array types as arguments and return types
- Added function reload_plr_modules to reload plr_modules after a change
- Added function plr_environ to display environment variables
*Bug fixes:*
- Fix crashbug in load_r_cmd affecting functions loaded via plr_modules and install_rcmd()
Documentation:
- Updated installation notes for R 1.7.0 and Red Hat 9
- Updated PostgreSQL Support Functions with new functions reload_plr_modules and plr_environ
- Updated PostgreSQL Support Functions: existing array* function names changed to plr_array* to avoid conflict with PostgreSQL 7.4devel built in functions

#### CHANGE LOG: 0.3.0-ALPHA TO 0.3.1-ALPHA
*Bug fixes:*
- Minor change to regression test
Documentation:
- Note passage of regression test under PostgreSQL 7.4devel and R 1.7devel

#### CHANGE LOG: 0.1.0-ALPHA TO 0.3.0-ALPHA
*Enhancements:*
- Added case to allow returning setof scalar datatype -- until now, had to use record or define one column tuple type.
- Added support for 3D PostgreSQL arrays as input arguments to PL/R functions.
- Added support for returning 3D arrays. Specifically, if the R return value is a 3D array, and the PL/R function is declared to return an array type, the returned array will also be 3D.
- Change start_interp from static to extern so that it can be called by the Postmaster during startup. This allows PL/R and R itself to be loaded and initialized before backends are forked, saving the startup time for each backend.
*Bug fixes:*
- Check for R_HOME defined in the environment and refuse to start if it isn't. If we don't, R will, and when it unexpectedly exits, we segfault.
- Fix bug that allowed function returning record or tupletype, but not setof, to return all the rows instead of just one.
- Fix bug that allowed function returning tuptype in targetlist to crash instead of just complaining about bad context.
- Fix crash bug -- trap NULL msg pointer passed to throw_pg_notice(and error).
- Fix bug: integer argument with value = 0 was converted to NA in R. Now appropriately passes the 0 value as-is.
*Documentation:*
- Adjust return type mapping table for "setof" scalar and composite.
- Crossref module install with global data section.
- Document '' (that is, empty string) used as function body if PostgreSQL and R function names match.
- Added tip regarding setting R_HOME for postgres user before starting the postmaster.
- Improve docs by moving "overview" to first, and renaming and improving old "intro", new "install" chapter.
- References to arg[] changed to _arg and tip added.
- Updated documentation for 3D array support.

[Unreleased]: https://github.com/postgres-plr/plr/compare/REL8_4..HEAD
[8.4]: https://github.com/postgres-plr/plr/compare/REL8_3_0_18...REL8_4
