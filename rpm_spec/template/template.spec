# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define file_roots     %(./scripts/spec-get.sh @PROJECT@ file_roots)
%define my_name        %(./scripts/spec-get.sh @PROJECT@ name)
%define branch         %(./scripts/spec-get.sh @PROJECT@ branch)
%define project        %(./scripts/spec-get.sh @PROJECT@ project)
%define release        %(./scripts/spec-get.sh @PROJECT@ release)
%define summary        %(./scripts/spec-get.sh @PROJECT@ summary)
%define group          %(./scripts/spec-get.sh @PROJECT@ group)
%define vendor         %(./scripts/spec-get.sh @PROJECT@ vendor)
%define license_csv    %(./scripts/spec-get.sh @PROJECT@ license_csv)
%define license        %(./scripts/spec-get.sh @PROJECT@ license)
%define url            %(./scripts/spec-get.sh @PROJECT@ url)
%define my_description %(./scripts/spec-get.sh @PROJECT@ description)

Name:           %{project}
Version:        @VERSION@
Release:        %autorelease
Summary:        %{summary}

Group:          %{group}
Vendor:         %{vendor}
License:        %{license}
URL:            %{url}
Source0:        %{project}

@REQUIRES@

%description
%{my_description}

%prep

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{file_roots}
cp -rv %{project} %{buildroot}%{file_roots}/%{my_name}

%check

%pre

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
%license %{file_roots}/%{my_name}/LICENSES/%{license_csv}
%doc %{file_roots}/%{my_name}/README.md
%dir %{file_roots}/%{my_name}/*
%dnl %{file_roots}/%{my_name}/*

%changelog
%dnl %autochangelog
