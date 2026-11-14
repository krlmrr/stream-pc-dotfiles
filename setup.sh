#!/usr/bin/env bash
# Set up these dotfiles on a new machine.
# Safe to run more than once: anything already in place is skipped.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

clone() { # clone <repo-url> <dir>
  if [[ -d $2 ]]; then
    echo "✓ $(basename "$2") already installed"
  else
    echo "→ Installing $(basename "$2")"
    git clone --depth=1 "$1" "$2"
  fi
}

# Packages this setup needs (asks for your password only if one is missing)
missing=()
for pkg in git stow zsh; do
  pacman -Q "$pkg" &>/dev/null || missing+=("$pkg")
done
if ((${#missing[@]})); then
  echo "→ Installing ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
else
  echo "✓ git, stow and zsh already installed"
fi

# Make zsh the login shell
ZSH_BIN="$(command -v zsh)"
if [[ $(getent passwd "$USER" | cut -d: -f7) == "$ZSH_BIN" ]]; then
  echo "✓ zsh is already your login shell"
else
  echo "→ Changing your login shell to zsh (takes effect next login)"
  chsh -s "$ZSH_BIN"
fi

# oh-my-zsh and the plugins .zshrc loads
clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Link every package into $HOME. Stow refuses (and changes nothing) if a real
# file is in the way; move that file aside and run this script again.
echo "→ Linking dotfiles"
cd "$DOTFILES"
stow -v -t "$HOME" */
echo "✓ Done"
