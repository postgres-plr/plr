
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
]

R_home = get_option('R_HOME')
if R_home == ''
  error('One must supply: -DR_HOME=newvalue')
endif

plr_deps = []
dep_R = dependency('libR')
plr_deps +=  dep_R

plr_incdir = []
R_incdir = include_directories(R_home / 'include')
plr_incdir += R_incdir

if host_system == 'windows'
  plr_sources += rc_lib_gen.process(win32ver_rc, extra_args: [
    '--NAME', 'plr',
    '--FILEDESC', 'PL/R - PostgreSQL support for R as a procedural language (PLR)',])
endif

plr = shared_module('plr',
  plr_sources,
  c_pch: pch_postgres_h,
  include_directories: plr_incdir,
  kwargs: contrib_mod_args + {
    'dependencies': [plr_deps, contrib_mod_args['dependencies']]
  },
)

contrib_targets += plr

install_data(
  'plr--unpackaged--8.4.7.sql',
  'plr--8.3.0.18--8.4.sql',
  'plr--8.4.1--8.4.2.sql',
  'plr--8.4.3--8.4.4.sql',
  'plr--8.4--8.4.1.sql',
  'plr--8.4.2--8.4.3.sql',
  'plr--8.4.4--8.4.5.sql',
  'plr--8.4.5--8.4.6.sql',
  'plr--8.4.6--8.4.7.sql',
  'plr--8.4.7.sql',
  'plr.control',
  kwargs: contrib_data_args,
)

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