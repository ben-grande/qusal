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

Name:           qusal-sys-mirage-firewall
Version:        0.0.1
Release:        1%{?dist}
Summary:        Mirage Firewall in Qubes OS

Group:          qusal
Packager:       Ben Grande
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND MIT
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0


%description
Creates a Mirage Firewall qube named "disp-sys-mirage-firewall". It is an
OCaml program compiled to run as an operating system kernel, in this case, a
MirageOS unikernel replacement for the default firewall (sys-firewall). It
pulls in just the code it needs as libraries.

Contrary to a standard Linux Firewall, Mirage Firewall doesn't need a full
system to run an excessive resources.

You can't use Mirage Firewall to be the updatevm, use another qube instead.

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
  qubesctl state.apply sys-mirage-firewall.create
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
* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Sat May 11 2024 Ben Grande <ben.grande.b@gmail.com> - bfb3026
- fix: update mirage firewall version

* Wed Apr 24 2024 Ben Grande <ben.grande.b@gmail.com> - 7ec71cc
- feat: bump Mirage Firewall version

* Tue Mar 19 2024 Ben Grande <ben.grande.b@gmail.com> - cb59a9a
- feat: fetch mirage tarball

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - c98b8b3
- fix: do not include mirage firewall in backup

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sun Jan 28 2024 Ben Grande <ben.grande.b@gmail.com> - cb4ff00
- doc: typo in mirage firewall usage

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Fri Jan 12 2024 Ben Grande <ben.grande.b@gmail.com> - 7eb1f34
- feat: disposable mirage firewall

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 963e72c
- chore: Fix unman copyright contact

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
