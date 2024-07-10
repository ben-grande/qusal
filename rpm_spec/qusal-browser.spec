# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         browser
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

Name:           qusal-browser
Version:        0.0.1
Release:        1%{?dist}
Summary:        Browser environment in Qubes OS
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
Requires:       qusal-sys-audio
Requires:       qusal-sys-usb
Requires:       qusal-utils


%description
Create environment for browsing. By default it creates a disposable template
called "dvm-browser", so when clicking the icon/launcher, it opens a
disposable qube. If you want to save your session, you can also clone the
template and create app qubes.

Default browser to install is Chromium, but you can choose to install Chrome,
Firefox, Firefox-ESR, Mullvad-Browser, W3M or Lynx.

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
  qubesctl state.apply browser.create
  qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
  qubesctl --skip-dom0 --targets=dvm-browser state.apply browser.configure
  qubesctl state.apply browser.appmenus
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

* Mon Jul 01 2024 c0mmando <103726157+c0mmando@users.noreply.github.com> - 41c2100
- fix: remove typo in mullvad-browser install state

* Fri Jun 28 2024 Ben Grande <ben.grande.b@gmail.com> - 077b21d
- feat: support browser installation on Fedora

* Fri Jun 28 2024 Ben Grande <ben.grande.b@gmail.com> - 72068e8
- fix: add Mullvad Browser

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Sun Jun 16 2024 Ben Grande <ben.grande.b@gmail.com> - faa00fb
- doc: update table of contents

* Sun Jun 09 2024 Ben Grande <ben.grande.b@gmail.com> - 899f7e4
- fix: add Fedora 40 Firefox desktop file to appmenu

* Wed May 29 2024 Ben Grande <ben.grande.b@gmail.com> - 8accc47
- fix: remove old deb repository list format

* Fri May 24 2024 Ben Grande <ben.grande.b@gmail.com> - cbf61e6
- feat: add Firefox browser from Mozilla repository

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - b2c9479
- fix: enforce https on repository installation

* Thu May 16 2024 Ben Grande <ben.grande.b@gmail.com> - d4c3fb1
- feat: add terraform and chrome fedora repositories

* Wed May 15 2024 Ben Grande <ben.grande.b@gmail.com> - 3adc241
- fix: renew keys and delete expired ones

* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Mon Mar 25 2024 Ben Grande <ben.grande.b@gmail.com> - fb7db5d
- fix: browser requires a state and not a package

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Wed Jan 31 2024 Ben Grande <ben.grande.b@gmail.com> - b5d7371
- fix: thunar requires xfce helpers to find terminal

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 20 2024 Ben Grande <ben.grande.b@gmail.com> - 422b01e
- feat: remove audiovm setting when unnecessary

* Tue Jan 09 2024 Ben Grande <ben.grande.b@gmail.com> - a3829e4
- feat: policy support for multiple sys-usb qubes

* Sun Dec 31 2023 Ben Grande <ben.grande.b@gmail.com> - 81f8c56
- fix: install missing packages to audio client

* Wed Dec 27 2023 Ben Grande <ben.grande.b@gmail.com> - a617c3d
- fix: modify package names to match Qubes 4.2

* Tue Dec 26 2023 Ben Grande <ben.grande.b@gmail.com> - 06393fc
- fix: browser cli install tool switches to fetcher

* Mon Nov 13 2023 Ben Grande <ben.grande.b@gmail.com> - 5eebd78
- refactor: initial commit
