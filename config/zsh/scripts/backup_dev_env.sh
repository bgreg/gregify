#!/bin/bash

# TimeTravelStuff - Development Environment Backup Script
# Backs up all dev environment settings and ignored files from git repos

BACKUP_DIR="$HOME/Desktop/TimeTravelStuff"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DAILY_BACKUP="$BACKUP_DIR/dotfiles_backups/$(date +"%Y-%m-%d")"

# Logging setup
LOG_DIR="$BACKUP_DIR/logs"
LOG_FILE="$LOG_DIR/backup_$(date +"%Y-%m-%d").log"
mkdir -p "$LOG_DIR"

# Colors for output
COL_GREEN='\033[0;32m'
COL_YELLOW='\033[1;33m'
COL_CYAN='\033[0;36m'
COL_RED='\033[0;31m'
COL_RESET='\033[0m'

# Logging functions
log() {
  local message="$1"
  local timestamp=$(date +"%H:%M:%S")
  # Print to console
  echo -e "$message"
  # Strip color codes and write to log file
  echo "[$timestamp] $(echo -e "$message" | sed 's/\x1b\[[0-9;]*m//g')" >>"$LOG_FILE"
}

log_error() {
  local message="$1"
  local timestamp=$(date +"%H:%M:%S")
  # Print to stderr with red color
  echo -e "${COL_RED}ERROR: $message${COL_RESET}" >&2
  # Write to log file
  echo "[$timestamp] ERROR: $message" >>"$LOG_FILE"
}

# Export functions and variables for use in subshells
export -f log log_error
export LOG_FILE COL_GREEN COL_YELLOW COL_CYAN COL_RED COL_RESET

# Redirect all stderr to log file while also showing on console
exec 2> >(while IFS= read -r line; do
  echo "$line" >&2
  echo "[$(date +"%H:%M:%S")] STDERR: $line" >>"$LOG_FILE"
done)

# Create backup directory structure
mkdir -p "$DAILY_BACKUP/dotfiles"

# Initialize log file
echo "========================================" >>"$LOG_FILE"
echo "Backup started at $(date)" >>"$LOG_FILE"
echo "========================================" >>"$LOG_FILE"

log "${COL_CYAN}🕐 Starting TimeTravelStuff backup...${COL_RESET}"

# ==========================================
# 0. Update Homebrew Package List
# ==========================================
log "${COL_YELLOW}📦 Updating Homebrew package list...${COL_RESET}"

DEFAULTS_FILE="$HOME/.config/osx-dev-environment-setup"
TEMP_FILE="/tmp/osx_dev_env_new.$$"

# Get current packages
CURRENT_FORMULAE=$(brew leaves | sort)
CURRENT_CASKS=$(brew list --cask 2>/dev/null | sort)

# Check if there are new packages
FORMULAE_IN_FILE=$(grep "brew install" "$DEFAULTS_FILE" | grep -v "brew install --cask" | sed 's/.*brew install //' | sort)
CASKS_IN_FILE=$(grep "brew install --cask" "$DEFAULTS_FILE" | sed 's/.*brew install --cask //' | sort)

NEW_FORMULAE=$(comm -13 <(echo "$FORMULAE_IN_FILE") <(echo "$CURRENT_FORMULAE"))
NEW_CASKS=$(comm -13 <(echo "$CASKS_IN_FILE") <(echo "$CURRENT_CASKS"))

if [ -z "$NEW_FORMULAE" ] && [ -z "$NEW_CASKS" ]; then
  log "✓ osx-dev-environment-setup is up to date"
else
  log "📦 New packages detected!"
  if [ -n "$NEW_FORMULAE" ]; then
    log ""
    log "New formulae:"
    log "$NEW_FORMULAE" | sed 's/^/  - /'
  fi
  if [ -n "$NEW_CASKS" ]; then
    log ""
    log "New casks:"
    log "$NEW_CASKS" | sed 's/^/  - /'
  fi
  log ""

  # Rebuild the brew section with all current packages
  cat >"$TEMP_FILE" <<'HEADER'
#!/bin/bash
# macOS defaults configuration
# Run this after setting up a new Mac or restoring from backup

echo "🍎 Applying macOS defaults and installing packages..."
echo ""

# ==========================================
# 1. macOS System Defaults
# ==========================================
echo "⚙️  Setting macOS system defaults..."

# Key Repeat Speed
# Set to ultra-fast (double the speed - experimental)
# Note: 0 is beyond Apple's official limits and may be unstable
defaults write -g KeyRepeat -int 0
defaults write -g InitialKeyRepeat -int 10

echo "✅ macOS defaults applied!"
echo ""

# ==========================================
# 2. Homebrew Packages
# ==========================================
echo "📦 Installing Homebrew packages..."
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew not found. Install it first:"
    echo '   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

HEADER

  # Add all current formulae
  echo "" >>"$TEMP_FILE"
  echo "# Formulae (auto-generated)" >>"$TEMP_FILE"
  echo "$CURRENT_FORMULAE" | while read -r pkg; do
    if [ -n "$pkg" ]; then
      echo "brew install $pkg" >>"$TEMP_FILE"
    fi
  done

  # Add all current casks
  if [ -n "$CURRENT_CASKS" ]; then
    echo "" >>"$TEMP_FILE"
    echo "# Casks (GUI Apps)" >>"$TEMP_FILE"
    echo "$CURRENT_CASKS" | while read -r pkg; do
      if [ -n "$pkg" ]; then
        echo "brew install --cask $pkg" >>"$TEMP_FILE"
      fi
    done
  fi

  # Add footer
  cat >>"$TEMP_FILE" <<'FOOTER'

echo ""
echo "✅ All packages installed!"
echo ""
echo "⚠️  Next steps:"
echo "   1. Log out and back in for key repeat changes"
echo "   2. Configure rbenv: rbenv init"
echo "   3. Install Ruby: rbenv install 3.3.6"
echo "   4. Run FZF shell integration: $(brew --prefix)/opt/fzf/install"
echo ""
FOOTER

  # Replace the file
  mv "$TEMP_FILE" "$DEFAULTS_FILE"
  chmod +x "$DEFAULTS_FILE"

  log "✅ Updated ~/.config/osx-dev-environment-setup with new packages!"
fi

# ==========================================
# 1. Backup XDG Config Directory
# ==========================================
log "${COL_YELLOW}📦 Backing up XDG config directory...${COL_RESET}"
mkdir -p "$DAILY_BACKUP/dotfiles/config"

# Backup entire .config directory with exclusions
if [ -d "$HOME/.config" ]; then
  rsync -a \
    --exclude='Slack' \
    --exclude='zoom.us' \
    --exclude='google-chrome' \
    --exclude='chromium' \
    --exclude='discord' \
    --exclude='spotify' \
    --exclude='Code' \
    --exclude='Code - Insiders' \
    --exclude='coc' \
    --exclude='configstore' \
    --exclude='pulse' \
    --exclude='gcloud' \
    --exclude='rbenv' \
    --exclude='npm' \
    --exclude='nvm' \
    --exclude='docker' \
    --exclude='bundle' \
    "$HOME/.config/" "$DAILY_BACKUP/dotfiles/config/"
fi

# ==========================================
# 2. Backup ZSH Configuration
# ==========================================
log "${COL_YELLOW}📦 Backing up ZSH configuration...${COL_RESET}"
mkdir -p "$DAILY_BACKUP/dotfiles/zsh"

# Copy zshrc
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$DAILY_BACKUP/dotfiles/zsh/.zshrc"
fi

# ==========================================
# 3. Backup VIM Configuration
# ==========================================
log "${COL_YELLOW}📦 Backing up VIM configuration...${COL_RESET}"
mkdir -p "$DAILY_BACKUP/dotfiles/vim"

# Copy vimrc (legacy location still in use)
if [ -f "$HOME/.vimrc" ]; then
  cp "$HOME/.vimrc" "$DAILY_BACKUP/dotfiles/vim/.vimrc"
fi

# Copy XDG vim config directory (but skip bundle/plugins to save space)
if [ -d "$HOME/.config/vim" ]; then
  rsync -a --exclude='bundle' --exclude='plugged' --exclude='undo' "$HOME/.config/vim/" "$DAILY_BACKUP/dotfiles/vim/config/"
fi

# ==========================================
# 3.5. Update Vim Plugins
# ==========================================
log "${COL_YELLOW}✏️  Updating Vim plugins...${COL_RESET}"
VIM_PLUGINS_DIR="${HOME}/.vim/pack/vendor/start"

if [ -d "$VIM_PLUGINS_DIR" ]; then
  for dir in "$VIM_PLUGINS_DIR"/*/; do
    if [ -d "$dir" ]; then
      plugin_name=$(basename "$dir")
      log "  Updating $plugin_name"

      (
        cd "$dir" || exit 1

        if [ ! -d ".git" ]; then
          log "    ⊘ Not a git repository"
          exit 0
        fi

        if ! git diff-index --quiet HEAD 2>/dev/null; then
          log "    ⚠ Uncommitted changes, skipping"
          exit 0
        fi

        git fetch --quiet 2>&1 || {
          log "    ⚠ Fetch failed"
          exit 0
        }

        local_hash=$(git rev-parse HEAD 2>/dev/null)
        remote_hash=$(git rev-parse @{u} 2>/dev/null)

        if [ "$local_hash" = "$remote_hash" ]; then
          log "    ✓ Already up to date"
        elif git merge-base --is-ancestor "$local_hash" "$remote_hash" 2>/dev/null; then
          git pull --ff-only --quiet 2>&1 && log "    ✓ Updated" || log "    ⚠ Pull failed"
        else
          log "    ⚠ Diverged from upstream, manual merge needed"
        fi
      )
    fi
  done
  log "  ✓ Vim plugins update complete!"
else
  log "  ⊘ Vim plugins directory not found at: $VIM_PLUGINS_DIR"
fi

# ==========================================
# 4. Backup Neovim Configuration
# ==========================================
log "${COL_YELLOW}📦 Backing up Neovim configuration...${COL_RESET}"
mkdir -p "$DAILY_BACKUP/dotfiles/nvim"

# Copy neovim config directory
if [ -d "$HOME/.config/nvim" ]; then
  cp -R "$HOME/.config/nvim" "$DAILY_BACKUP/dotfiles/nvim/config"
fi

# Copy neovim data (but skip large plugin caches)
if [ -d "$HOME/.local/share/nvim" ]; then
  rsync -a --exclude='lazy' --exclude='mason' --exclude='site/pack' "$HOME/.local/share/nvim/" "$DAILY_BACKUP/dotfiles/nvim/share/"
fi

# ==========================================
# 5. Backup Other Important Dotfiles
# ==========================================
log "${COL_YELLOW}📦 Backing up other dotfiles...${COL_RESET}"
mkdir -p "$DAILY_BACKUP/dotfiles/other"

# Git config (XDG-compliant location)
if [ -f "$HOME/.config/git/config" ]; then
  mkdir -p "$DAILY_BACKUP/dotfiles/git"
  cp "$HOME/.config/git/config" "$DAILY_BACKUP/dotfiles/git/config"
fi

# OSX dev environment setup
if [ -f "$HOME/.config/osx-dev-environment-setup" ]; then
  mkdir -p "$DAILY_BACKUP/dotfiles/osx"
  cp "$HOME/.config/osx-dev-environment-setup" "$DAILY_BACKUP/dotfiles/osx/osx-dev-environment-setup"
fi

# SSH config (without private keys)
if [ -f "$HOME/.ssh/config" ]; then
  mkdir -p "$DAILY_BACKUP/dotfiles/ssh"
  cp "$HOME/.ssh/config" "$DAILY_BACKUP/dotfiles/ssh/config"
fi

# iTerm2 profiles and preferences
mkdir -p "$DAILY_BACKUP/dotfiles/iterm2"
if [ -d "$HOME/Library/Application Support/iTerm2/DynamicProfiles" ]; then
  cp -R "$HOME/Library/Application Support/iTerm2/DynamicProfiles" "$DAILY_BACKUP/dotfiles/iterm2/"
fi
if [ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]; then
  cp "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "$DAILY_BACKUP/dotfiles/iterm2/com.googlecode.iterm2.plist"
fi

# Claude settings
if [ -d "$HOME/.claude" ]; then
  mkdir -p "$DAILY_BACKUP/dotfiles/claude"
  rsync -a --exclude='.DS_Store' "$HOME/.claude/" "$DAILY_BACKUP/dotfiles/claude/"
fi

# Cursor settings
if [ -d "$HOME/Library/Application Support/Cursor/User" ]; then
  mkdir -p "$DAILY_BACKUP/dotfiles/cursor"
  cp -R "$HOME/Library/Application Support/Cursor/User/"* "$DAILY_BACKUP/dotfiles/cursor/"
fi

# Hazel rules configuration
if [ -d "$HOME/HazelRules" ]; then
  mkdir -p "$DAILY_BACKUP/dotfiles/hazel"
  cp -R "$HOME/HazelRules/"* "$DAILY_BACKUP/dotfiles/hazel/"
fi

# ==========================================
# 6. Backup Ignored and Excluded Files from Project Repos
# ==========================================
log "${COL_YELLOW}📦 Backing up ignored and excluded files from project repos...${COL_RESET}"

PROJECT_SCAN_DIRS=("$HOME/Workspace" "$HOME/Personal")

for SCAN_DIR in "${PROJECT_SCAN_DIRS[@]}"; do
  [ -d "$SCAN_DIR" ] || continue
  SCAN_NAME=$(basename "$SCAN_DIR")
  log "  ${COL_CYAN}Scanning $SCAN_NAME...${COL_RESET}"

  find "$SCAN_DIR" -maxdepth 2 -name ".git" -type d 2>/dev/null | while read gitdir; do
    REPO_DIR=$(dirname "$gitdir")
    REPO_NAME=$(basename "$REPO_DIR")

    log "  ${COL_CYAN}→ Checking $REPO_NAME...${COL_RESET}"

    cd "$REPO_DIR" 2>/dev/null || continue

    REPO_BACKUP="$DAILY_BACKUP/$SCAN_NAME-ignored-files/$REPO_NAME"

    if [ -f "$REPO_DIR/.git/info/exclude" ]; then
      mkdir -p "$REPO_BACKUP/.git-info"
      cp "$REPO_DIR/.git/info/exclude" "$REPO_BACKUP/.git-info/exclude"
    fi

    git ls-files --others --ignored --exclude-standard 2>/dev/null | while IFS= read -r file; do
      [[ -z "$file" ]] && continue
      [[ ! -f "$file" ]] && continue

      case "$file" in
        *.log | *.log.[0-9]* | *.tmp | *.cache | *.pack | *.pack.gz) continue ;;
        node_modules/* | vendor/bundle/* | tmp/cache/*) continue ;;
        .next/cache/* | .next/server/* | .next/static/*) continue ;;
        coverage/* | dist/* | build/*) continue ;;
        storage/* | .ruby-lsp/* | .DS_Store | */.DS_Store) continue ;;
      esac

      FILE_DIR=$(dirname "$file")
      mkdir -p "$REPO_BACKUP/$FILE_DIR"
      cp "$file" "$REPO_BACKUP/$file"
    done

    ACTUAL_COUNT=$(find "$REPO_BACKUP" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "$ACTUAL_COUNT" -gt 0 ]; then
      log "    ${COL_GREEN}✓ Backed up $ACTUAL_COUNT files${COL_RESET}"
    fi
  done
done

# ==========================================
# 7. Create Archive and Clean Old Backups
# ==========================================
log "${COL_YELLOW}🗜️  Creating compressed archive...${COL_RESET}"

cd "$BACKUP_DIR" || exit 1

# Create timestamped zip in date folder (allows multiple backups per day)
ARCHIVE_NAME="backup-$(date +"%H-%M-%S").zip"
TEMP_ARCHIVE="/tmp/$ARCHIVE_NAME"

if [ -d "$DAILY_BACKUP" ]; then
  (cd "$BACKUP_DIR/dotfiles_backups" && zip -rq "$TEMP_ARCHIVE" "$(date +"%Y-%m-%d")" -x "*.zip")
  mv "$TEMP_ARCHIVE" "$DAILY_BACKUP/$ARCHIVE_NAME"
  ARCHIVE_SIZE=$(du -h "$DAILY_BACKUP/$ARCHIVE_NAME" | cut -f1)
  log "${COL_GREEN}✓ Archive created: dotfiles_backups/$(date +"%Y-%m-%d")/$ARCHIVE_NAME ($ARCHIVE_SIZE)${COL_RESET}"
fi

# Keep minimum of 5 backups, only purge old ones after that
log "${COL_YELLOW}🧹 Cleaning old backups (keeping minimum 5)...${COL_RESET}"

# Count all backup zip files and delete oldest if more than 5
BACKUP_COUNT=$(find "$BACKUP_DIR/dotfiles_backups" -mindepth 2 -maxdepth 2 -name "backup-*.zip" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$BACKUP_COUNT" -gt 5 ]; then
  DELETE_COUNT=$((BACKUP_COUNT - 5))
  log "  Found $BACKUP_COUNT backups, removing $DELETE_COUNT oldest..."
  find "$BACKUP_DIR/dotfiles_backups" -mindepth 2 -maxdepth 2 -name "backup-*.zip" -type f -print0 2>/dev/null |
    xargs -0 ls -t 2>/dev/null |
    tail -n "$DELETE_COUNT" |
    while read -r old_backup; do
      rm -f "$old_backup"
      log "  ${COL_CYAN}Removed: $(basename "$(dirname "$old_backup")")/$(basename "$old_backup")${COL_RESET}"
    done

  # Clean up empty date directories
  find "$BACKUP_DIR/dotfiles_backups" -maxdepth 1 -type d -empty -delete 2>/dev/null
else
  log "  ✓ Keeping all $BACKUP_COUNT backups (minimum 5)"
fi

# Keep only last 3 days of uncompressed backups
find "$BACKUP_DIR/dotfiles_backups" -mindepth 1 -maxdepth 1 -type d -mtime +3 2>/dev/null |
  while read -r old_day; do
    find "$old_day" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} + 2>/dev/null
  done

# ==========================================
# 8. Summary
# ==========================================
BACKUP_SIZE=$(du -sh "$DAILY_BACKUP" 2>/dev/null | cut -f1)
log ""
log "${COL_GREEN}✅ Backup complete!${COL_RESET}"
log "${COL_CYAN}📁 Location: $DAILY_BACKUP${COL_RESET}"
log "${COL_CYAN}📊 Size: $BACKUP_SIZE${COL_RESET}"
log "${COL_CYAN}📝 Log: $LOG_FILE${COL_RESET}"
log ""

# Log completion
echo "========================================" >>"$LOG_FILE"
echo "Backup completed at $(date)" >>"$LOG_FILE"
echo "========================================" >>"$LOG_FILE"
