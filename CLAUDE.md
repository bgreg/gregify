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

## Branch Artifacts

All branch-specific work artifacts should be organized in `.claude/branches/<branch-name>/`:
- Implementation plans and task breakdowns
- Temporary debugging scripts
- Analysis notes and research
- Any branch-specific documentation

This keeps the main `.claude/` directory clean and makes branch cleanup easier.

## Git Workflow

**Commit Attribution**: Never include Claude Code attribution or Co-Authored-By tags in commits unless explicitly requested. Commits should appear as authored by the developer using the tool.

Follow workspace git standards if present, otherwise follow standard git practices.
