# mail

Mail operations in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Security](#security)
*   [Installation](#installation)
*   [Usage](#usage)
    *   [Fetcher](#fetcher)
        *   [fdm Configuration](#fdm-configuration)
        *   [mpop Configuration](#mpop-configuration)
        *   [OfflineIMAP Configuration](#offlineimap-configuration)
        *   [Send Inbox to Reader Qube](#send-inbox-to-reader-qube)
    *   [Reader](#reader)
        *   [Mutt Configuration](#mutt-configuration)
        *   [Send Queue to Sender Qube](#send-queue-to-sender-qube)
    *   [Sender](#sender)
        *   [msmtp Configuration](#msmtp-configuration)
        *   [Send emails to SMTP server](#send-emails-to-smtp-server)
*   [Credits](#credits)

## Description

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

## Security

Mail is insecure per nature and users depend on archaic Unix tools that
[receive little to no maintenance](https://xkcd.com/2347/).

The qubes connected to the internet `mail-fetcher` and `mail-sender` hold the
account password to connect to the remote servers. If any of those are
compromised, your mail account can also be. Network firewall can help, to
some extent, if you consider the attacker doesn't have an account on the same
mail server you have, or sends a message from you mail account to an attacker
controlled mail and then delete from your sent messages.

The reader qube `mail-reader` also has a high attack surface. Although
offline, it can access PGP keys via split-gpg2 and also read all your mails,
in case an especially crafted message exploits the parsing of the message. We
are using `Mutt`, but if you know how to choose local folders in `Mozilla
Thunderbird`, you can adapt the formula. Neither MUA have great security
records, but `Mutt` has less and is more minimal. The reader should be a
secure mail client, but there are none. `Mutt` will open `text/html` and
`text/plain` files, while every other type of file is opened in a disposable
qube. See [reader](../reader/README.md) for offline disposables that can open
some kinds of files.

If you want to read the mail in the sender qube `mail-sender`, you may want to
do this before sending to the mail server, you should open the file in a
disposable to avoid a parsing bug in the editor to extract information such as
the password from the sender qube. This method doesn't prevent all kinds of
exploitation, as `msmtp` still needs to parse the mail to be sent.

## Installation

*   Top:

```sh
sudo qubesctl top.enable mail reader
sudo qubesctl --targets=tpl-mail-fetcher,tpl-mail-reader,tpl-mail-sender,dvm-mail-fetcher,mail-reader,dvm-mail-sender,tpl-reader state.apply
sudo qubesctl top.disable mail reader
sudo qubesctl state.apply mail.appmenus,reader.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply mail.create
sudo qubesctl --skip-dom0 --targets=tpl-reader state.apply reader.install
sudo qubesctl --skip-dom0 --targets=tpl-mail-fetcher state.apply mail.install-fetcher
sudo qubesctl --skip-dom0 --targets=tpl-mail-reader state.apply mail.install-reader
sudo qubesctl --skip-dom0 --targets=tpl-mail-sender state.apply mail.install-sender
sudo qubesctl --skip-dom0 --targets=dvm-mail-fetcher state.apply mail.configure-fetcher
sudo qubesctl --skip-dom0 --targets=mail-reader state.apply mail.configure-reader
sudo qubesctl --skip-dom0 --targets=dvm-mail-sender state.apply mail.configure-sender
sudo qubesctl state.apply mail.appmenus,reader.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You will use local files to override the ones provided by this package. Few
options must be set. Do not change the directories in the configuration
files, they need to stay the same.

You should firewall the `mail-fetcher` and `mail-sender` to the `POP3` server
or/and `IMAP` server and `SMTP` server, respectively.

Steps overview:

1.  Receive mail via the `mail-fetcher` and transfer mail to `mail-reader`.
2.  Read and compose mail from `mail-reader` and transfer to `mail-sender`.
3.  Send queued mails from `mail-sender` to remote mail server.

### Fetcher

The fetcher fetches e-mails with `fdm` or `mpop` via the POP3 protocol or even
`offlineimap` via the IMAP protocol, you only need to choose one program for
this task, depending on your needs.

The configuration must be done in `dvm-mail-fetcher`, while the fetching of
mails will be done in `disp-mail-fetcher`.

#### fdm Configuration

Copy example configuration file to where the program can read automatically:

```sh
cp -- ~/.fdm.conf.example ~/.fdm.conf
```

Edit the configuration according to your needs:

```sh
editor ~/.fdm.conf
```

Check the connection is working:

```sh
fdm -kv poll
```

Fetch mail:

```sh
fdm -kv fetch
```

If the fetch was successful, enable the fetch scheduler:

```sh
systemctl --user enable fdm.timer
systemctl --user start  fdm.timer
```

#### mpop Configuration

Copy `~/.mpoprc.example` to `~/.mpoprc` and edit the configuration
according to your needs.

Copy example configuration file to where the program can read automatically:

```sh
cp -- ~/.mporc.example ~/.mpoprc
```

Edit the configuration according to your needs:

```sh
editor ~/.mpoprc
```

Check the connection is working:

```sh
mpop --debug --auth-only
```

Fetch mail:

```sh
mpop
```

If the fetch was successful, enable the fetch scheduler:

```sh
systemctl --user enable mpop.timer
systemctl --user start  mpop.timer
```

#### OfflineIMAP Configuration

TODO: difficult to exemplify as the folders are user and provider specific.

#### Send Inbox to Reader Qube

Send the inbox to the reader:

```sh
qusal-send-inbox
```

### Reader

The reader renders e-mails with `mutt`.

The configuration as well as the reading and composing of mails are done in
`mail-reader`.

#### Mutt Configuration

You must place your credentials in `~/.muttrc-credentials.local`, definitions
in this file will be used by scripts sourced at a later time.

You should define aliases only in `~/.muttrc-aliases.local`, as the aliases
file can be edited by Mutt.

You can define extra options in `~/.muttrc.local`, as this is the last file to
be sourced, it can override previous options.

If you want to have your e-mail signature (not PGP) at the end of every mail
you send, place it in `~/.signature`.

Samples for the aforementioned files can be found at `~/.config/mutt/sample`.

#### Send Queue to Sender Qube

Send the queued mail to the sender:

```sh
qusal-send-mail
```

### Sender

The sender sends e-mails with `msmtp` via the SMTP protocol.

The configuration must be done in `dvm-mail-sender`, while the sending of
mails are done in `disp-mail-sender`.

#### msmtp Configuration

Copy example configuration file to where the program can read automatically:

```sh
cp -- ~/.msmtprc.example ~/.msmtprc
```

Edit the configuration according to your needs:

```sh
editor ~/.msmtprc
```

Test the connection to the SMTP server:

```sh
msmtp --serverinfo
```

#### Send emails to SMTP server

List the queued mails:

```sh
msmtp-queue -d
```

Send selected mails from the queue to the SMTP server:

```sh
msmtp-queue -R
```

## Credits

*   [Unman](https://github.com/unman/notes/blob/master/SplitMutt.md)
