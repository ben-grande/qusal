# sys-cacher

Caching proxy server for software repositories in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access control](#access-control)
* [Usage](#usage)
  * [Report Page and Maintenance Tasks](#report-page-and-maintenance-tasks)
  * [Connect to the cacher via IP instead of Qrexec](#connect-to-the-cacher-via-ip-instead-of-qrexec)
  * [Non-TemplateVMs integration](#non-templatevms-integration)
* [Uninstallation](#uninstallation)
* [Credits](#credits)

## Description

The caching proxy is "sys-cacher" based on apt-cacher-ng, it stores downloaded
packages, so that you need only download a package once for it to be used when
updating many  The proxy is preconfigured to work out of the box
for Debian, Ubuntu, Arch, and Fedora

When you install this package, qubes will be tagged with "updatevm-sys-cacher"
and they will be altered to use the proxy by default. When there is "https://"
in your repository definitions, the entries will be changed in the templates
from to "http://HTTPS///". This is so that the request to the proxy is plain
text, and the proxy will then make the request via https.

This change will be done automatically for every template that exists and is
not Whonix based. No changes are made to Whonix templates, and updates to
those templates will not be cached.

The caching proxy supports Debian derivatives (not Whonix) and Arch Linux.
Fedora support was dropped due to unreliability of the mirror mechanism of
zchunk checksums when caching packages.

## Installation

Installation may take a long time as it will target all templates unless you
specify otherwise.

- Top
```sh
sudo qubesctl top.enable sys-cacher browser
sudo qubesctl --targets=tpl-browser,sys-cacher-browser,tpl-sys-cacher,sys-cacher state.apply
sudo qubesctl top.disable sys-cacher browser
sudo qubesctl state.apply sys-cacher.appmenus,sys-cacher.tag
sudo qubesctl --skip-dom0 --targets="$(qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher | tr "\n" ",")" state.apply sys-cacher.install-client
```

- State
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply sys-cacher.create
sudo qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
sudo qubesctl --skip-dom0 --targets=tpl-sys-cacher state.apply sys-cacher.install
sudo qubesctl --skip-dom0 --targets=sys-cacher state.apply sys-cacher.configure
sudo qubesctl --skip-dom0 --targets=sys-cacher-browser state.apply sys-cacher.configure-browser
sudo qubesctl state.apply sys-cacher.appmenus,sys-cacher.tag
sudo qubesctl --skip-dom0 --targets="$(qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher | tr "\n" ",")" state.apply sys-cacher.install-client
```
<!-- pkg:end:post-install -->

## Access control

The distributed policy will take precedence over the ones set during first
installation or the GUI Global Config. If you want to use `sys-cacher`
and edit configuration for certain qubes to update over different proxys, you
can do so.

Allow qubes with tag `whonix-updatevm` to use the proxy in `sys-alt-whonix`
and qube `dev` to use the proxy in `disp-sys-net`.
```qrexecpolicy
qubes.UpdatesProxy * @tag:whonix-updatevm @default allow target=sys-alt-whonix
qubes.UpdatesProxy * @tag:whonix-updatevm @anyvm   deny
qubes.UpdatesProxy * dev @default allow target=disp-sys-net
qubes.UpdatesProxy * dev @anyvm   deny
```

## Usage

### Report Page and Maintenance Tasks

The report page is available from `sys-cacher` and `sys-cacher-browser` at
`http://127.0.0.1:8082/acng-report.html` and any other client qube that has
`sys-cacher` as it's update qube. This is apt-cacher-ng limitation and is bad
security wise, every client has administrative access to the cacher qube.  You
should add the following to the end of `sys-cacher` rc.local:
```sh
echo "AdminAuth: username:password" | tee /etc/qubes-apt-cacher-ng/zzz_security.conf
```
Where username and password are HTTP Auth strings.

If you want to view statistics or manage the server through a GUI, open
`sys-cacher` or `sys-cacher-browser` desktop file `cacher-browser.desktop`
from Dom0. Addresses starting with `http` or `https` will be redirected
to `sys-cacher-browser`.

The browser separation from the server is to avoid browsing malicious sites
and exposing the browser to direct network on the same machine the server is
running. The browser qube is offline and only has access to the admin
interface. In other words, it has control over the server functions, if the
browser is compromised, it can compromise the server.

### Connect to the cacher via IP instead of Qrexec

Because the `sys-cacher` qube is listening on port `8082`, you can use it from
non-template qubes and qubes that do not have a working Qrexec. Use the native
configuration to set the update proxy using the IP address of `sys-cacher` by
setting `sys-cacher` as the netvm of the client qube.

Set `sys-cacher` as the netvm of your qube:
```sh
qvm-prefs QUBE netvm sys-cacher
```

Enable the service `netvm-cacher`:
```sh
qvm-features QUBE service.netvm-cacher 1
```

Copy [apt-cacher-ng-repo](files/client/bin/apt-cacher-ng-repo) to your qube
and set the script to run on boot. Make sure that the file
`/var/run/qubes-service/netvm-cacher` exists on every startup for the proxy
address change take effect.

The qube has to be restarted for changes to take effect.

### Non-TemplateVMs integration

**Attention**: this method will allow a client qube to bypass the qubes
firewall and connect to a remote host via the updates proxy.

By default, only templates will use the proxy to update, if you want to cache
non-TemplateVMs updates or simply make them functional again, the qube will
need the `service.updates-proxy-setup` feature set:
```sh
qvm-tags add QUBE updatevm-sys-cacher
qvm-features QUBE service.updates-proxy-setup 1
sudo qubesctl --skip-dom0 --targets=QUBE state.apply sys-cacher.install-client
```
Don't forget to restart the qube.

If you don't want or can't restart the qube, such as DispVMs, where you would
lose the current session:
```sh
qvm-tags add QUBE updatevm-sys-cacher
qvm-features QUBE service.updates-proxy-setup 1
qvm-run --user=root QUBE -- "
touch /var/run/qubes-service/updates-proxy-setup
/usr/bin/apt-cacher-ng-repo
systemctl restart qubes-updates-proxy-forwarder.socket"
sudo qubesctl --skip-dom0 --targets=QUBE state.apply sys-cacher.install-client
```

## Uninstallation

- Top:
```sh
sudo qubesctl top.enable sys-cacher.deinit
sudo qubesctl --targets="$(qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher | tr "\n" ",")" state.apply
sudo qubesctl top.disable sys-cacher.deinit
sudo qubesctl state.apply sys-cacher.untag
```

- State:
```sh
sudo qubesctl state.apply sys-cacher.remove-policy
sudo qubesctl --skip-dom0 --targets="$(qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher | tr "\n" ",")" state.apply sys-cacher.uninstall-client
sudo qubesctl state.apply sys-cacher.untag
```

If you want to use the standard proxy for a few qubes, only uninstall it
from the templates that you don't want to cache packages:
```sh
sudo qubesctl --skip-dom0 --targets=QUBE state.apply sys-cacher.uninstall-client
qvm-tags del QUBE updatevm-sys-cacher
```

If you tagged manually a qube that is unsupported, updates for that qube will
fail. Get a full list of unsupported qubes (**warning**: there may be false
positives of supported qubes being listed):
```sh
sudo qubesctl --show-output state.apply sys-cacher.list-extra-tag
```

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/cacher)
