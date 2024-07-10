# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         sys-pihole
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

Name:           qusal-sys-pihole
Version:        0.0.1
Release:        1%{?dist}
Summary:        Pi-hole DNS Sinkhole in Qubes OS
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
Requires:       qusal-browser
Requires:       qusal-debian-minimal
Requires:       qusal-dotfiles
Requires:       qusal-sys-cacher
Requires:       qusal-sys-net
Requires:       qusal-utils


%description
The package will create a standalone qube "sys-pihole". It blocks
advertisements and internet trackers by providing a DNS sinkhole. It is a drop
in replacement for sys-firewall.

The qube will be attached to the "netvm" of the "default_netvm", in other
words, if you are using Qubes OS default setup, it will use "sys-net" as the
"netvm", else it will try to figure out what is your upstream link and attach
to it.

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
  qubesctl state.apply sys-pihole.create
  qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
  qubesctl --skip-dom0 --targets=sys-pihole state.apply sys-pihole.install
  qubesctl --skip-dom0 --targets=sys-pihole-browser state.apply sys-pihole.configure-browser
  qubesctl state.apply sys-pihole.appmenus
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

* Sun Jul 07 2024 Ben Grande <ben.grande.b@gmail.com> - ab044c1
- feat: bump Pi-Hole version

* Fri Jul 05 2024 Ben Grande <ben.grande.b@gmail.com> - 14b3896
- feat: use ip interface group for faster evaluation

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Mon Jul 01 2024 Ben Grande <ben.grande.b@gmail.com> - 140b96b
- fix: remove expired GitHub web-flow signing key

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - d316999
- doc: add browser isolation feature to design guide

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 9c28068
- refactor: prefer systemd sockets over socat

* Sat Jun 22 2024 Ben Grande <ben.grande.b@gmail.com> - f5528fe
- fix: remove duplicated updates proxy feature

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - a564b3a
- feat: add TCP proxy for remote hosts

* Sun Jun 09 2024 Ben Grande <ben.grande.b@gmail.com> - d2771d5
- fix: guarantee states order dependent on browser

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Sat May 11 2024 Ben Grande <ben.grande.b@gmail.com> - 72f61bb
- fix: install fwupd qubes plugin to updatevm

* Fri Apr 12 2024 Ben Grande <ben.grande.b@gmail.com> - a8e9188
- feat: bump Pi-Hole and Bitcoin version

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Thu Mar 14 2024 Ben Grande <ben.grande.b@gmail.com> - 7c3d6ac
- fix: remove cacher proxy from updatevm

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Tue Jan 09 2024 Ben Grande <ben.grande.b@gmail.com> - 567e36d
- fix: prefer qvm-features for uniformity

* Fri Jan 05 2024 Ben Grande <ben.grande.b@gmail.com> - 762f8be
- fix: make sys-pihole fully replace sys-firewall

* Fri Jan 05 2024 Ben Grande <ben.grande.b@gmail.com> - 705808d
- feat: allow sys-pihole to use pi-hole for queries

* Fri Jan 05 2024 Ben Grande <ben.grande.b@gmail.com> - 692659e
- feat: passwordless pihole admin interface

* Wed Jan 03 2024 Ben Grande <ben.grande.b@gmail.com> - 6bb426a
- refactor: import armored gpg keys instead of db

* Tue Dec 26 2023 Ben Grande <ben.grande.b@gmail.com> - 6a551eb
- refactor: pihole nft rules for Qubes 4.2

* Sun Dec 24 2023 Ben Grande <ben.grande.b@gmail.com> - 224d2d5
- fix: pihole lighttpd link

* Sat Dec 23 2023 Ben Grande <ben.grande.b@gmail.com> - 6fc173d
- feat: clockvm also present in sys-pihole

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - 38d98ec
- fix: nft shebang and table names

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - 71d22c5
- refactor: reorder states to avoid race condition

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - b4d142b
- refactor: move appended states to drop-in rc.local

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - 0751aff
- refactor: organize pihole directory structure

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
