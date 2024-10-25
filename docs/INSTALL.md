# Install

Qusal install and update guide.

## Table of Contents

*   [Installation](#installation)
    *   [Prerequisites](#prerequisites)
    *   [DomU Installation](#domu-installation)
    *   [Dom0 Installation](#dom0-installation)
*   [Update](#update)
    *   [DomU Update](#domu-update)
    *   [Dom0 Update with Git](#dom0-update-with-git)
    *   [Dom0 Update by literally copying the git repository](#dom0-update-by-literally-copying-the-git-repository)
*   [Template upgrade](#template-upgrade)
    *   [Clean install](#clean-install)
    *   [Upgrade a template in-place](#upgrade-a-template-in-place)

## Installation

### Prerequisites

You current setup needs to fulfill the following requisites:

*   Qubes OS R4.2
*   Internet connection

### DomU Installation

1.  Install `git` in the qube, if it is an AppVM, install it it's the
    TemplateVM and restart the AppVM.

2.  Clone the repository (if you made a fork, fork the submodule(s) before
    clone and use your remote repository instead, the submodules will also be
    from your fork).

    ```sh
    git clone --recurse-submodules https://github.com/ben-grande/qusal.git
    ```

3.  Copy the [maintainer's signing key](https://github.com/ben-grande/ben-grande/raw/main/DF3834875B65758713D92E91A475969DE4E371E3.asc)
    to your text editor and save the file to `/home/user/ben-code.asc`.

### Dom0 Installation

Before copying anything to Dom0, read [Qubes OS warning about consequences of
this procedure](https://www.qubes-os.org/doc/how-to-copy-from-dom0/#copying-to-dom0).

1.  Copy the repository `$file` from the DomU `$qube` to Dom0 (substitute
    `CHANGEME` for the desired valued):

    ```sh
    qube="CHANGEME" # qube name where you downloaded the repository
    file="CHANGEME" # path to the repository in the qube

    qvm-run --pass-io --localcmd="UPDATES_MAX_FILES=10000
      /usr/libexec/qubes/qfile-dom0-unpacker user
      ~/QubesIncoming/${qube}/qusal" \
      "${qube}" /usr/lib/qubes/qfile-agent "${file}"
    ```

2.  Pass the maintainer's key from the qube to Dom0:

    ```sh
    qvm-run --pass-io "${qube}" -- "cat /home/user/ben-code.asc" | tee /tmp/ben-code.asc
    ```

3.  Verify that the key fingerprint matches
    `DF38 3487 5B65 7587 13D9  2E91 A475 969D E4E3 71E3`. You can use
    Sequoia-PGP or GnuPG for the fingerprint verification:

    ```sh
    gpg --show-keys /tmp/ben-code.asc
    # or
    #sq inspect ben-code.asc
    ```

4.  Import the verified key to your keyring:

    ```sh
    gpg --import /tmp/ben-code.asc
    ```

5.  Verify the [commit or tag signature](https://www.qubes-os.org/security/verifying-signatures/#how-to-verify-signatures-on-git-repository-tags-and-commits)
    and expect a good signature, be surprised otherwise:

    ```sh
    git verify-commit HEAD
    ```

    In case the commit verification failed, you can try to verify if any tag
    pointing at that commit succeeds:

    ```sh
    tag_list="$(git tag --points-at=HEAD)"
    verification=0
    for tag in ${tag_list}; do
      if git verify-tag "${tag}"
        verification=1
        break
      fi
    done
    if test "${verification}" = "0"; then
      false
    fi
    ```

6.  Copy the project to the Salt directories:

    ```sh
    ~/QubesIncoming/"${qube}"/qusal/scripts/setup.sh
    ```

## Update

To update, you can copy the repository again to dom0 as instructed in the
[installation](#installation) section above or you can use easier methods
demonstrated below.

### DomU Update

Update the repository state in your DomU:

```sh
git -C ~/src/qusal fetch --recurse-submodules
```

### Dom0 Update with Git

This method is more secure than literally copying the whole directory of the
repository to dom0 but the setup is more involved. Requires some familiarity
with the sys-git formula.

1.  Install the [sys-git formula](salt/sys-git/README.md) and push the
    repository to the git server.

2.  Install `git` on Dom0, allow the Qrexec protocol to work in submodules and
    clone the repository to `~/src/qusal` (only has to be run once):

    ```sh
    mkdir -p ~/src
    sudo qubesctl state.apply sys-git.install-client
    git clone --recurse-submodules qrexec://@default/qusal.git ~/src/qusal
    ```

3.  Next updates will be pulling instead of cloning:

    ```sh
    git -C ~/src/qusal pull --recurse-submodules
    git -C ~/src/qusal submodule update --merge
    ```

4.  Verify the commit or tag signature as shown in
    [Dom0 Installation](#dom0-installation).

5.  Copy the project to the Salt directories:

    ```sh
    ~/src/qusal/scripts/setup.sh
    ```

### Dom0 Update by literally copying the git repository

This method is similar to the installation method, but easier to type. This
method is less secure than Git over Qrexec because it copies the whole
repository, including the `.git` directory which holds files that are not
tracked by git. It would be easier to distrust the downloader qube if the
project had a signed archive. The `.git/info/exclude` can exclude modified
files from being tracked and signature verification won't catch it.

1.  Install the helpers scripts and git on Dom0 (only has to be run once):

    ```sh
    sudo qubesctl state.apply dom0.install-helpers
    sudo qubes-dom0-update git
    ```

2.  Copy the repository `$file` from the DomU `$qube` to Dom0 (substitute
    `CHANGEME` for the desired valued):

    ```sh
    qube="CHANGEME" # qube name where you downloaded the repository
    file="CHANGEME" # path to the repository in the qube

    rm -rf ~/QubesIncoming/"${qube}"/qusal
    UPDATES_MAX_FILES=10000 qvm-copy-to-dom0 "${qube}" "${file}"
    ```

3.  Verify the commit or tag signature as shown in
    [Dom0 Installation](#dom0-installation).

4.  Copy the project to the Salt directories:

    ```sh
    ~/QubesIncoming/"${qube}"/qusal/scripts/setup.sh
    ```

## Template upgrade

Template upgrade refers to template major releases upgrade.

### Clean install

As we use Salt, doing clean installs are easy. Unfortunately QubesOS does not
provided a CLI program to rename qubes.

1.  Open `Qube Manager`, select the template you want to upgrade and rename it
    adding the suffix `-old`. The `Qube Manager` will change the `template`
    preference of qubes based on the chosen template.
2.  Rerun the formulas that targeted the chosen template.
3.  If the formula fails, use `Qubes Template Switcher` to set the `-old`
    template to be used by the qubes managed by that specific formula.
4.  Repeat for every template that needs to be upgraded.

### Upgrade a template in-place

This method is discouraged as it leads to different results compared to
installing a new template. Fixes done upstream by Qubes OS to the build system
of templates, such as package list, cannot be backported to old templates. In
other words, in-place upgrades leads to a different environment compared to
installing a new template.

One advantage of this method is when dealing with a StandaloneVM, as important
data can be present in the root volume, in-place upgrades are easier for this
qube class instead of doing a migration of specific folders and files to the
new qube.

1.  If you still want to do upgrade in-place, refer to upstream guides, for
    [Debian](https://www.qubes-os.org/doc/templates/debian/in-place-upgrade)
    and
    [Fedora](https://www.qubes-os.org/doc/templates/fedora/in-place-upgrade).
2.  Rerun the formulas that targeted the chosen template.
3.  Repeat for every template that needs to be upgraded.
