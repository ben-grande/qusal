# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         sys-syncthing
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

Name:           qusal-sys-syncthing
Version:        0.0.1
Release:        1%{?dist}
Summary:        Syncthing through Qrexec in Qubes OS
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
Requires:       qusal-dom0
Requires:       qusal-dotfiles
Requires:       qusal-utils


%description
Creates a Syncthing qube named "sys-syncthing", it will be attached to the
"default_netvm". It makes no sense to run this with "sys-syncthing" attached
to a VPN or Tor proxy.

This package opens up the qubes-firewall, so that the "sys-syncthing" qube is
accessible externally.

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
  qubesctl state.apply sys-syncthing.create
  qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
  qubesctl --skip-dom0 --targets=tpl-sys-syncthing state.apply sys-syncthing.install
  qubesctl --skip-dom0 --targets=sys-syncthing state.apply sys-syncthing.configure
  qubesctl --skip-dom0 --targets=sys-syncthing-browser state.apply sys-syncthing.configure-browser
  qubesctl state.apply sys-syncthing.appmenus
  qvm-port-forward -a add -q sys-syncthing -n tcp -p 22000
  qvm-port-forward -a add -q sys-syncthing -n udp -p 22000
elif test "$1" = "2"; then
  ## Upgrade
  true
fi

%preun
if test "$1" = "0"; then
  ## Uninstall
  qvm-port-forward -a del -q sys-syncthing -n tcp -p 22000
  qvm-port-forward -a del -q sys-syncthing -n udp -p 22000
  qubesctl state.apply sys-syncthing.clean
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
* Tue Jul 09 2024 Ben Grande <ben.grande.b@gmail.com> - 011a71a
- style: limit line length per file extension

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - d316999
- doc: add browser isolation feature to design guide

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 9c28068
- refactor: prefer systemd sockets over socat

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 4facf45
- feat: use native TCP socket with Qrexec

* Mon Jun 24 2024 Ben Grande <ben.grande.b@gmail.com> - 22e2a2e
- chore: add copyright to systemd services

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - 97b2496
- fix: start service after Qubes Service setup

* Sun Jun 09 2024 Ben Grande <ben.grande.b@gmail.com> - d2771d5
- fix: guarantee states order dependent on browser

* Wed May 29 2024 Ben Grande <ben.grande.b@gmail.com> - 8accc47
- fix: remove old deb repository list format

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - b2c9479
- fix: enforce https on repository installation

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - d4c3fb1
- feat: add terraform and chrome fedora repositories

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - b5d7371
- fix: thunar requires xfce helpers to find terminal

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - b01f2d2
- chore: move port forward to dom0 formula

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 30f2ebe
- fix: port forward validate values from DomUs

* Sun Jan 28 2024 Ben Grande <ben.grande.b@gmail.com> - 9183828
- fix: fail early when qubes.VMShell is unsupported

* Sat Jan 27 2024 Ben Grande <ben.grande.b@gmail.com> - 03cb70c
- fix: port forwarder missing short options usage

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Tue Jan 16 2024 Ben Grande <ben.grande.b@gmail.com> - 6bf9b97
- fix: help option for port forwarder

* Tue Jan 16 2024 Ben Grande <ben.grande.b@gmail.com> - 80638d6
- feat: port forwarder

* Wed Dec 27 2023 Ben Grande <ben.grande.b@gmail.com> - 76079d2
- fix: wrong source paths

* Tue Dec 26 2023 Ben Grande <ben.grande.b@gmail.com> - e650dea
- fix: port forwarder script with custom rc

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - 71d22c5
- refactor: reorder states to avoid race condition

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - b4d142b
- refactor: move appended states to drop-in rc.local

* Tue Nov 21 2023 Ben Grande <ben.grande.b@gmail.com> - 10b3bcd
- fix: unstrusted input marking and sanitization

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
