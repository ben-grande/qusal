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

Name:           qusal-sys-electrs
Version:        0.0.1
Release:        1%{?dist}
Summary:        Electrs in Qubes OS

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
Requires:       qusal-sys-bitcoin
Requires:       qusal-sys-git
Requires:       qusal-sys-pgp
Requires:       qusal-utils
Requires:       qusal-whonix-workstation


%description
Setup an offline Electrs (Electrum Server) qube named "sys-electrs",
connected to your own full node running on "sys-bitcoin" to index the
blockchain to allow for efficient query of the history of arbitrary addresses.

A disposable qube "disp-electrs-builder" will be created, it will serve to
install and verify Electrs. After the verification succeeds, files are copied
to the template "tpl-sys-electrs". This method was chosen so the server can be
always offline.

At least `200GB` of disk space is required.

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
  qubesctl state.apply sys-electrs.create
  qubesctl --skip-dom0 --targets=tpl-electrs-builder state.apply sys-electrs.install-builder
  qubesctl --skip-dom0 --targets=tpl-sys-electrs state.apply sys-electrs.install
  qubesctl --skip-dom0 --targets=disp-electrs-builder state.apply sys-electrs.configure-builder
  qubesctl --skip-dom0 --targets=sys-electrs state.apply sys-electrs.configure
  qubesctl state.apply sys-electrs.appmenus
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
* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - 97b2496
- fix: start service after Qubes Service setup

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - e65b0bf
- fix: feature check statement missing key

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 7873dd8
- fix: remove undesired appmenus from builder qubes

* Thu May 23 2024 Ben Grande <ben.grande.b@gmail.com> - c8b9bb3
- feat: bump Electrs version

* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Mar 15 2024 Ben Grande <ben.grande.b@gmail.com> - db86c2d
- feat: bump electrs version

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Sun Feb 18 2024 Ben Grande <ben.grande.b@gmail.com> - 7d6e2bf
- fix: less menu items for bitcoin qubes

* Sat Feb 17 2024 Ben Grande <ben.grande.b@gmail.com> - 275178f
- fix: add missing dependency for qvm-connect-tcp

* Sat Feb 17 2024 Ben Grande <ben.grande.b@gmail.com> - dbed18d
- feat: Bitcoin Core and Electrum servers and wallet
