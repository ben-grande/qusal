# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         @NAME@
%define license_csv     @LICENSE_CSV@
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

Name:           @PROJECT@
Version:        @VERSION@
Release:        1%{?dist}
Summary:        @SUMMARY@
Group:          @GROUP@
Packager:       %{?_packager}%{!?_packager:@PACKAGER@}
Vendor:         @VENDOR@
License:        @LICENSE@
URL:            @URL@
BugURL:         @BUG_URL@
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
@REQUIRES@

%description
@DESCRIPTION@

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
cp -rv salt/%{project} %{buildroot}@FILE_ROOTS@/%{name}

%post
if test "$1" = "1"; then
  ## Install
  @POST_INSTALL@
elif test "$1" = "2"; then
  ## Upgrade
  @POST_UPGRADE@
fi

%preun
if test "$1" = "0"; then
  ## Uninstall
  @PREUN_UNINSTALL@
elif test "$1" = "1"; then
  ## Upgrade
  @PREUN_UPGRADE@
fi

%postun
if test "$1" = "0"; then
  ## Uninstall
  @POSTUN_UNINSTALL@
elif test "$1" = "1"; then
  ## Upgrade
  @POSTUN_UPGRADE@
fi

%files
%defattr(-,root,root,-)
%license %{_defaultlicensedir}/%{name}/*
%doc %{_docdir}/%{name}/README.md
%dir @FILE_ROOTS@/%{name}
@FILE_ROOTS@/%{name}/*
%dnl TODO: missing '%ghost', files generated during %post, such as Qrexec policies.

%changelog
@CHANGELOG@
