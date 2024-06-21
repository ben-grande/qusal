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

Name:           qusal-utils
Version:        0.0.1
Release:        1%{?dist}
Summary:        Utilities library for Qusal

Group:          qusal
Packager:       Ben Grande
Vendor:         Ben Grande
License:        AGPL-3.0-or-later
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0


%description
Utils is a SaltStack Qubes library for certain operations shared by multiple
projects such as macros and common tools to be installed.

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
  true
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
* Fri May 24 2024 Ben Grande <ben.grande.b@gmail.com> - cbf61e6
- feat: add Firefox browser from Mozilla repository

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - b2c9479
- fix: enforce https on repository installation

* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Tue Apr 30 2024 Ben Grande <ben.grande.b@gmail.com> - 5722a25
- fix: discover non-root username at runtime

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

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 2576d14
- fix: policy file mode not allowing group to write

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 2063a43
- fix: clone macro support for optional argument

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 5e5ae2f
- fix: zsh state import with relative path

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - a97e3c0
- feat: kicksecure minimal template

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
