# Linux Admin Dotfiles Package

A practical dotfiles package for Linux administration, Bash scripting, DevOps labs, WSL, Ubuntu, Debian, RHEL, Rocky Linux, AlmaLinux, and Amazon Linux.

## Included

- Colorful Bash prompt
- Git branch in the prompt
- Useful Linux administration aliases
- Improved Bash history
- Colorized `grep`, `less`, `ls`, and manual pages
- Practical Vim configuration
- Automatic backup before installation
- Restore script

## Install

```bash
unzip Linux-Admin-Dotfiles-Package.zip
cd Linux-Admin-Dotfiles-Package
chmod +x install.sh uninstall.sh
./install.sh
source ~/.bashrc
```

## Restore

```bash
./uninstall.sh
```

Backups are saved under `~/.dotfiles-backup-YYYYMMDD-HHMMSS/`.
