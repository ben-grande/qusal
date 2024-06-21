# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

## Reproducibility.
%define source_date_epoch_from_changelog 1
%define use_source_date_epoch_as_buildtime 1
%define clamp_mtime_to_source_date_epoch 1
# Changelog is trimmed according to current date, not last date from changelog.
%define _changelog_trimtime 0
%define _changelog_trimage 0
%global _buildhost %{name}
# Python bytecode interferes when updates occur and restart is not done.
%undefine __brp_python_bytecompile

Name:           qusal-media
Version:        0.0.1
Release:        1%{?dist}
Summary:        Media opener through disposables in Qubes OS

Group:          qusal
Packager:       Ben Grande
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND CC0-1.0
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-browser
Requires:       qusal-sys-audio
Requires:       qusal-utils


%description
Creates the offline "media" qube for storing multimedia files and open the
files in a named disposable "disp-media" via MIME configuration.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
install -m 755 -d \
  %{buildroot}/srv/salt/qusal \
  %{buildroot}%{_docdir}/%{name} \
  %{buildroot}%{_defaultlicensedir}/%{name}
install -m 644 %{name}/LICENSES/* %{buildroot}%{_defaultlicensedir}/%{name}/
install -m 644 %{name}/README.md %{buildroot}%{_docdir}/%{name}/
rm -rv %{name}/LICENSES %{name}/README.md
cp -rv %{name} %{buildroot}/srv/salt/qusal/%{name}

%check

%dnl %pre

%post
if test "$1" = "1"; then
  ## Install
  qubesctl state.apply media.create
  qubesctl --skip-dom0 --targets=tpl-media state.apply media.install
  qubesctl --skip-dom0 --targets=media state.apply media.configure
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
* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - d984da5
- feat: enhance mpv performance

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Thu Feb 22 2024 Ben Grande <ben.grande.b@gmail.com> - 858aba8
- doc: inform how to get a better mpv performance

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Fri Jan 26 2024 Ben Grande <ben.grande.b@gmail.com> - aec644b
- feat: add qubes img and pdf converter media qubes

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Sun Dec 31 2023 Ben Grande <ben.grande.b@gmail.com> - 81f8c56
- fix: install missing packages to audio client

* Wed Dec 27 2023 Ben Grande <ben.grande.b@gmail.com> - a617c3d
- fix: modify package names to match Qubes 4.2

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
