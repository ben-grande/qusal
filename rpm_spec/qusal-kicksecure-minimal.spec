# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         kicksecure-minimal
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

Name:           qusal-kicksecure-minimal
Version:        0.0.1
Release:        1%{?dist}
Summary:        Kicksecure Minimal Template in Qubes OS
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
Requires:       qusal-kicksecure-minimal
Requires:       qusal-utils


%description
Creates the Kicksecure Minimal template as well as a Disposable Template based
on it.

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
rm -rf salt/%{project}/LICENSES salt/%{project}/README.md
cp -rv salt/%{project} %{buildroot}/srv/salt/qusal/%{name}

%post
if test "$1" = "1"; then
  ## Install
  qubesctl state.apply kicksecure-minimal.create
  qubesctl --skip-dom0 --targets=kicksecure-17-minimal state.apply kicksecure-minimal.install
  qubesctl state.apply kicksecure-minimal.prefs
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
* Sat Jun 22 2024 Ben Grande <ben.grande.b@gmail.com> - a6194e0
- fix: remove cacher tag from Kicksecure template

* Sat Jun 22 2024 Ben Grande <ben.grande.b@gmail.com> - 7df3be4
- fix: install caching client before common update

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - bd5c635
- fix: remove single quotes from Jinja regex

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Sun Jun 16 2024 Ben Grande <ben.grande.b@gmail.com> - faa00fb
- doc: update table of contents

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - b2c9479
- fix: enforce https on repository installation

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Sat Feb 03 2024 Ben Grande <ben.grande.b@gmail.com> - 56ecc25
- fix: vm kernel only applies to developers

* Fri Feb 02 2024 Ben Grande <ben.grande.b@gmail.com> - 76c9cd0
- fix: move custom kicksecure settings to dev state

* Thu Feb 01 2024 Ben Grande <ben.grande.b@gmail.com> - 4596198
- fix: less intrusive kicksecure default install

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Fri Jan 26 2024 Ben Grande <ben.grande.b@gmail.com> - a04960c
- feat: initial split-mail setup

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Sun Jan 14 2024 Ben Grande <ben.grande.b@gmail.com> - ff4773b
- doc: kicksecure missing minimal flavor

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - a97e3c0
- feat: kicksecure minimal template
