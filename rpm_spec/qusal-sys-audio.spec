# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         sys-audio
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

Name:           qusal-sys-audio
Version:        0.0.1
Release:        1%{?dist}
Summary:        Audio operations in Qubes OS
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
Requires:       qusal-dev
Requires:       qusal-sys-usb
Requires:       qusal-utils


%description
Creates the named disposable "disp-sys-audio" qube for providing audio
operations such as microphone and speakers to and from qubes. By default, you
can use the builtin stereo, JACK and  USB , but if you want, you can install
the necessary packages for bluetooth with the provided state.

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
  qubesctl state.apply sys-audio.create
  qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install
  qubesctl --skip-dom0 --targets=dvm-sys-audio state.apply sys-audio.configure-dvm
  qubesctl state.apply sys-audio.appmenus
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

* Tue Jul 02 2024 Ben Grande <ben.grande.b@gmail.com> - 9320c3f
- feat: disable OBEX Bluetooth file transfer method

* Tue Jul 02 2024 Ben Grande <ben.grande.b@gmail.com> - 422ec06
- fix: sync Qrexec audio policies

* Fri Jun 28 2024 Ben Grande <ben.grande.b@gmail.com> - 077b21d
- feat: support browser installation on Fedora

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Fri Jun 07 2024 Ben Grande <ben.grande.b@gmail.com> - c7c85fb
- fix: more restrictive Qrexec audio policy

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 29601d8
- doc: refer to video-companion for sys-usb webcam

* Sat Mar 23 2024 Ben Grande <ben.grande.b@gmail.com> - fcc155f
- feat: optional state to autostart AudioVM

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Wed Feb 28 2024 Ben Grande <ben.grande.b@gmail.com> - ead4073
- feat: allow disp-sys-usb to be an AudioVM

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Mon Jan 22 2024 Ben Grande <ben.grande.b@gmail.com> - bd255af
- fix: cleanup audio home directory

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Fri Jan 19 2024 Ben Grande <ben.grande.b@gmail.com> - 71dd9a5
- doc: bluetooth system tray

* Fri Jan 19 2024 Ben Grande <ben.grande.b@gmail.com> - 4ef0d05
- feat: seamless audio integration with bluetooth

* Fri Jan 19 2024 Ben Grande <ben.grande.b@gmail.com> - b95cc6d
- feat: pavucontrol in sys-audio

* Wed Jan 17 2024 Ben Grande <ben.grande.b@gmail.com> - 3faa523
- feat: usb devices in sys-audio

* Sun Jan 14 2024 Ben Grande <ben.grande.b@gmail.com> - c3937e8
- fix: disposable sys-audio name with disp prefix

* Thu Jan 04 2024 Ben Grande <ben.grande.b@gmail.com> - e167879
- doc: sys-audio usage

* Thu Jan 04 2024 Ben Grande <ben.grande.b@gmail.com> - 767fc42
- fix: allow to attach mic with sys-audio

* Wed Jan 03 2024 Ben Grande <ben.grande.b@gmail.com> - 2283b33
- fix: sys-audio policy and autostart pacat daemon

* Tue Jan 02 2024 Ben Grande <ben.grande.b@gmail.com> - f32a14c
- fix: autostart volumeicon

* Sun Dec 31 2023 Ben Grande <ben.grande.b@gmail.com> - 81f8c56
- fix: install missing packages to audio client

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
