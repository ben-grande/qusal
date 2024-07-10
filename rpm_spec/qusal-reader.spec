# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         reader
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

Name:           qusal-reader
Version:        0.0.1
Release:        1%{?dist}
Summary:        Reader environment as the default_dispvm in Qubes OS
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
Requires:       qusal-utils


%description
Create a disposable template for reading documents and viewing images called
"dvm-reader". It is designated to be the "default_dispvm", because of this,
there is no "netvm", but if you assign one, you will get networking as the
necessary packages will be installed in the template.

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
  qubesctl state.apply reader.create
  qubesctl --skip-dom0 --targets=tpl-reader state.apply reader.install
  qubesctl --skip-dom0 --targets=dvm-reader state.apply reader.configure
  qubesctl state.apply reader.appmenus
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
* Tue Jul 09 2024 Ben Grande <ben.grande.b@gmail.com> - 011a71a
- style: limit line length per file extension

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Fri Jun 28 2024 Ben Grande <ben.grande.b@gmail.com> - 72068e8
- fix: add Mullvad Browser

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Sun Jun 09 2024 Ben Grande <ben.grande.b@gmail.com> - 899f7e4
- fix: add Fedora 40 Firefox desktop file to appmenu

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - b5d7371
- fix: thunar requires xfce helpers to find terminal

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Fri Jan 26 2024 Ben Grande <ben.grande.b@gmail.com> - aec644b
- feat: add qubes img and pdf converter media qubes

* Tue Jan 23 2024 Ben Grande <ben.grande.b@gmail.com> - 7ec20f1
- fix: add file browser to reader

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 23a569d
- fix: install less browser packages in reader

* Wed Dec 20 2023 Ben Grande <ben.grande.b@gmail.com> - 80aeb36
- fix: sync reader appmenus

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
