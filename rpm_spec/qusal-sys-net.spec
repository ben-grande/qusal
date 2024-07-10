# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         sys-net
%define license_csv     AGPL-3.0-or-later,MIT
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

Name:           qusal-sys-net
Version:        0.0.1
Release:        1%{?dist}
Summary:        PCI handler of network devices in Qubes OS
Group:          qusal
Packager:       %{?_packager}%{!?_packager:Ben Grande <ben.grande.b@gmail.com>}
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND MIT
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-dotfiles
Requires:       qusal-sys-net
Requires:       qusal-utils


%description
Creates and configure qubes for handling the network devices. Qubes OS
provides the state "qvm.sys-net", but it will create only "sys-net", which can
be a disposable or not. This package takes a different approach, it will
create an AppVM "sys-net" and a DispVM "disp-sys-net".

By default, the chosen one is "disp-sys-net", but you can choose which qube
type becomes the upstream net qube "default_netvm" and the fallback target for
the "qubes.UpdatesProxy" service in case no rule matched before.

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
  qubesctl state.apply sys-net.create
  qubesctl --skip-dom0 --targets=tpl-sys-net state.apply sys-net.install
  qubesctl state.apply sys-net.prefs-disp
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
* Wed Jul 10 2024 Ben Grande <ben.grande.b@gmail.com> - 224312e
- feat: enable all optional shellcheck validations

* Tue Jul 09 2024 Ben Grande <ben.grande.b@gmail.com> - 011a71a
- style: limit line length per file extension

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Wed Jun 26 2024 Ben Grande <ben.grande.b@gmail.com> - eb3a8ab
- feat: install Qusal TCP Proxy on updatevm's origin

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 4facf45
- feat: use native TCP socket with Qrexec

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 534db96
- doc: qusal proxy service requires configuration

* Sun Jun 16 2024 Ben Grande <ben.grande.b@gmail.com> - faa00fb
- doc: update table of contents

* Fri Jun 14 2024 Ben Grande <ben.grande.b@gmail.com> - afcb730
- doc: document usage of qusal TCP proxy

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - a564b3a
- feat: add TCP proxy for remote hosts

* Thu May 02 2024 Ben Grande <ben.grande.b@gmail.com> - 972ac77
- fix: install libpci by default on sys-net

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Thu Jan 04 2024 Ben Grande <ben.grande.b@gmail.com> - 0216297
- feat: default to disposable netvm

* Thu Jan 04 2024 Ben Grande <ben.grande.b@gmail.com> - e0b11b3
- fix: do not install net debug tools by default

* Thu Dec 21 2023 Ben Grande <ben.grande.b@gmail.com> - ad6f5e2
- feat: move clockvm out of sys-net to sys-firewall

* Mon Nov 20 2023 Ben Grande <ben.grande.b@gmail.com> - 2702768
- fix: add required package to sync clockvm time

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
