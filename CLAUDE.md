# Dotfiles

macOS Development Environment Configuration
Shell-based automation for personal dotfiles and dev environment.

## Quick Commands

```bash
./dotfiles.sh              # Run installation/setup
./test-dotfiles.sh         # Run tests
```

## Key Context

- Automates macOS dev environment setup
- Manages dotfiles (zsh, git, vim, etc.)
- Color-coded logging output
- macOS-specific (darwin only)

## Entry Points

- Main: `dotfiles.sh`
- Tests: `test-dotfiles.sh`
- Target: `$HOME/.config/` (after installation)

## Related Projects

- **goodmorning-script** (../goodmorning-script) - Uses this environment
- All workspace projects use this environment foundation

## Target Locations

- Configs: `$HOME/.config/`
- Scripts: `$HOME/.config/zsh/scripts`

## Safety

- Modifies `$HOME` directory
- May overwrite existing dotfiles
- Always backup before running

