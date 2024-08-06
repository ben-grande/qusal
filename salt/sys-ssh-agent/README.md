# sys-ssh-agent

SSH Agent through Qrexec in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Security](#security)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)
    *   [Server](#server)
        *   [Generate keys](#generate-keys)
        *   [Limit key usage](#limit-key-usage)
        *   [Reload agent](#reload-agent)
        *   [Debug Agent side](#debug-agent-side)
    *   [Client](#client)
        *   [Enable and Start the service](#enable-and-start-the-service)
        *   [Single agent per client](#single-agent-per-client)
        *   [Multiple agents per client](#multiple-agents-per-client)
*   [Credits](#credits)

## Description

The key pairs are stored on the offline ssh-agent server named
"sys-ssh-agent", and requests are passed from clients to the server via
Qrexec. Clients may access the same ssh-agent of a qube, or access different
agents. In other words, this is an implementation of split-ssh-agent.

The client does not know the identity of the ssh-agent server, nor are keys
kept in memory in the client. This method is ideal for cases where you have a
number of key pairs, which are used by different qubes.

A centralized SSH server is very useful not only for keeping your private keys
safe, but also for keeping your workflow organized. You can delete qubes that
are SSH clients without losing access to your remote server, because the
authentication keys are on the sys-ssh-agent server, your client qube should
only hold the SSH configuration, which can be reconstructed.

## Security

The private keys are never stored in the client qube, not even in memory, but
certain attack scenarios are still possible because there is no filtering
proxy, in fact the client controls the agent in the server it is connecting
to.

A rogue client has full control of the allowed agent, therefore it can:

1.  Use the keys for as long as the client runs;
2.  Lock the agent with `ssh-add -X`; and
3.  Delete keys from memory by issuing `ssh-add -D`

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-ssh-agent
sudo qubesctl --targets=tpl-sys-ssh-agent,sys-ssh-agent state.apply
sudo qubesctl top.disable sys-ssh-agent
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-ssh-agent.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-ssh-agent state.apply sys-ssh-agent.install
sudo qubesctl --skip-dom0 --targets=sys-ssh-agent state.apply sys-ssh-agent.configure
```

<!-- pkg:end:post-install -->

Installation on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-ssh-agent.install-client
```

## Access Control

_Default policy_: `deny` `all` requests requesting to use the
`qusal.SshAgent` RPC service.

As the default policy does not configure any allow rule, you are responsible
for doing so.

Allow access to the specified agent based on the qube tag:

```qrexecpolicy
qusal.SshAgent +work     @tag:work     @default allow target=sys-ssh-agent
qusal.SshAgent +work     @anyvm        @anyvm   deny
qusal.SshAgent +personal @tag:personal @default ask   target=sys-ssh-agent default_target=sys-ssh-agent
qusal.SshAgent +personal @anyvm        @anyvm   deny
```

Ask access from `untrusted` qubes to the untrusted agent:

```qrexecpolicy
qusal.SshAgent +untrusted untrusted    @default ask target=sys-ssh-agent default_target=sys-ssh-agent
qusal.SshAgent +untrusted @anyvm       @anyvm   deny
```

Ask access from `trusted` to use the agent `trusted` on the alternative qube
agent named `sys-ssh-agent-trusted`:

```qrexecpolicy
qusal.SshAgent +trusted    trusted     @default ask target=sys-ssh-agent-trusted default_target=sys-ssh-agent-trusted
qusal.SshAgent +trusted    @anyvm      @anyvm   deny
```

Always recommended to end with an explicit deny rule:

```qrexecpolicy
qusal.SshAgent *         @anyvm        @anyvm   deny
```

## Usage

### Server

#### Generate keys

Keys can be selectively allocated to different ssh-agents by adding them to
different directories under `~/.ssh/identities.d/<AGENT>`, where the `<AGENT>`
directory should  have the same name as the agent itself. Example:
`~/.ssh/identities.d/work`.

Import preexisting keys to the agent directory or generate keys for a specific
agent:

```sh
mkdir -m 0700 -p -- ~/.ssh/identities.d/<AGENT>
ssh-keygen -t ed25519 -f ~/.ssh/identities.d/<AGENT>/id_example
```

You would do the following for the `work` agent:

```sh
mkdir -m 0700 -p -- ~/.ssh/identities.d/work
ssh-keygen -t ed25519 -f ~/.ssh/identities.d/work/id_example
```

#### Limit key usage

For exceptionally valuable keys you may want to limit the time that they are
available and the agent forwarding permission to different hosts.

You can set custom options by writing them to a file on the same path of the
private key, but ending with the suffix `.ssh-add-option`. If the key is named
`id_ed25519`, the option file should be named `id_ed25519.ssh-add-option`.
The `.ssh-add-option` file has the following format:

```sh
# id_ed25519.ssh-add-option
-q -t 600
-h "perseus@cetus.example.org" -h "scylla.example.org"
-h "scylla.example.org>medea@charybdis.example.org"
```

Or you can manually add the key to the agent which are not located under the
`~/.ssh/identities.d` directory so they aren't automatically added (substitute
AGENT, SECS, and LIFE for their appropriate values):

```sh
SSH_AUTH_SOCK="/run/user/1000/qusal-ssh-agent/<AGENT>.sock" ssh-add -t <SECS> -f <FILE>
```

#### Reload agent

The keys are added to the agent on the first call to that specific agent.
If you have added keys to the correct agent directory but haven't rebooted
yet, you will have to add the keys by executing:

```sh
qvm-ssh-agent reload <AGENT>
qvm-ssh-agent reload work
```

#### Debug Agent side

You can list agents and their keys with:

```sh
qvm-ssh-agent ls <AGENT>
```

### Client

#### Enable and Start the service

Enable and start the connection to the SSH Agent via Qrexec for specified
`<AGENT>`:

```sh
sudo systemctl --no-block restart qusal-ssh-agent-forwarder@<AGENT>.service
sudo systemctl --no-block restart qusal-ssh-agent-forwarder@personal.service
```

You can start the service on boot if you place the above line
`/rw/config/rc.local` of the client.

The ssh-agent socket will be at `/tmp/qusal-ssh-agent-forwarder/<AGENT>.sock`.

You can test the connection is working with:

```sh
SSH_AUTH_SOCK="/tmp/qusal-ssh-agent-forwarder/personal.sock" ssh-add -l
```

#### Single agent per client

You might want to set the `SSH_AUTH_SOCK` and `SSH_AGENT_PID` environment
variables to point to the `work` agent so every connection will use the same
agent:

```sh
printf '%s\n' 'export SSH_AUTH_SOCK=/tmp/qusal-ssh-agent-forwarder/work.sock;
SSH_AGENT_PID="$(pgrep -f "/tmp/qusal-ssh-agent-forwarder/work.sock")";
' | tee -a -- ~/.profile
```

#### Multiple agents per client

In case you have multiple agents that you want to use in the same client,
messing with the environment every time you want to make a connection to a
different agent is not an alternative. Instead, use SSH client native method,
the `IdentityAgent` option.

You can control the SSH agent via SSH command-line option:

```sh
ssh -o IdentityAgent=/tmp/qusal-ssh-agent-forwarder/personal.sock personal-site.com
ssh -o IdentityAgent=/tmp/qusal-ssh-agent-forwarder/work.sock work-site.com
```

You can control the SSH agent via SSH configuration:

```sshconfig
Host personal
        IdentityAgent /tmp/qusal-ssh-agent-forwarder/personal.sock
        ...
Host work
        IdentityAgent /tmp/qusal-ssh-agent-forwarder/work.sock
        ...
```

## Credits

*   [Unman](https://github.com/unman/qusal-ssh-agent)
