<p align="center">
    <img src="Assets/icon.png" width="190px">
    <h1 align="center">KireiSakura-Kit</h1>
</p>

<p align="center">
    <big>KireiSakura-Kit is a library written in <a href="https://www.gnu.org/software/bash">Bash</a> for making powerful shell scripts.</big>
</p>
<br>

> "KireiSakura-Kit" is combination of two Japanese words, "Kirei" and "Sakura," along with the suffix "Kit".</br>
> `Kirei(綺麗)` means "clean" & `Sakura(桜)` refers to cherry blossoms. Together, "KireiSakura-Kit" could be interpreted as a library that emphasizes a beautiful and clean design inspired by the elegance of cherry blossoms.

## Features

- **Written in purely bash**, can be used in POSIX*[^1] shell script.
- **Mudular**, import only stuff you need.
- **Log support**, with various levels.
- **Many in-built functions**, no need to write from scratch.
- See [TODO](./TODO.md) for planned stuff.
<!-- - Various **UI elements**. -->


[^1]: We officially support Bash and Zsh. Other POSIX-compliant shells should work too but are not officially supported. However, any pull requests will be accepted.

## Installation & setup

- Make sure you have `curl`, `grep` installed.

- Follow below steps to Install Kireisakura-Kit

### For system wide

- In terminal run:-

  ```bash
  curl -L https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh | bash -s
  ```

- Then in your script, include this line at the top:-

  ```bash
  eval "$(kireisakura --init)"
  ```

### For directly using in script

- This will check if Kit is installed or download & setup KireiSakura-Kit.

```bash
  if command -v kireisakura &> /dev/null; then
    eval "$(kireisakura --init)"
  else
    echo "> Installing KireiSakura-Kit"
    curl -sSL https://raw.githubusercontent.com/soymadip/KireiSakura-Kit/refs/heads/install/install.sh -o kirestaller.sh
    bash kirestaller.sh -ds
  fi
```

## Methods & Docs

- Docs To be done.
- Run `kireisakura -h` for help.
- See [my dotfiles](https://github.com/soymadip/Dotfiles) for example.

## Warning

- MAJOR CHANGES ARE BEING MADE as this project is in alpha, so be careful.
- As of now, some part of this library is Arch-linux centric, but can be extended to any distro.
- Contribute if you find this useful and wanna make this more powerful.
