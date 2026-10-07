
plr_sources = files(
  'plr.c',
  'pg_conversion.c',
  'pg_backend_support.c',
  'pg_userfuncs.c',
  'pg_rsupport.c',
)

plr_regress = [
  'plr',
  'bad_fun',
  'opt_window',
  'do',
  'out_args',
  'plr_transaction',
  'opt_window_frame',
  'parallel'
]

R_home = get_option('R_HOME')
if R_home == ''
  error('One must supply: -DR_HOME=newvalue')
endif

plr_deps = []
dep_R = dependency('libR')
plr_deps +=  dep_R

is_msvc     = meson.get_compiler('c').get_id() == 'msvc'
is_not_msvc = not is_msvc
#
host_machine_system = host_machine.system()
is_cygwin     = host_machine_system == 'cygwin'
is_not_cygwin = not is_cygwin                     # do not use
#
is_windows    = host_machine_system == 'windows'  # do not use
is_mingw      = is_windows and is_not_cygwin and is_not_msvc # pre-processor variable WIN32 (see NOTE below)
# Non-microsoft, check compiler flags, check ...
#   e.g. "gcc (or clang) -dM -E -xc /dev/null >gcc.txt (or clang.txt)" 
#   e.g.  Cygwin or Mingw(non-clang), and gcc only
#   e.g. "gcc -mwin32 -dM -E -xc /dev/null >gcc-mwin32.txt"
# https://www.cygwin.com/faq.html
# Not exactly, because Microsoft "WIN32" comes from "windows.h", but "close enough" to be useful.
#   Makefiles are not processed by "msvc", but the Makefile "may" or "may not" distinguish Cygwin.
#     PG Makefile does distinguish.
is_win32      = is_mingw or is_msvc             # use OFTEN - much better reliable detection than is_not_linux
is_not_win32  = not is_win32                    # use OFTEN - much better reliable detection than is_linux
#
is_linux      = host_machine_system == 'linux'
is_darwin     = host_machine_system == 'darwin'

plr_incdir = []

if is_mingw
  cygpath = find_program('cygpath', required : true)
  # -m -- mixed mode
  # https://cygwin.com/cygwin-ug-net/cygpath.html
endif

R_incdir = dep_R.get_variable( pkgconfig : 'rincludedir' )
#
# for "mingw", for meson "User defined options" 
#   change "R_incdir" to the "mixed mode" "path form".
if is_mingw
  # mixed mode (-m)
  R_incdir = run_command(cygpath, '-ml', R_incdir, check: true).stdout().strip()
endif
plr_incdir += R_incdir

# postgres meson variable
if host_system == 'windows'
  plr_sources += rc_lib_gen.process(win32ver_rc, extra_args: [
    '--NAME', 'plr',
    '--FILEDESC', 'PL/R - PostgreSQL support for R as a procedural language (PLR)',])
endif

# postgres meson variable - pch_postgres_h
# postgres meson array    - contrib_mod_args
plr = shared_module('plr',
  plr_sources,
  c_pch: pch_postgres_h,
  include_directories: plr_incdir,
  kwargs: contrib_mod_args + {
    'dependencies': [plr_deps, contrib_mod_args['dependencies']]
  },
)

# postgres meson variable
contrib_targets += plr

data = [
  'plr--unpackaged--8.4.8.9.sql',
  'plr--8.3.0.18--8.4.sql',
  'plr--8.4.1--8.4.2.sql',
  'plr--8.4.3--8.4.4.sql',
  'plr--8.4--8.4.1.sql',
  'plr--8.4.2--8.4.3.sql',
  'plr--8.4.4--8.4.5.sql',
  'plr--8.4.5--8.4.6.sql',
  'plr--8.4.6--8.4.7.sql',
  'plr--8.4.7--8.4.8.sql',
  'plr--8.4.8--8.4.8.1.sql',
  'plr--8.4.8.1--8.4.8.2.sql',
  'plr--8.4.8.2--8.4.8.3.sql',
  'plr--8.4.8.3--8.4.8.4.sql',
  'plr--8.4.8.4--8.4.8.5.sql',
  'plr--8.4.8.5--8.4.8.6.sql',
  'plr--8.4.8.6--8.4.8.7.sql',
  'plr--8.4.8.7--8.4.8.8.sql',
  'plr--8.4.8.8--8.4.8.9.sql',
  'plr--8.4.8.9.sql',
  'plr.control'
]

install_data(data, kwargs: contrib_data_args)

tests += {
  'name': 'plr',
  'sd': meson.current_source_dir(),
  'bd': meson.current_build_dir(),
  'regress': {
    'sql': [
      plr_regress
    ],
  },
}