<div align="center">

# asdf-hadolint [![Build](https://github.com/devlincashman/asdf-hadolint/actions/workflows/build.yml/badge.svg)](https://github.com/devlincashman/asdf-hadolint/actions/workflows/build.yml) [![Lint](https://github.com/devlincashman/asdf-hadolint/actions/workflows/lint.yml/badge.svg)](https://github.com/devlincashman/asdf-hadolint/actions/workflows/lint.yml)


[hadolint](<TOOL HOMEPAGE>) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add hadolint
# or
asdf plugin add hadolint https://github.com/devlincashman/asdf-hadolint.git
```

hadolint:

```shell
# Show all installable versions
asdf list-all hadolint

# Install specific version
asdf install hadolint latest

# Set a version globally (on your ~/.tool-versions file)
asdf global hadolint latest

# Now hadolint commands are available
hadolint --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/devlincashman/asdf-hadolint/graphs/contributors)!
