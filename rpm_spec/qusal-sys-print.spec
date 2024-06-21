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

Name:           qusal-sys-print
Version:        0.0.1
Release:        1%{?dist}
Summary:        Printer environment in Qubes OS

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
Requires:       qusal-dev
Requires:       qusal-dotfiles
Requires:       qusal-sys-print
Requires:       qusal-sys-usb
Requires:       qusal-utils


%description
Creates a print server named "sys-print" and a named disposable
"disp-sys-print" qube for sending files to your configured printer, which can
be done over the network or with IPP-over-USB.

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
  qubesctl state.apply sys-print.create
  qubesctl --skip-dom0 --targets=tpl-sys-print state.apply sys-print.install
  qubesctl state.apply sys-print.appmenus
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
* Thu Jun 20 2024 Ben Grande <ben.grande.b@gmail.com> - ab56b5f
- feat: allow print calls from qubes with tag

* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - 97b2496
- fix: start service after Qubes Service setup

* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - f30bd20
- fix: Print server without RPC service

* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - f86e30a
- fix: add simple-scan to printer appmenus

* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - 49a295d
- fix: printer formula with conflicting IDs

* Tue May 28 2024 Ben Grande <ben.grande.b@gmail.com> - 44ea4c5
- feat: add manual page reader

* Fri May 24 2024 Ben Grande <ben.grande.b@gmail.com> - b09ecdc
- feat: add Print formula
