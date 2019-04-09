/* plr/plr--unpackaged--8.4.sql */

ALTER EXTENSION plr ADD type plr_environ_type;
ALTER EXTENSION plr ADD type r_typename;
ALTER EXTENSION plr ADD type r_version_type;

ALTER EXTENSION plr ADD function plr_call_handler();
ALTER EXTENSION plr ADD function plr_inline_handler(internal);
ALTER EXTENSION plr ADD function plr_version();
ALTER EXTENSION plr ADD function reload_plr_modules();
ALTER EXTENSION plr ADD function install_rcmd(text);
ALTER EXTENSION plr ADD function plr_singleton_array (float8);
ALTER EXTENSION plr ADD function plr_array_push (_float8, float8);
ALTER EXTENSION plr ADD function plr_array_accum (_float8, float8);
ALTER EXTENSION plr ADD function plr_environ ();
ALTER EXTENSION plr ADD function r_typenames();
ALTER EXTENSION plr ADD function load_r_typenames();
ALTER EXTENSION plr ADD function r_version();
ALTER EXTENSION plr ADD function plr_set_rhome (text);
ALTER EXTENSION plr ADD function plr_unset_rhome ();
ALTER EXTENSION plr ADD function plr_set_display (text);
ALTER EXTENSION plr ADD function plr_get_raw (bytea);

ALTER EXTENSION plr ADD LANGUAGE plr;