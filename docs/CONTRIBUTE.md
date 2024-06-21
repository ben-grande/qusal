# Contributing

Qusal contribution guidelines.

## Table of Contents

* [Respect](#respect)
* [Environment](#environment)
  * [Requirements](#requirements)
  * [RPM Spec](#rpm-spec)
  * [Lint](#lint)
* [Where to start](#where-to-start)

## Respect

Be respectful towards peers.

## Environment

You will need to setup you development environment before you start
contributing.

### Requirements

The following are the packages you need to install:

General:
- git

For writing:
- editorconfig
- editorconfig plugin for your editor
- vim, [vim-jinja](https://github.com/ben-grande/vim-jinja),
  [vim-salt](https://github.com/ben-grande/vim-salt) (recommended)

For linting:
- pre-commit
- gitlint
- salt-lint
- shellcheck
- reuse

For building RPMs:
- sed (GNU sed)
- dnf
- dnf-plugins-core (dnf builddep)
- rpm
- rpmlint
- rpmautospec (only available in Fedora)

### RPM Spec

Reference material:

- [docs.fedoraproject.org/en-US/packaging-guidelines/](https://docs.fedoraproject.org/en-US/packaging-guidelines/)
- [rpm-software-management.github.io](https://rpm-software-management.github.io/rpm/manual/spec.html)
- [rpm-packaging-guide.github.io](https://rpm-packaging-guide.github.io/)
- [rpm-guide.readthedocs.io](https://rpm-guide.readthedocs.io/en/latest/rpm-guide.html)
- [ftp.rpm.org/max-rpm/s1-rpm-build-creating-spec-file.html](http://ftp.rpm.org/max-rpm/s1-rpm-build-creating-spec-file.html)

### Lint

Lint before you commit, please... else you will have to fix after the PR has
already been sent.

Install the local hooks:
```sh
pre-commit install
gitlint install-hook
```

To run pre-commit linters:
```sh
pre-commit run
```

## Where to start

See open issues and search for the word `TODO` in the repository files.

If you want to understand how Qusal uses Salt features, read our [Salt guide](SALT.md).
