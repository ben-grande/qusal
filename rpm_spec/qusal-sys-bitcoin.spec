# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         sys-bitcoin
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

Name:           qusal-sys-bitcoin
Version:        0.0.1
Release:        1%{?dist}
Summary:        Bitcoin Core in Qubes OS
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
Requires:       qusal-sys-git
Requires:       qusal-utils
Requires:       qusal-whonix-workstation


%description
Setup a Bitcoin Daemon full-node qube named "sys-bitcoin", where you will
index the Bitcoin blockchain. A second non-networked qube named "bitcoin" can
manage a wallet and sign transactions.

By default, installation from upstream binaries will be used, but you can
choose to build from source if you prefer. Compiling from source will not have
the default configuration flags, but will be optimized to our use case.

The download of the Bitcoin source code or binaries as well as the connections
to the Bitcoin P2P network will happen over the Tor network.

If you already have a node on your network that has indexed the blockchain
already and has RPC enabled for remote clients, you can also connect to it,
preferably if it has transport encryption when connecting to the Bitcoin node
with an encrypted tunnel.

A disposable qube "disp-bitcoin-builder" will be created, based on
Whonix-Workstation, it will server to install and verify Bitcoin Core. After
the verification succeeds, files are copied to the template "tpl-sys-bitcoin".
This method was chosen so the client can be always offline and the build
artifacts are built on a machine that is not running the daemon and thus can
be copied to the template with a higher degree of trust.

At least `1TB` of disk space is required. At block `829054` (2024-02-05),
`642G` are used.

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
  qubesctl state.apply sys-bitcoin.create
  qubesctl --skip-dom0 --targets=sys-bitcoin-gateway state.apply sys-bitcoin.configure-gateway
  qubesctl --skip-dom0 --targets=tpl-sys-bitcoin state.apply sys-bitcoin.install
  qubesctl --skip-dom0 --targets=disp-bitcoin-builder state.apply sys-bitcoin.configure-builder
  qubesctl --skip-dom0 --targets=sys-bitcoin state.apply sys-bitcoin.configure
  qubesctl --skip-dom0 --targets=bitcoin state.apply sys-bitcoin.configure-client
  qubesctl state.apply sys-bitcoin.appmenus
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
* Wed Jul 10 2024 Ben Grande <ben.grande.b@gmail.com> - 224312e
- feat: enable all optional shellcheck validations

* Tue Jul 09 2024 Ben Grande <ben.grande.b@gmail.com> - 011a71a
- style: limit line length per file extension

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 9c28068
- refactor: prefer systemd sockets over socat

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 43e1e32
- feat: bump Bitcoin version

* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 59e8fc3
- fix: GUI Global Config precedes packaged policies

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 7873dd8
- fix: remove undesired appmenus from builder qubes

* Tue Jun 04 2024 Ben Grande <ben.grande.b@gmail.com> - 6e85416
- feat: add disposable qubes to bitcoin clients

* Wed May 15 2024 Ben Grande <ben.grande.b@gmail.com> - 3adc241
- fix: renew keys and delete expired ones

* Wed Apr 17 2024 Ben Grande <ben.grande.b@gmail.com> - ec7f62f
- feat: bump Bitcoin version

* Fri Apr 12 2024 Ben Grande <ben.grande.b@gmail.com> - a8e9188
- feat: bump Pi-Hole and Bitcoin version

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Thu Feb 22 2024 Ben Grande <ben.grande.b@gmail.com> - 9a4790f
- doc: inform how to reduce bitcoind memory usage

* Sun Feb 18 2024 Ben Grande <ben.grande.b@gmail.com> - 7d6e2bf
- fix: less menu items for bitcoin qubes

* Sat Feb 17 2024 Ben Grande <ben.grande.b@gmail.com> - dbed18d
- feat: Bitcoin Core and Electrum servers and wallet
