%define pkgdocdir %(pg_config --docdir)
%define pkglibdir %(pg_config --pkglibdir)
%define pkgsharedir %(pg_config --sharedir)
Summary:	A loadable procedural language that enables you to write PostgreSQL functions and triggers in the R programming language.
Name:		plr
Version:	8.3.0.18
Release:	1%{?dist}
License:	BSD
Group:		Applications/Databases
Source:		http://www.joeconway.com/plr/plr-%{version}.tar.gz
URL:		http://www.joeconway.com/plr.html
BuildRequires:	postgresql-devel >= 8.3
BuildRequires:	R-devel
Requires:	postgresql-server >= 8.3
Requires:	R
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
PL/R is a loadable procedural language that enables you to write PostgreSQL
functions and triggers in the R programming language. PL/R offers most (if not
all) of the capabilities a function writer has in the R language.

Commands are available to access the database via the PostgreSQL Server
Programming Interface (SPI) and to raise messages via elog() . There is no way
to access internals of the database backend. However the user is able to gain
OS-level access under the permissions of the PostgreSQL user ID, as with a C
function. Thus, any unprivileged database user should not be permitted to use
this language. It must be installed as an untrusted procedural language so that
only database superusers can create functions in it. The writer of a PL/R
function must take care that the function cannot be used to do anything
unwanted, since it will be able to do anything that could be done by a user
logged in as the database administrator.

An implementation restriction is that PL/R procedures cannot be used to create
input/output functions for new data types.

%prep
%setup -q -n %{name}

%build
make USE_PGXS=1

%install
rm -rf %{buildroot}
make USE_PGXS=1 DESTDIR=%{buildroot}/ install

%clean
rm -rf %{buildroot}

%files
%defattr(644,root,root,755)
%doc %{pkgdocdir}/extension/README.plr
%{pkgsharedir}/extension/plr.sql
%{pkgsharedir}/extension/plr.control
%{pkgsharedir}/extension/plr--8.3.0.17.sql
%{pkgsharedir}/extension/plr--unpackaged--8.3.0.17.sql
%{pkglibdir}/plr.so*
