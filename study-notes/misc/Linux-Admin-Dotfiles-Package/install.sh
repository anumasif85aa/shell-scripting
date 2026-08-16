#!/usr/bin/env bash
set -Eeuo pipefail
PACKAGE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME/.dotfiles-backup-$TIMESTAMP"
CONFIG_DIR="$HOME/.config/linux-admin-dotfiles"
BASHRC="$HOME/.bashrc"
BEGIN='# >>> linux-admin-dotfiles >>>'
END='# <<< linux-admin-dotfiles <<<'

mkdir -p "$BACKUP_DIR" "$CONFIG_DIR"
for file in "$HOME/.bashrc" "$HOME/.bash_aliases" "$HOME/.vimrc"; do
  [[ -e "$file" ]] && cp -a "$file" "$BACKUP_DIR/"
done
cp "$PACKAGE_DIR/bash/bashrc-admin.sh" "$CONFIG_DIR/"
cp "$PACKAGE_DIR/bash/aliases.sh" "$CONFIG_DIR/"
cp "$PACKAGE_DIR/vim/vimrc" "$HOME/.vimrc"
touch "$BASHRC"
awk -v b="$BEGIN" -v e="$END" '$0==b{skip=1;next}$0==e{skip=0;next}!skip{print}' "$BASHRC" > "$BASHRC.tmp"
mv "$BASHRC.tmp" "$BASHRC"
cat >> "$BASHRC" <<EOT

$BEGIN
[[ -r "\$HOME/.config/linux-admin-dotfiles/bashrc-admin.sh" ]] && source "\$HOME/.config/linux-admin-dotfiles/bashrc-admin.sh"
$END
EOT
printf '%s\n' "$BACKUP_DIR" > "$CONFIG_DIR/latest-backup"
echo "Installed successfully."
echo "Backup: $BACKUP_DIR"
echo "Run: source ~/.bashrc"
