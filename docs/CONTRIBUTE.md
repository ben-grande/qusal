# Contributing

Qusal contribution guidelines.

## Table of Contents

*   [Respect](#respect)
*   [Starters](#starters)
*   [Environment](#environment)
*   [Issues](#issues)
*   [Lint](#lint)

## Respect

Be respectful towards peers.

## Starters

There are several ways to contribute to this project. Spread the word, help on
user support, review opened issues, fix typos, implement new features,
donations. Technical knowledge is not always required, if you already
understood a problem, give other users your time by linking the solution to
them.

Please read this document and every document linking from here entirely before
contributing code or to the documentation. It holds important information on
how the project is structured, why some design decisions were made and what
can be improved.

By skipping the read, there is a high change your contribution does not
conform to our guidelines and project design, therefore it is going to be
rejected. The only exception is a change of guidelines, but this is reserved
for users that has a history of contributing to the project, not for starters.

If you want to understand how Qusal uses Salt features, read our
[Salt guide](SALT.md).

To grasp how the project is structured, why some design decisions were
made and what can be improved, see the [design guide](DESIGN.md).

Experiment with some formulas, read them, understand what is being done.

## Environment

Setting up your environment is mandatory. Commits made using the Github Web
interface will be rejected.

For an automatic setup, use the [dev formula](../salt/dev), else, install the
packages below depending on the task:

For writing:

*   editorconfig
*   vim-editorconfig or the plugin for your editor
*   vim, [vim-jinja](https://github.com/ben-grande/vim-jinja),
    [vim-salt](https://github.com/ben-grande/vim-salt) (recommended)

For committing and linting:

*   [dependencies/debian.txt](../dependencies/debian.txt)
*   [dependencies/pip.txt](../dependencies/pip.txt)

For building RPMs:

*   [dependencies/rpm.txt](../dependencies/rpm.txt)

## Issues

See open issues and search for the word `TODO` in the repository files.

Look at the labels `help wanted` and `good first issue` in the issue tracking
system to get started.

## Lint

Lint before you commit, please... else you will have to fix after the PR has
already been sent, the maintainer has already read and both parties loses
time.

Install the local hooks:

```sh
pre-commit install
gitlint install-hook
```

To run pre-commit linters:

```sh
pre-commit run
```

### Maintainer's lint

Note this is only required for maintainers.

Install the `pre-push` hooks:

```sh
pre-commit install -t pre-push
```
