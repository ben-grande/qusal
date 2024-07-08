# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         dev
%define license_csv     AGPL-3.0-or-later
## Reproducibility.
%define source_date_epoch_from_changelog 1
%define use_source_date_epoch_as_buildtime 1
%define clamp_mtime_to_source_date_epoch 1
## Changelog is trimmed according to current date, not last date from changelog.
%define _changelog_trimtime 0
%define _changelog_trimage 0
%global _buildhost %{name}
## Python bytecode interferes when updates occur and restart is not done.
%undefine __brp_python_bytecompile

Name:           qusal-dev
Version:        0.0.1
Release:        1%{?dist}
Summary:        Development environment in Qubes OS
Group:          qusal
Packager:       %{?_packager}%{!?_packager:Ben Grande <ben.grande.b@gmail.com>}
Vendor:         Ben Grande
License:        AGPL-3.0-or-later
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-dotfiles
Requires:       qusal-sys-git
Requires:       qusal-sys-net
Requires:       qusal-sys-pgp
Requires:       qusal-sys-ssh-agent
Requires:       qusal-utils


%description
Setup a development qube named "dev". Defines the user interactive shell,
installing goodies, applying dotfiles, being client of sys-pgp, sys-git and
sys-ssh-agent. The qube has netvm but can reach remote servers if the policy
allows.

%prep
%setup -q

%build

%check

%pre

%install
rm -rf %{buildroot}
install -m 755 -d \
  %{buildroot}/srv/salt/qusal \
  %{buildroot}%{_docdir}/%{name} \
  %{buildroot}%{_defaultlicensedir}/%{name}

for license in $(echo "%{license_csv}" | tr "," " "); do
  license_dir="LICENSES"
  if test -d "salt/%{project}/LICENSES"; then
    license_dir="salt/%{project}/LICENSES"
  fi
  install -m 644 "${license_dir}/${license}.txt" %{buildroot}%{_defaultlicensedir}/%{name}/
done

install -m 644 salt/%{project}/README.md %{buildroot}%{_docdir}/%{name}/
rm -rf \
  salt/%{project}/LICENSES \
  salt/%{project}/README.md \
  salt/%{project}/.*
cp -rv salt/%{project} %{buildroot}/srv/salt/qusal/%{name}

%post
if test "$1" = "1"; then
  ## Install
  qubesctl state.apply dev.create
  qubesctl --skip-dom0 --targets=tpl-dev state.apply dev.install
  qubesctl --skip-dom0 --targets=dvm-dev state.apply dev.configure-dvm
  qubesctl --skip-dom0 --targets=dev state.apply dev.configure
  if test -n "${proxy_target}"; then
    sudo qubesctl --skip-dom0 --targets="${proxy_target}" state.apply sys-net.install-proxy
elif test "$1" = "2"; then
  ## Upgrade
  true
fi

%preun
if test "$1" = "0"; then
  ## Uninstall
  true
elif test "$1" = "1"; then
  ## Upgrade
  true
fi

%postun
if test "$1" = "0"; then
  ## Uninstall
  true
elif test "$1" = "1"; then
  ## Upgrade
  true
fi

%files
%defattr(-,root,root,-)
%license %{_defaultlicensedir}/%{name}/*
%doc %{_docdir}/%{name}/README.md
%dir /srv/salt/qusal/%{name}
/srv/salt/qusal/%{name}/*
%dnl TODO: missing '%ghost', files generated during %post, such as Qrexec policies.

%changelog
* Mon Jul 08 2024 Ben Grande <ben.grande.b@gmail.com> - f60077f
- doc: spell check

* Fri Jul 05 2024 Ben Grande <ben.grande.b@gmail.com> - 34d2943
- fix: correct markdown lint package name

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Tue Jul 02 2024 Ben Grande <ben.grande.b@gmail.com> - 06af125
- feat: clean dev installation

* Wed Jun 26 2024 Ben Grande <ben.grande.b@gmail.com> - eb3a8ab
- feat: install Qusal TCP Proxy on updatevm's origin

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 534db96
- doc: qusal proxy service requires configuration

* Fri Jun 14 2024 Ben Grande <ben.grande.b@gmail.com> - afcb730
- doc: document usage of qusal TCP proxy

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - a564b3a
- feat: add TCP proxy for remote hosts

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Sat Feb 17 2024 Ben Grande <ben.grande.b@gmail.com> - dbed18d
- feat: Bitcoin Core and Electrum servers and wallet

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Fri Jan 26 2024 Ben Grande <ben.grande.b@gmail.com> - a04960c
- feat: initial split-mail setup

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - dbaa386
- chore: inline dev install documentation

* Mon Dec 18 2023 Ben Grande <ben.grande.b@gmail.com> - 9fc2c03
- doc: top method must not skip dom0

* Mon Nov 20 2023 Ben Grande <ben.grande.b@gmail.com> - 5e3c790
- fix: mode ansible linter to correct project

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
