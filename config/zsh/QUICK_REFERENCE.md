# Oh My Zsh Quick Reference

## Navigation
- `z api` - Jump to frequently-used directory (learns your patterns after a few uses)
- `z -l` - List all directories in z's database with scores
- `Alt+Left` / `Alt+Right` - Navigate directory history like browser back/forward
- `..` / `...` / `....` - Go up 1/2/3 directories

## Clipboard (macOS)
- `copypath` - Copy current directory path to clipboard
- `copypath file.rb` - Copy absolute path to file
- `copyfile file.rb` - Copy entire file contents to clipboard

## History Search
- `Ctrl+R` - FZF fuzzy history search (start typing anything)
- `Up/Down arrows` - Search history by what you've already typed (history-substring-search)
- `history` or `h` - Show command history

## Quick Fixes
- `ESC ESC` - Add sudo to current/previous command
- `Ctrl+Z` - Suspend process, then `fg` to resume

## Web Search from Terminal
- `google "search term"` - Google search
- `stackoverflow "error message"` - StackOverflow search
- `github "repo name"` - GitHub search
- `youtube "video"` - YouTube search
- `ddg "search"` - DuckDuckGo search

## JSON Tools
- `pp_json '{"key":"value"}'` - Pretty print JSON
- `cat file.json | pp_json` - Format JSON file
- `is_json '{"test": true}'` - Validate JSON
- `urlencode_json` / `urldecode_json` - Encode/decode JSON for URLs

## Docker Shortcuts
- `dps` - docker ps (list running containers)
- `doc` - docker (shorthand)
- `dc` - docker compose
- `dce` - docker compose exec rails
- `dcbe` - docker compose exec rails bundle exec

## Git Shortcuts (oh-my-zsh git plugin)
- `gst` - git status
- `ga` - git add
- `gaa` - git add --all
- `gc` - git commit -v
- `gp` - git push
- `gl` - git pull
- `gco` - git checkout
- `gcb` - git checkout -b
- `gd` - git diff
- `glog` - git log with nice formatting
- `gwip` - git add -A && git commit -m "--wip--"

## Rails Shortcuts (oh-my-zsh rails plugin)
- `rc` - rails console
- `rs` - rails server
- `rg` - rails generate
- `rd` - rails destroy
- `rp` - rails plugin
- `ru` - rails runner
- `rake` - rake (with bundler auto-detection)

## Archive Extraction
- `extract file.tar.gz` - Smart extraction for any archive format
- Works with: .tar, .gz, .zip, .rar, .7z, .bz2, etc.

## Bonus Tips
- `take dirname` - mkdir + cd in one command
- `x` - Same as `extract` command
- Type command then press `Tab` twice for completions
- `which aliasname` - See what an alias actually does

## Your Custom Shortcuts
- `api_service` - cd ~/Workspace/api_service
- `goodmorning` - Run morning setup script
- `rem-add` - Add reminder
- `cal-today` - Show today's calendar events
- `shortcuts` - Show this file

## 7-Day Challenge

**Day 1-2:** Use `z` for ALL directory navigation (not cd)
**Day 3-4:** Practice `copypath` and `Ctrl+R` fuzzy search
**Day 5-6:** Try `ESC ESC` for sudo and web-search commands
**Day 7:** Review what stuck, disable unused plugins

---

To view this file anytime: `shortcuts` or `cat ~/.config/zsh/QUICK_REFERENCE.md`
