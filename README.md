# gregify

Bootstraps an Apple Silicon Mac into Greg's development environment: Homebrew packages from a
Brewfile (6 taps, 50 formulas, 11 casks), oh-my-zsh with two extra plugins, Ruby 3.3.6 via rbenv,
Node 22.18.0 via nvm, and every shell, Neovim, git, fzf, and iTerm wrapper config file symlinked
from this repo into `$HOME`.

## New machine

1. Install Xcode Command Line Tools: `xcode-select --install`.
2. Generate an SSH key (`ssh-keygen -t ed25519`), add the public key to GitHub, and confirm with
   `ssh -T git@github.com`. This is required before cloning: the tracked git config rewrites every
   `https://github.com/` URL to `git@github.com:`, so without a key Neovim's first launch fails
   (lazy.nvim's bootstrap clone) and every HTTPS clone after the installer runs fails.
3. `mkdir -p ~/Personal && git clone git@github.com:bgreg/gregify.git ~/Personal/gregify`
4. `~/Personal/gregify/dotfiles.sh`. It prompts for a git name and email if none is found.
5. `exec zsh`
6. `~/Personal/gregify/test-dotfiles.sh`. Expect `Failed: 0`. One warning about `git-lfs` is
   normal: the tracked git config requires the LFS filter and the Brewfile does not install
   `git-lfs`.
7. `gh auth login`
8. iTerm2 → Install Shell Integration.
9. `brew services start postgresql@17 redis` if this machine runs them.
10. Log out and back in for the key repeat change.

The installer sets `KeyRepeat` to 0 and `InitialKeyRepeat` to 10 (the fastest values). To reverse
it, run `defaults write -g KeyRepeat -int 60; defaults write -g InitialKeyRepeat -int 120` (this
Mac's values before the installer ran), then log out and back in.

Re-running `dotfiles.sh` is safe. Anything it displaces is moved to `<path>.backup.<timestamp>`.
It never deletes.

## Layout

| Path | Purpose |
|---|---|
| `dotfiles.sh` | Installer. Holds the `LINKS` map and the pinned Ruby and Node versions. `--print-links` prints the map. |
| `test-dotfiles.sh` | Validator. Sources `dotfiles.sh` so it checks the same map and versions. |
| `Brewfile` | Package manifest. |
| `home/` | Files linked into `~` (`.zshenv`). |
| `config/` | Files linked into `~/.config` and `~/bin`, mirroring their destination paths. |
| `e2e/` | Docker end-to-end test. See `e2e/README.md`. |
| `spec/` | shellspec unit tests: `shellspec`. |

## Adding a package

```bash
brew install <formula>
brew bundle dump --force --no-vscode --file=Brewfile
```

The dump does not preserve four manual edits. Re-apply them:

1. Strip the description comment lines: `sed -i '' '/^#/d' Brewfile`.
2. Drop any `restart_service:` options.
3. Drop the `npm "corepack"` line.
4. Re-add `brew "keith/formulae/reminders-cli", trusted: true` if the dump dropped it (Homebrew
   skips untrusted taps when dumping).

This Mac still has the taps `homebrew/services` (deprecated, empty) and `sass/sass` (rejected as
invalid by Homebrew 7). A fresh Homebrew refuses both, and the dump re-adds them. Delete those two
`tap` lines, or run `brew untap sass/sass homebrew/services` once on this Mac so future dumps stay
clean. Nothing installed here comes from either tap.

Commit.

## Changing config

Edit the file at its normal path (`~/.config/nvim/init.lua`, `~/.config/oh-my-zsh/custom/aliases.zsh`).
It is a symlink into this repo, so `git status` here shows the change. Commit and push; `git pull`
on the other machine picks it up.

## Not tracked

`~/.config/git/config.local` (identity, written by the installer), `~/.gitconfig-taskrabbit`,
`~/.config/gh`, `~/.config/gcloud`, shell history, completion caches, the iTerm2 integration
script, and the Python scripts under `~/.config/zsh/scripts/`.

## Tests

```bash
shellspec          # unit tests for the installer and validator (27 examples)
e2e/run.sh         # full install in Docker
```

The first `e2e/run.sh` run builds the image and takes several minutes. Later runs with
`E2E_SKIP_BUILD=1` take about five minutes.
