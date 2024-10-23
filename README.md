<p align="center">
    <img src="Assets/icon.png">
</p>
<h1 align="center">KireiSakura-Kit</h1>

<p align="center">
    KireiSakura-Kit is a library/framework based on <a href="https://www.gnu.org/software/bash">Bash</a> for making powerful shell scripts.
</p>

> "KireiSakuraKit" is combination of two Japanese words, "Kirei" and "Sakura," along with the suffix "Kit".

> `Kirei(綺麗)` means "clean" & `Sakura(桜)` refers to cherry blossoms. Together, "KireiSakura-Kit" could be interpreted as a library that emphasizes a beautiful and clean design inspired by the elegance of cherry blossoms.

## Features

- **Written in purely bash**, can be used in any POSIX shell script.
- **Mudular**, import only stuff you need.
- **Log support**, with various levels.
- **Many in-built functions**, no need to write from scratch.
- See [TODO](./TODO.md) for planned stuff.
<!-- - Various **UI elements**. -->

## Installation & setup

- Make sure you have `curl`, `grep` installed.

- Follow below steps to Install Kireisakura-Kit

### For system wide:-

- In terminal run:-

  ```bash
  curl -L https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh | bash -s -- -ds
  ```

- Then in your script, include this line at the top:-

  ```bash
  eval "$(kireisakura --init)"
  ```

### Or directly in script:-

```bash
  if command -v kireisakura &> /dev/null; then
    eval "$(kireisakura --init)"
  else
    echo "> Installing KireiSakura-Kit"
    curl -sL https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh -o kirestaller.sh
    bash kirestaller.sh
  fi
```

## Methods & Docs

- Docs To be done.
- Run `kireisakura -h` for help.
- See [my dotfiles](https://github.com/soymadip/Dotfiles/blob/dotfiles/install/start.sh) for example.

## Warning

- As of now, some part of this library is Arch-linux centric, but can be extended to any distro.
- Contribute if you find this useful and wanna make this more powerful.
