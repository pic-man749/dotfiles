#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfilesbkup"

echo "Dotfiles directory: $DOTFILES_DIR"
echo "Backup directory:   $BACKUP_DIR"

# バックアップフォルダを作成
mkdir -p "$BACKUP_DIR"

# サブディレクトリ以下のドットファイルを検索してリンクを張る
find "$DOTFILES_DIR" -mindepth 2 -maxdepth 2 -name '.*' -type f | while read -r src; do
    filename="$(basename "$src")"
    dest="$HOME/$filename"

    # 既存ファイル/リンクがあればバックアップ
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up $dest -> $BACKUP_DIR/$filename"
        mv -f "$dest" "$BACKUP_DIR/$filename"
    fi

    # シンボリックリンクを作成
    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
done

echo "Done."
