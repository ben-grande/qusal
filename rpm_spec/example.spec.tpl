# vim: ft=spec

# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Instructions:
#   https://rpm-software-management.github.io/rpm/manual/spec.html
#   http://ftp.rpm.org/max-rpm/s1-rpm-inside-tags.html

%define file_roots     %(./scripts/spec-get.sh @PROJECT@ file_roots)
%define my_name        %(./scripts/spec-get.sh @PROJECT@ name)
%define branch         %(./scripts/spec-get.sh @PROJECT@ branch)
%define project        %(./scripts/spec-get.sh @PROJECT@ project)
%define release        %(./scripts/spec-get.sh @PROJECT@ release)
%define summary        %(./scripts/spec-get.sh @PROJECT@ summary)
%define group          %(./scripts/spec-get.sh @PROJECT@ group)
%define vendor         %(./scripts/spec-get.sh @PROJECT@ vendor)
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

%post
if test "$1" = "1"; then
  ## Install
elif test "$1" = "2"; then
  ## Upgrade
fi

%preun
if test "$1" = "0"; then
  ## Uninstall
elif test "$1" = "1"; then
  ## Upgrade
fi

%postun
if test "$1" = "0"; then
  ## Uninstall
elif test "$1" = "1"; then
  ## Upgrade
fi

%files
%defattr(-,root,root,-)
%{file_roots}/%{my_name}/*

%changelog
%autochangelog
