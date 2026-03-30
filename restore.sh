#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfilesbkup"

echo "Dotfiles directory: $DOTFILES_DIR"
echo "Backup directory:   $BACKUP_DIR"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory '$BACKUP_DIR' does not exist." >&2
    exit 1
fi

# バックアップディレクトリ内のドットファイルをホームへ復元
found=0
for src in "$BACKUP_DIR"/.*; do
    filename="$(basename "$src")"

    # . と .. はスキップ
    [ "$filename" = "." ] || [ "$filename" = ".." ] || [ ! -e "$src" ] && continue

    dest="$HOME/$filename"
    found=1

    # 現在のシンボリックリンクや既存ファイルを削除
    if [ -L "$dest" ]; then
        echo "Removing symlink $dest"
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        echo "Warning: $dest exists and is not a symlink. Overwriting."
        rm -f "$dest"
    fi

    echo "Restoring $src -> $dest"
    mv -f "$src" "$dest"
done

if [ "$found" -eq 0 ]; then
    echo "No dotfiles found in '$BACKUP_DIR'. Nothing to restore."
    exit 0
fi

echo "Done."
