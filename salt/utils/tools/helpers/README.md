# helpers

Add helper scripts.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Wrappers that help run applications available, either being terminals,
browsers, file manager or mail user agents. It is possible to try a specific
program by setting environment variables specific to each helper.

## Installation

*   Top:

```sh
sudo qubesctl top.enable utils.tools.helpers
sudo qubesctl --targets=TARGET state.apply
sudo qubesctl top.disable utils.tools.helpers
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATEVMS,APPVMS state.apply utils.tools.helpers
```

<!-- pkg:end:post-install -->

## Usage

Open a terminal:

```sh
run-terminal
```

Open a browser:

```sh
run-browser https://example.org
```

Open mail user agent program:

```sh
run-mail
```

Open file manager on a specific directory:

```sh
run-file-manager ~/
```
