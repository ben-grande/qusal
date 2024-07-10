# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         qubes-builder
%define license_csv     AGPL-3.0-or-later,GPL-2.0-only
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

Name:           qusal-qubes-builder
Version:        0.0.1
Release:        1%{?dist}
Summary:        Setup Qubes OS Builder V2 in Qubes OS itself
Group:          qusal
Packager:       %{?_packager}%{!?_packager:Ben Grande <ben.grande.b@gmail.com>}
Vendor:         Ben Grande
License:        AGPL-3.0-or-later AND GPL-2.0-only
URL:            https://github.com/ben-grande/qusal
BugURL:         https://github.com/ben-grande/qusal/issues
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
Requires:       qusal-docker
Requires:       qusal-dotfiles
Requires:       qusal-fedora-minimal
Requires:       qusal-sys-git
Requires:       qusal-sys-pgp
Requires:       qusal-sys-ssh-agent
Requires:       qusal-utils


%description
Setup a Builder qube named "qubes-builder" and a disposable template for Qubes
Executor named "dvm-qubes-builder". It is possible to use any of the available
executors: docker, podman, qubes-executor.

During installation, after cloning the qubes-builderv2 repository, signatures
will be verified and the installation will fail if the signatures couldn't be
verified. Packages necessary for split operations such as split-gpg2, spit-git
and split-ssh-agent will also be installed.

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
  qubesctl state.apply qubes-builder.create
  qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply qubes-builder.install
  qubesctl state.apply qubes-builder.prefs
  qubesctl --skip-dom0 --targets=dvm-qubes-builder state.apply qubes-builder.configure-qubes-executor
  qubesctl --skip-dom0 --targets=qubes-builder state.apply qubes-builder.configure
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

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 91cf478
- fix: use mirrors metalink as a submodule

* Wed Jun 26 2024 Ben Grande <ben.grande.b@gmail.com> - 4a72a48
- feat: deploy Qusal Builder configuration

* Tue Jun 25 2024 Ben Grande <ben.grande.b@gmail.com> - 9c28068
- refactor: prefer systemd sockets over socat

* Mon Jun 24 2024 Ben Grande <ben.grande.b@gmail.com> - d0ed3a8
- fix: repository dir uses debug directory

* Mon Jun 24 2024 Ben Grande <ben.grande.b@gmail.com> - c7fb371
- fix: reference Salt dependency installation state

* Mon Jun 24 2024 Ben Grande <ben.grande.b@gmail.com> - 620fa10
- fix: shutdown template before install state

* Sat Jun 22 2024 Ben Grande <ben.grande.b@gmail.com> - 4276358
- feat: add development goodies to Qubes Builder

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Wed Jun 19 2024 Ben Grande <ben.grande.b@gmail.com> - 99fb138
- fix: correct git repository name in policy

* Mon Jun 17 2024 Ben Grande <ben.grande.b@gmail.com> - 1a72665
- feat: add split-gpg2 configuration

* Fri Jun 14 2024 Ben Grande <ben.grande.b@gmail.com> - ba5b481
- fix: signature check breaks qubes-builder update

* Thu Jun 13 2024 Ben Grande <ben.grande.b@gmail.com> - 7a70535
- fix: Fedora 40 only has wget2

* Wed Jun 12 2024 Ben Grande <ben.grande.b@gmail.com> - 10200f6
- fix: rpmmacros is unnecessary with split-gpg2

* Sat Mar 23 2024 Ben Grande <ben.grande.b@gmail.com> - cf88ad1
- fix: install salt depends in fedora-39-minimal

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Sun Feb 04 2024 Ben Grande <ben.grande.b@gmail.com> - c35ec15
- fix: create directories when necessary

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 97c644a
- fix: invert builder memory and vcpus

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Thu Jan 18 2024 Ben Grande <ben.grande.b@gmail.com> - 0887c24
- fix: remove unicode from used files

* Mon Jan 08 2024 Ben Grande <ben.grande.b@gmail.com> - f5894dc
- doc: cleaner usage sections for qubes-builder

* Sun Jan 07 2024 Ben Grande <ben.grande.b@gmail.com> - 42a9309
- fix: rpc service copy to dvm

* Fri Jan 05 2024 Ben Grande <ben.grande.b@gmail.com> - a17f9f5
- feat: unattended qubes-builder build

* Fri Jan 05 2024 Ben Grande <ben.grande.b@gmail.com> - c109404
- fix: add user to mock group

* Wed Jan 03 2024 Ben Grande <ben.grande.b@gmail.com> - 6bb426a
- refactor: import armored gpg keys instead of db

* Wed Jan 03 2024 Ben Grande <ben.grande.b@gmail.com> - 0eecbcf
- fix: unconfined qfile-unpacker

* Wed Jan 03 2024 Ben Grande <ben.grande.b@gmail.com> - 0832859
- fix: remove old split-gpg from qubes-builder

* Thu Dec 28 2023 Ben Grande <ben.grande.b@gmail.com> - f8953c6
- doc: better usage of split-gpg2 in qubes-builder

* Thu Dec 28 2023 Ben Grande <ben.grande.b@gmail.com> - b52e4b1
- fix: strict split-gpg2 service

* Tue Dec 19 2023 Ben Grande <ben.grande.b@gmail.com> - b4d142b
- refactor: move appended states to drop-in rc.local

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
