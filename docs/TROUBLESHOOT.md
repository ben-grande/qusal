# Troubleshooting

Qusal troubleshooting guidelines.

## Table of Contents

*   [Detect if your issue was already opened](#detect-if-your-issue-was-already-opened)
*   [Qrexec client shows Request refused](#qrexec-client-shows-request-refused)
*   [Salt wrapper qubesctl command fails](#salt-wrapper-qubesctl-command-fails)
*   [Get Salt management information](#get-salt-management-information)
*   [No support for unfinished formulas](#no-support-for-unfinished-formulas)

## Detect if your issue was already opened

If you encounter any problems, search the project's
[issue tracking system](https://github.com/ben-grande/qusal/issues?q=is%3Aissue+sort%3Aupdated-desc)
for `Open` and `Closed` issues, sorted by `Recently updated`. For finer
grained search, consult the
[tracking system filter syntax](https://docs.github.com/en/issues/tracking-your-work-with-issues/filtering-and-searching-issues-and-pull-requests#using-search-to-filter-issues-and-pull-requests).

## Qrexec client shows Request refused

The Qrexec call was denied, either by a missing rule, an explicit deny or a
typo in the configuration.

Therefore, it is recommended to:

*   Check if there is a rule for the service you want to call that would
    either result in `ask` or `allow`; and
*   Check again and again if you made a typo in the policy.

The examples below will use the qube `dev` and the RPC service `qubes.GetDate`
and other common Qrexec RPC services as an example, substitute them with the
qube and service you intend to use, such as qube `code` and service
`qusal.GitInit`.

On `dom0`, watch the Qrexec policy logs:

```sh
sudo journalctl -o cat -fu qubes-qrexec-policy-daemon -S -30s
```

If you ave many simultaneous calls being shown, get only the important ones
relevant to the service you are debugging:

```sh
sudo journalctl -o cat -fu qubes-qrexec-policy-daemon -S -30s -g qubes.GetDate
```

You can emulate the call from `dom0`:

```sh
qrexec-policy dev @default qubes.GetDate
```

On the qube making the call, run the `qrexec-client-vm` command directly
rather than using a wrapper around it:

```sh
qrexec-client-vm @default qubes.GetDate
```

## Salt wrapper qubesctl command fails

The Salt Project has [troubleshooting](https://docs.saltproject.io/en/latest/topics/troubleshooting/)
page for a variety of problems you may encounter.

A nice summary of the states can be seen with the `--show-output` argument:

```sh
sudo qubesctl --show-output state.apply pkg.uptodate
```

Ending the Salt call with `-l debug` argument gives the most detailed output
(may contain private information):

```sh
sudo qubesctl state.apply pkg.uptodate -l debug
```

## Get Salt management information

Depending on the operating system of the `management_dispvm`, Salt can fail.
Let's gather some information about it.

Get information about the global `management_dispvm` and the same property of
a specific qube. In this example we use `tpl-qubes-builder`, substitute for
the qube being managed:

```sh
sudo qubesctl state.apply dom0.helpers
qvm-mgmt tpl-qubes-builder
```

## No support for unfinished formulas

If you have been redirect to this section, be aware that the formula you are
using is unfinished and no support will be provided. It is development only
and if you are not a developer, there is a chance you will find yourself lost
on how to debug and revert back to a known good state.

Again, don't try the formula if you don't know how to fix problems that may
arise.
