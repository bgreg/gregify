# Docker e2e

`e2e/run.sh` builds an Ubuntu arm64 image that fakes the parts of macOS the installer touches,
bind-mounts this repo at `/home/greg/Personal/gregify` (read-write, as on a real machine; lazy.nvim
rewrites `lazy-lock.json` on restore), and runs three phases. Each must exit 0:

1. `bash ~/Personal/gregify/dotfiles.sh` from an empty home.
2. `zsh -li -c ~/Personal/gregify/test-dotfiles.sh`, the same validator the Macs run.
3. `zsh -li -c ~/Personal/gregify/e2e/inspect.sh`, which checks links, packages, the interactive
   shell, Neovim, git config, the `defaults` calls, and a second idempotent install run.

After a run, `git status --porcelain` may show `config/nvim/lazy-lock.json` modified: `Lazy! restore`
rewrites the lazy.nvim pin because the bootstrap in `init.lua` clones `--branch=stable` while the lock
pins a `main` commit. Revert it with `git checkout -- config/nvim/lazy-lock.json`; every other tracked
file stays unchanged.

`E2E_SKIP_BUILD=1 e2e/run.sh` reuses the built image.

## What is faked

| macOS surface | In the container |
|---|---|
| `$OSTYPE` starts with `darwin` | `ENV OSTYPE=darwin24.0`; bash inherits it. zsh overwrites and exports its compiled-in `linux-gnu`, so `inspect.sh` sets `OSTYPE=darwin24.0` for the second install run |
| `/opt/homebrew/bin/brew` | symlink to Homebrew's Linux prefix `/home/linuxbrew/.linuxbrew` |
| `defaults write` | `e2e/shims/defaults` appends every call to `/tmp/defaults.log` |
| login shell | user `greg`, uid 1000, `/bin/zsh`, passwordless sudo |
| GitHub SSH key | the Neovim check runs with `GIT_CONFIG_GLOBAL=/dev/null` so lazy.nvim clones over HTTPS; on a real Mac the key must exist before Neovim's first launch (see the root README) |
| git identity prompt | `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` are set in the Dockerfile, so the installer writes `config.local` without prompting |

`uname` is not faked. Homebrew reads it to decide how to behave, and the installer does not use it.

## What is skipped, and why

`HOMEBREW_BUNDLE_CASK_SKIP` lists all eleven casks; casks are macOS application bundles.
`HOMEBREW_BUNDLE_BREW_SKIP` lists formulas that do not build on Linux:

| Formula | Reason |
|---|---|
| `ical-buddy` | reads the macOS Calendar database |
| `keith/formulae/reminders-cli` | Swift binary against the macOS EventKit framework |

Add a row here whenever a formula is added to the skip list.

## Gaps

- Linux bottles differ from macOS bottles; a formula that installs here can still differ on a Mac.
- iTerm2 shell integration is not installed.
- `open`, `osascript`, `pbcopy`, Calendar, and Reminders are absent, so the `cal-*` and `rem-*`
  functions are checked for definition only, not executed.
- `nvm` and `rbenv` download and build real toolchains; the container phases take about five minutes, plus the image build on the first run.
