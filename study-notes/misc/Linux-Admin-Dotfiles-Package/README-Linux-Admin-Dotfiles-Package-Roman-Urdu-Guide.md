# Linux Admin Dotfiles Package - Roman Urdu Guide

## Package mein kya shamil hai?
- Colorful Bash prompt
- Git branch prompt mein
- Useful aliases
- Improved Bash history
- Professional `.vimrc`
- Automatic backup
- Restore script

## Installation
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

Backup yahan save hota hai:

```text
~/.dotfiles-backup-YYYYMMDD-HHMMSS/
```

## Notes
- Installer pehle backup banata hai.
- Baad mein configuration install karta hai.
- `.bashrc` reload karna zaroori hai.
