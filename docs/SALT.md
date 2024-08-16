# Salt

Qusal SaltStack development guide.

## Table of Contents

*   [What this guide is](#what-this-guide-is)
*   [Resources](#resources)
*   [Minion Configuration](#minion-configuration)
*   [Jinja](#jinja)
*   [Targeting Minions](#targeting-minions)
*   [Idempotence](#idempotence)
*   [Examples](#examples)
*   [Troubleshooting](#troubleshooting)

## What this guide is

This guide is an introduction to the use of SaltStack in Qusal. It is in no
way anything other than that, it is not a beginner's instructional guide to
the use of Salt in Qubes OS or any other project, although it may share some
similarities. It is not meant to substitute our other guidelines,
[contribution](CONTRIBUTE.md) and [design](DESIGN.md) rules still apply.

If you just want to understand SaltStack, upstream provides an
[excellent tutorial](https://docs.saltproject.io/en/getstarted/system/index.html),
don't worry if you don't understand everything, Qubes OS SaltStack integration
abstracts the client to server communication, only remaining to you to [learn
how to write states](https://docs.saltproject.io/en/getstarted/config/index.html)
and [how to correctly apply them](https://docs.saltproject.io/en/latest/topics/targeting/index.html),
in Qubes OS case, install of running salt-call directly, use
[qubesctl](https://www.qubes-os.org/doc/salt/#salt-configuration-qubesos-layout).

## Resources

We follow all of the rules dictated by [Salt Best Practices](https://docs.saltproject.io/en/latest/topics/best_practices.html)
documentation. We must not write the code to only be read by the code authors,
but to anyone that understands Salt. Bugs are common in code that is obscure
and takes effort to read, aim for clarity and modularity, use a `files`
directory to place files that are going to be applied to the minions. All
other rules also apply.

A list of Salt's [Execution Modules](https://docs.saltproject.io/en/latest/ref/modules/all/)
and [State Modules](https://docs.saltproject.io/en/latest/ref/states/all/) are
good indexes to find the desired module, but you may not recognize the module
that you need this way, you may need to find examples in our code or available
in the internet.

Qubes OS provides [qvm State Modules](https://github.com/QubesOS/qubes-mgmt-salt-dom0-qvm/blob/main/README.rst),
we are using it to manage qubes properties.

## Minion Configuration

We chose to set [some minion configuration](../minion.d/), such as
[file_roots](https://docs.saltproject.io/en/latest/ref/configuration/minion.html#file-roots)
for us to own the directory, in other words, we expect only our project files
to be deployed in the configured minion root directory, we can clean it on an
update without worrying of deleting user settings.

Note that on Qubes OS, every qube is a minion, including dom0.

## Jinja

[Jinja](https://jinja.palletsprojects.com/) is the [default templating language](https://docs.saltproject.io/en/latest/topics/jinja/index.html#include-and-import)
in SLS files.

We use [Jinja includes and imports](../salt/debian-minimal/template.jinja) and
[Jinja macros](../salt/utils/macros) to share reusable state
configuration, thus avoiding code duplication, allowing us to apply a state
always the same way between files in the same or different projects.

## Targeting Minions

You can target minions in two ways, with a [top file](https://docs.saltproject.io/en/latest/ref/states/top.html)
or specifying the states on the command-line.

We use [top files](../salt/sys-git/init.top) to be able to execute a state in
multiple qubes in a single call, with the powers of advanced minion targeting,
we can [match properties of a qube](../salt/debian/install.top) to
apply the state depending on its name, its type and many other settings, by
specifying the minion minion IDs in a list, globbing per name, PCRE matching a
minion ID and many other match types.

## Idempotence

We always use Salt modules when possible, even for simple tasks such as
[creating a directory](../salt/sys-git/install.sls). Not all systems supports
the same `mkdir` options, we delegate this task to the Salt module
[file.directory](https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html#salt.states.file.directory),
it them becomes responsible to find out how to apply the desired state to the
wanted directory.

Specific modules are preferred over the [cmd
module](https://docs.saltproject.io/en/latest/ref/states/all/salt.states.cmd.html)
as they only apply the changes that are necessary, skipping what is already in
the desired state and provide a human and machine-readable output of what has
been done, changed or not.

The `cmd` state might still be needed in some circumstances:

*   When Qubes OS does not provide a module;
*   When SaltStack does provide a module; and
*   When SaltStack module does not meet all requirements.

## Examples

If you have followed along until now, you are ready to start experimenting.

Let's create a qube to hold our private keys and passwords. Create the
following SLS files. The contents can be copied from the below example. Please
make sure to install Qusal before, it is required to create the base
templates, do Jinja imports and run Jinja macros.

`create-keys.sls`:

```salt
{# Use Qubes OS Jinja Template to create qubes using 'qvm.vm' #}
{% from "qvm/template.jinja" import load %}

{# From our Jinja template clone-template, import 'clone_template' macro #}
{% from 'utils/macros/clone-template.sls' import clone_template -%}
{# Run the 'clone_template' macro to clone 'debian-minimal' to 'tpl-keys' #}
{{ clone_template('debian-minimal', 'keys') }}

{# Load the following block as an YAML to the 'defaults' variable #}
{% load_yaml as defaults -%}
name: keys
{# Enforce qube settings #}
force: True
{# Only run this state if the requirements are executed successfully #}
require:
  {# Ensure successful 'qvm.clone' run to create 'tpl-keys-clone' #}
  {# This module was executed in the 'clone_template' macro #}
  - qvm: tpl-keys-clone
{# If qube does not exist, create it with the specified settings #}
present:
  {# Set it to an updated Debian version #}
  - template: tpl-keys
  {# We must assign a high trust to this qube, it holds important data #}
  - label: black
{# Set qube preferences after it was created with the 'present' state #}
prefs:
  {# Enforce qube template after it was created #}
  - template: tpl-keys
  {# Enforce qube label after it was created #}
  - label: black
  {# Audio is not necessary for a keys qube, remove it #}
  - audiovm: ""
  {# Networking is not necessary for a keys qube, remove it #}
  - netvm: ""
  {# We want it backed up by default #}
  - include_in_backups: True
{# Set qube features after it was created with the 'present' state #}
features:
  {# Disable unwanted features #}
  - disable:
    {# Printing is not necessary for a keys qube, remove it #}
    - service.cups
  {# Set feature values, useful for string values #}
  - set:
    {# Help GUI users find useful applications for this qube #}
    - menu-items: "org.keepassxc.KeepPassXC.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
{# Stop loading to the 'defaults' variable #}
{% endload %}
{# Run the 'load' macro of 'qvm/template.jinja' with the value 'defaults' #}
{{ load(defaults) }}
```

`install-keys.sls`:

```salt
{# Avoid applying the state by mistake to dom0 #}
{% if grains['nodename'] != 'dom0' %}

{# Always update the package list before trying to install any package #}
include:
  - utils.tools.common.update

{# Install packages using Salt's pkg.installed module #}
keys-installed:
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    {# Enforce that we don't want to install recommended packages #}
    - install_recommends: False
    {# Enforce that we don't want to install suggested packages #}
    - skip_suggestions: True
    {# List of packages to be installed #}
    - setopt: "install_weak_deps=False"
    - pkgs:
      {# Wait, some package names do not match on different distributions #}
      - keepassxc
      - gnupg2

{# The package name can be specified for different OSes depending on grains #}
{% set pkg = {
  'Debian': {
    'pkg': ['sq', 'openssh-client'],
  },
  'RedHat': {
    'pkg': ['sequoia-sq', 'openssh-clients'],
  },
}.get(grains.os_family) %}

{# Install the packages specific to the OS that this state is being applied #}
keys-installed-os-specific:
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    {# Get the Jinja variable 'pkg.pkg' and convert it to an YAML list #}
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{# End our 'if' statement created above #}
{% endif %}
```

`appmenus-keys.sls`:

```salt
{# From our Jinja template sync-appmenus, import 'sync_appmenus' macro #}
{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus %}
{# Run the 'sync_appmenus' macro to synchronize the application list #}
{{ sync_appmenus('tpl-keys') }}
```

After you have created the states above, copy them to Dom0 in `/srv/salt`.

Create the qube:

```sh
sudo qubesctl state.apply create-keys
```

Install packages in the qube template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-keys state.apply install-keys
```

Make the application menus appear after the requirements are installed:

```sh
sudo qubesctl state.apply appmenus-keys
```

Congratulations, you have applied you first desired state with the benefit of
Qusal macros. The above examples are based on our [vault formula](../salt/vault).

## Troubleshooting

You may face some [YAML idiosyncrasies](https://docs.saltproject.io/en/latest/topics/troubleshooting/yaml_idiosyncrasies.html),
these are the common mistakes that you may commit. Use an editor that:

*   Shows when tabs have been used instead of spaces;
*   Highlights syntax for Salt, Jinja, Python, YAML and Shellscript; and
*   Lints your file at will or when saving it;

For further debugging information on Qusal, read our
[troubleshooting guide](TROUBLESHOOT.md).
