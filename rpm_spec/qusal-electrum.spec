# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         electrum
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

Name:           qusal-electrum
Version:        0.0.1
Release:        1%{?dist}
Summary:        Electrum Bitcoin Wallet in Qubes OS
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
Requires:       qusal-dotfiles
Requires:       qusal-sys-bitcoin
Requires:       qusal-sys-pgp
Requires:       qusal-utils
Requires:       qusal-whonix-workstation


%description
Setup multiple lightweights Electrum Bitcoin Wallets, one offline qube named
"electrum" and one online qube based on Whonix-Workstation named
"electrum-hot".

You can use either wallet or both together depending on your setup. Use the
"electrum" to sign transactions and the "electrum-hot" to broadcast them.

By default, the installation verify and fetch the tarball from upstream
sources, avoiding using outdated distribution package versions that lack
important security fixes. The fetching will occur over Tor and on a disposable
qube "disp-electrum-builder", which will then upload the files to the template
"tpl-electrum". The installation on a disposable helps separate the wallet
usage from ever connecting to the internet.

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
  qubesctl state.apply electrum.create
  qubesctl --skip-dom0 --targets=tpl-electrum-builder state.apply electrum.install-builder
  qubesctl --skip-dom0 --targets=tpl-electrum state.apply electrum.install
  qubesctl --skip-dom0 --targets=disp-electrum-builder state.apply electrum.configure-builder
  qubesctl --skip-dom0 --targets=electrum state.apply electrum.configure
  qubesctl --skip-dom0 --targets=electrum-hot state.apply electrum.configure-hot
  qubesctl state.apply electrum.appmenus
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
* Mon Jul 08 2024 Ben Grande <ben.grande.b@gmail.com> - f60077f
- doc: spell check

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 9c28068
- refactor: prefer systemd sockets over socat

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 6e85416
- feat: add disposable qubes to bitcoin clients

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Sun Feb 18 2024 Ben Grande <ben.grande.b@gmail.com> - 7d6e2bf
- fix: less menu items for bitcoin qubes

* Sun Feb 18 2024 Ben Grande <ben.grande.b@gmail.com> - 2409d8a
- fix: better electrum GUI resolution and tabs

* Sun Feb 18 2024 Ben Grande <ben.grande.b@gmail.com> - 3ef02df
- fix: electrum install zbar and protobuf

* Sat Feb 17 2024 Ben Grande <ben.grande.b@gmail.com> - 275178f
- fix: add missing dependency for qvm-connect-tcp

* Sat Feb 17 2024 Ben Grande <ben.grande.b@gmail.com> - dbed18d
- feat: Bitcoin Core and Electrum servers and wallet

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - 174af08
- feat: electrum bitcoin wallet
