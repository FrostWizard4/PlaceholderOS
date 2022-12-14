# MinimaOS

[![Makefile CI](https://github.com/frostwizard4/Hermes/actions/workflows/makefile.yml/badge.svg)](https://github.com/frostwizard4/Hermes/actions/workflows/makefile.yml)

## Setup

> **Note** -
> compilation is guaranteed only on linux & co, but
> it is also possible in windows with virtualization
> solutions like wsl (on windows 11) or hyperV

### Makefile Information

```bash
# Install dependencies (Only on a distro using apt)
make dependencies

# Build all temporary and permanent files
make

# Build all and run
make run

# Clean intermediary files
make clean

# Show all commands
make info
```


## Source & Acknowledgment
* [os-tutorial](https://github.com/cfenollosa/os-tutorial) for the original tutorial
* [Writing a Simple Operating System -- from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf) for yet more gory introductory details
* [irc.libera.chat:#osdev](https://libera.irclog.whitequark.org/osdev)
