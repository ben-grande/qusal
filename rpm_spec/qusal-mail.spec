# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

%define project         mail
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

Name:           qusal-mail
Version:        0.0.1
Release:        1%{?dist}
Summary:        Mail operations in Qubes OS
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
Requires:       qusal-sys-pgp
Requires:       qusal-utils


%description
Create a mail fetcher qube named "mail-fetcher", a mail reader qube names
"mail-reader" and a mail sender qube named "mail-sender".

The online "mail-fetcher" qube will fetch messages with POP3. After being
fetched, you can copy them to the offline "mail-reader" qube, where you will
be reading emails. After composing a message, the "mail-reader" qube will
save the messages to a queue, which can be forwarded to the online
"mail-sender" qube. You can review messages to be sent from the "mail-sender"
qube and them send them via SMTP.

By default, the protocols used required SSL, POP3 on port 995, IMAP on port
995 and SMTP on port 587. You can always override any configuration via
included files.

This formula is based on Unman's SplitMutt guide, using POP3 and/or IMAP to
get mail, not considering SSH access to the mail server. We are using
qfile-agent and not Rsync to synchronize mails between qubes to avoid a higher
attack surface, but Rsync may be considered in the future in case qfile-agent
causes problems.

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
  qubesctl state.apply mail.create
  qubesctl --skip-dom0 --targets=tpl-reader state.apply reader.install
  qubesctl --skip-dom0 --targets=tpl-mail-fetcher state.apply mail.install-fetcher
  qubesctl --skip-dom0 --targets=tpl-mail-reader state.apply mail.install-reader
  qubesctl --skip-dom0 --targets=tpl-mail-sender state.apply mail.install-sender
  qubesctl --skip-dom0 --targets=dvm-mail-fetcher state.apply mail.configure-fetcher
  qubesctl --skip-dom0 --targets=mail-reader state.apply mail.configure-reader
  qubesctl --skip-dom0 --targets=dvm-mail-sender state.apply mail.configure-sender
  qubesctl state.apply mail.appmenus,reader.appmenus
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
* Thu Jul 04 2024 Ben Grande <ben.grande.b@gmail.com> - 383c840
- doc: lint markdown files

* Fri Jun 21 2024 Ben Grande <ben.grande.b@gmail.com> - c84dfea
- fix: generate RPM Specs for Qubes Builder V2

* Tue May 14 2024 Ben Grande <ben.grande.b@gmail.com> - d148599
- doc: nested list indentation

* Mon Mar 18 2024 Ben Grande <ben.grande.b@gmail.com> - f9ead06
- fix: remove extraneous package repository updates

* Fri Feb 23 2024 Ben Grande <ben.grande.b@gmail.com> - 5605ec7
- doc: prefix qubesctl with sudo

* Mon Jan 29 2024 Ben Grande <ben.grande.b@gmail.com> - 6efcc1d
- chore: copyright update

* Sat Jan 27 2024 Ben Grande <ben.grande.b@gmail.com> - dab2979
- fix: mail qrexec policy missing disp in name

* Fri Jan 26 2024 Ben Grande <ben.grande.b@gmail.com> - a04960c
- feat: initial split-mail setup
