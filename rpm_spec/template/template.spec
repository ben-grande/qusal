# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define file_roots     %(./scripts/spec-get.sh @PROJECT@ file_roots)
%define my_name        %(./scripts/spec-get.sh @PROJECT@ name)
%define branch         %(./scripts/spec-get.sh @PROJECT@ branch)
%define project        %(./scripts/spec-get.sh @PROJECT@ project)
%define summary        %(./scripts/spec-get.sh @PROJECT@ summary)
%define group          %(./scripts/spec-get.sh @PROJECT@ group)
%define packager       %(./scripts/spec-get.sh @PROJECT@ packager)
%define vendor         %(./scripts/spec-get.sh @PROJECT@ vendor)
%define license_csv    %(./scripts/spec-get.sh @PROJECT@ license_csv)
%define license        %(./scripts/spec-get.sh @PROJECT@ license)
%define url            %(./scripts/spec-get.sh @PROJECT@ url)
%define bug_url        %(./scripts/spec-get.sh @PROJECT@ bug_url)
%define my_description %(./scripts/spec-get.sh @PROJECT@ description)

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

Name:           %{project}
Version:        @VERSION@
Release:        1%{?dist}
Summary:        %{summary}

Group:          %{group}
Packager:       %{packager}
Vendor:         %{vendor}
License:        %{license}
URL:            %{url}
BugURL:         %{bug_url}
Source0:        %{project}
BuildArch:      noarch

Requires:       qubes-mgmt-salt
Requires:       qubes-mgmt-salt-dom0
@REQUIRES@

%description
%{my_description}

%prep

%build

%install
rm -rf %{buildroot}
install -m 755 -d \
  %{buildroot}%{file_roots} \
  %{buildroot}%{_docdir}/%{project} \
  %{buildroot}%{_defaultlicensedir}/%{project}
install -m 644 %{project}/LICENSES/* %{buildroot}%{_defaultlicensedir}/%{project}/
install -m 644 %{project}/README.md %{buildroot}%{_docdir}/%{project}/
rm -rv %{project}/LICENSES %{project}/README.md
cp -rv %{project} %{buildroot}%{file_roots}/%{my_name}

%check

%dnl %pre

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
%license %{_defaultlicensedir}/%{project}/*
%doc %{_docdir}/%{project}/README.md
%dir %{file_roots}/%{my_name}
%{file_roots}/%{my_name}/*
%dnl TODO: missing '%ghost', files generated during %post, such as Qrexec policies.

%changelog
@CHANGELOG@
