# Dotfiles

My config files for an [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland) machine, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

On a fresh Omarchy install:

```sh
git clone https://github.com/krlmrr/stream-pc-dotfiles.git ~/Dotfiles
~/Dotfiles/setup.sh
```

Then log out and back in so zsh becomes your shell.

`setup.sh` is safe to run again at any time; anything already in place is skipped. It:

1. Installs `git`, `stow` and `zsh` if missing (asks for your `sudo` password only if something needs installing).
2. Makes zsh your login shell (`chsh` asks for your password).
3. Installs [oh-my-zsh](https://ohmyz.sh/) plus the [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) plugins.
4. Links every package into your home folder with Stow.

### If Stow reports a conflict

Omarchy creates its own default versions of many of these files. Stow won't overwrite a real file, so on a fresh install it will stop and list the files in the way, without changing anything. Either:

- **Use the files from this repo:** move the listed files aside (e.g. `mv ~/.config/hypr ~/.config/hypr.orig`) and run `setup.sh` again, or
- **Keep the machine's files:** run `cd ~/Dotfiles && stow --adopt -t ~ */`, which moves the existing files into the repo and links them. Then `git diff` shows how they differ, and `git checkout .` throws the machine's versions away in favor of the repo's.

## How it works

Each top-level folder is a Stow *package*, laid out the way its files sit in your home folder. Stow symlinks them into place:

```
~/Dotfiles/zsh/.zshrc                    →  ~/.zshrc
~/Dotfiles/hypr/.config/hypr/bindings.lua  →  ~/.config/hypr/bindings.lua
```

So editing `~/.config/hypr/bindings.lua` edits the file in this repo.

## Packages

| Package | What it configures |
|---|---|
| `zsh` | Shell (`.zshrc`, `.zprofile`) |
| `hypr` | Hyprland window manager, plus the screen-sharing portal and picker |
| `omarchy` | Omarchy bar/dock (`shell.json`), menu extensions, hooks, branding |
| `nvim` | Neovim (LazyVim) |
| `ghostty` | Terminal |
| `herdr-app` | Herdr desktop app: keybindings, settings, and the `prefix-mine` mod (Ctrl+B prefix with the Herdr TUI's default keys) |
| `git` | Git aliases and settings |
| `btop`, `lazygit`, `imv`, `mise`, `herdr`, `opencode` | Individual app settings |
| `fcitx5`, `xcompose` | Input method and compose-key shortcuts |
| `wireplumber` | Audio (Bluetooth auto-connect, keeping USB speakers awake) |
| `autostart`, `environment`, `mimeapps`, `gtk`, `qtengine`, `chromium` | Startup apps, environment variables, default apps, file-manager bookmarks, Qt and Chromium flags |
| `agents` | Shared instructions for coding agents (`~/.agents/AGENTS.md`) |

Omarchy-managed things are deliberately left out: installed themes and plugins, the current-theme symlinks, and anything with credentials or app state.

## Everyday use

```sh
# Save changes
cd ~/Dotfiles && git add -A && git commit -m "…" && git push

# Add a new config (example: ~/.config/foo)
mkdir -p ~/Dotfiles/foo/.config
mv ~/.config/foo ~/Dotfiles/foo/.config/
cd ~/Dotfiles && stow -t ~ foo

# Remove a package's links (files stay in the repo)
cd ~/Dotfiles && stow -D -t ~ foo
```

Some tools save settings by replacing the file, which turns the symlink back into a normal file. To pull that change back into the repo:

```sh
cd ~/Dotfiles && stow --adopt -t ~ hypr && git diff
```
