# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         sys-usb
%define license_csv     AGPL-3.0-or-later,GPL-3.0-or-later
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

Name:           qusal-sys-usb
Version:        0.0.1
Release:        1%{?dist}
Summary:        PCI handler of USB devices in Qubes OS
Group:          qusal
Packager:       %{?_packager}%{!?_packager:Ben Grande <ben.grande.b@gmail.com>}
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND GPL-3.0-or-later
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-utils


%description
Setup named disposables for USB qubes. During creation, it tries to separate
the USB controllers to different qubes is possible.

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
  qubesctl state.apply sys-usb.create
  qubesctl --skip-dom0 --targets=tpl-sys-usb state.apply sys-usb.install
  qubesctl state.apply sys-usb.appmenus
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
* Mon Jul 15 2024 Ben Grande <ben.grande.b@gmail.com> - 409ac73
- feat: add appmenus to audio applications

* Fri Jul 05 2024 Ben Grande <ben.grande.b@gmail.com> - a9ca2f0
- doc: inform how to use USB audio in disp-sys-audio

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Tue Jul 02 2024 Ben Grande <ben.grande.b@gmail.com> - 422ec06
- fix: sync Qrexec audio policies

* Sun Jun 30 2024 Ben Grande <ben.grande.b@gmail.com> - 09bd216
- fix: fold character that is not special for Jinja

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 9c28068
- refactor: prefer systemd sockets over socat

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 29601d8
- doc: refer to video-companion for sys-usb webcam

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 8d9ad74
- fix: correct man-db typo

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Wed Feb 28 2024 Ben Grande <ben.grande.b@gmail.com> - ead4073
- feat: allow disp-sys-usb to be an AudioVM

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - ac25ef6
- fix: sys-usb hide-usb-from-dom0 in keyboard state

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 6eefced
- fix: sys-usb disposables must have name prefix

* Wed Jan 10 2024 Ben Grande <ben.grande.b@gmail.com> - 040594a
- fix: do not remove created dvm

* Wed Jan 10 2024 Ben Grande <ben.grande.b@gmail.com> - 5b9b0bb
- doc: missing access control for sys-usb

* Wed Jan 10 2024 Ben Grande <ben.grande.b@gmail.com> - 76e9234
- fix: organize sys-usb policy per service

* Tue Jan 09 2024 Ben Grande <ben.grande.b@gmail.com> - a3829e4
- feat: policy support for multiple sys-usb qubes

* Wed Dec 27 2023 Ben Grande <ben.grande.b@gmail.com> - a617c3d
- fix: modify package names to match Qubes 4.2

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
