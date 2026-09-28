#!/usr/bin/env zsh

show_github_prs() {
  echo "\033[33;01m========================================\033[39;49;00m"
  echo "\033[33;01m  🔀 GitHub PR Review:\033[39;49;00m"
  echo "\033[33;01m========================================\033[39;49;00m"

  if ! command -v gh &>/dev/null; then
    echo "Install GitHub CLI: brew install gh"
    echo ""
    return 0
  fi

  if ! gh auth status &>/dev/null; then
    echo "Authenticate: gh auth login"
    echo ""
    return 0
  fi

  local username
  username=$(gh api user --jq '.login' 2>/dev/null)
  if [ -z "$username" ]; then
    echo "Unable to fetch GitHub username"
    echo ""
    return 0
  fi

  local pr_query='query { authored: search(query: "type:pr is:open author:@me", type: ISSUE, first: 25) { nodes { ... on PullRequest { number title url repository { nameWithOwner } mergeable commits(last: 1) { nodes { commit { statusCheckRollup { state } } } } reviewThreads(first: 50) { nodes { isResolved comments(first: 1) { nodes { author { login } url } } } } } } } reviewRequested: search(query: "type:pr is:open review-requested:@me", type: ISSUE, first: 25) { nodes { ... on PullRequest { number title url repository { nameWithOwner } } } } }'

  local pr_data
  pr_data=$(gh api graphql -f query="$pr_query" 2>/dev/null)

  if [ $? -ne 0 ] || [ -z "$pr_data" ]; then
    if echo "$pr_data" | grep -q "rate limit" 2>/dev/null; then
      echo "\033[33mGitHub API rate limit exceeded\033[0m"
      echo "\033[90m  → Wait a few minutes or check: gh api rate_limit\033[0m"
    else
      echo "Unable to fetch PR data"
    fi
    echo ""
    return 0
  fi

  local authored_count
  authored_count=$(printf '%s' "$pr_data" | jq '.data.authored.nodes | length' 2>/dev/null)
  local review_requested_count
  review_requested_count=$(printf '%s' "$pr_data" | jq '.data.reviewRequested.nodes | length' 2>/dev/null)

  if [ "$authored_count" -eq 0 ] && [ "$review_requested_count" -eq 0 ]; then
    echo "No open PRs requiring attention"
    echo ""
    return 0
  fi

  if [ "$authored_count" -gt 0 ]; then
    local max_prs="${GITHUB_MAX_PRS:-5}"
    if [ "$authored_count" -gt "$max_prs" ]; then
      echo "\033[36mYour Open PRs (showing $max_prs of $authored_count):\033[0m"
      echo "\033[90m  → Set GITHUB_MAX_PRS to show more\033[0m"
    else
      echo "\033[36mYour Open PRs ($authored_count):\033[0m"
    fi
    echo ""

    local repo title url number mergeable ci_state unresolved_count ci_icon merge_icon
    printf '%s' "$pr_data" | jq -r '.data.authored.nodes[:'"$max_prs"'] | .[] | @json' 2>/dev/null | while read -r pr_json; do
      repo=$(printf '%s' "$pr_json" | jq -r '.repository.nameWithOwner')
      title=$(printf '%s' "$pr_json" | jq -r '.title')
      url=$(printf '%s' "$pr_json" | jq -r '.url')
      number=$(printf '%s' "$pr_json" | jq -r '.number')
      mergeable=$(printf '%s' "$pr_json" | jq -r '.mergeable')
      ci_state=$(printf '%s' "$pr_json" | jq -r '.commits.nodes[0].commit.statusCheckRollup.state // "UNKNOWN"')

      unresolved_count=$(printf '%s' "$pr_json" | jq '[.reviewThreads.nodes[] | select(.isResolved == false and .comments.nodes[0].author.login != "'"$username"'")] | length')

      case "$ci_state" in
        SUCCESS) ci_icon="✅" ;;
        PENDING) ci_icon="⏳" ;;
        FAILURE|ERROR) ci_icon="❌" ;;
        *) ci_icon="❓" ;;
      esac

      case "$mergeable" in
        MERGEABLE) merge_icon="" ;;
        CONFLICTING) merge_icon=" ⚠️  CONFLICTS" ;;
        UNKNOWN) merge_icon=" 🔄" ;;
        *) merge_icon="" ;;
      esac

      echo "  • ${repo}#${number}: ${title}"
      echo "    ${ci_icon} CI${merge_icon}"

      if [ "$unresolved_count" -gt 0 ]; then
        echo "\033[33m    💬 ${unresolved_count} unresolved comment(s)\033[0m"

        printf '%s' "$pr_json" | jq -r '.reviewThreads.nodes[] | select(.isResolved == false and .comments.nodes[0].author.login != "'"$username"'") | .comments.nodes[0].url' 2>/dev/null | head -3 | while read -r comment_url; do
          echo "\033[90m       → $comment_url\033[0m"
        done
      fi

      echo "    🔗 $url"
      echo ""
    done
  fi

  if [ "$review_requested_count" -gt 0 ]; then
    local max_prs="${GITHUB_MAX_PRS:-5}"
    if [ "$review_requested_count" -gt "$max_prs" ]; then
      echo "\033[36mAwaiting Your Review (showing $max_prs of $review_requested_count):\033[0m"
      echo "\033[90m  → Set GITHUB_MAX_PRS to show more\033[0m"
    else
      echo "\033[36mAwaiting Your Review ($review_requested_count):\033[0m"
    fi
    echo ""

    printf '%s' "$pr_data" | jq -r '.data.reviewRequested.nodes[:'"$max_prs"'] | .[] | "  • \(.repository.nameWithOwner)#\(.number): \(.title)\n    🔗 \(.url)\n"' 2>/dev/null
    echo ""
  fi
}

show_github_issues() {
  echo "\033[33;01m========================================\033[39;49;00m"
  echo "\033[33;01m  📋 GitHub Issues:\033[39;49;00m"
  echo "\033[33;01m========================================\033[39;49;00m"

  if ! command -v gh &>/dev/null; then
    echo "Install GitHub CLI: brew install gh"
    echo ""
    return 0
  fi

  if ! gh auth status &>/dev/null; then
    echo "Authenticate: gh auth login"
    echo ""
    return 0
  fi

  local issues_query='query { search(query: "type:issue is:open assignee:@me", type: ISSUE, first: 25) { issueCount nodes { ... on Issue { number title url repository { nameWithOwner } labels(first: 5) { nodes { name } } comments { totalCount } createdAt } } } }'

  local issues_data
  issues_data=$(gh api graphql -f query="$issues_query" 2>/dev/null)

  if [ $? -ne 0 ] || [ -z "$issues_data" ]; then
    if echo "$issues_data" | grep -q "rate limit" 2>/dev/null; then
      echo "\033[33mGitHub API rate limit exceeded\033[0m"
      echo "\033[90m  → Wait a few minutes or check: gh api rate_limit\033[0m"
    else
      echo "Unable to fetch issues"
    fi
    echo ""
    return 0
  fi

  local issue_count
  issue_count=$(printf '%s' "$issues_data" | jq '.data.search.issueCount' 2>/dev/null)

  if [ "$issue_count" -eq 0 ]; then
    echo "No open issues assigned to you"
    echo ""
    return 0
  fi

  local max_issues="${GITHUB_MAX_ISSUES:-5}"
  if [ "$issue_count" -gt "$max_issues" ]; then
    echo "You have ${issue_count} open issue(s) (showing $max_issues):"
    echo "\033[90m  → Set GITHUB_MAX_ISSUES to show more\033[0m"
  else
    echo "You have ${issue_count} open issue(s) assigned:"
  fi
  echo ""

  local repo title url number comment_count labels
  printf '%s' "$issues_data" | jq -r '.data.search.nodes[:'"$max_issues"'] | .[] | @json' 2>/dev/null | while read -r issue_json; do
    repo=$(printf '%s' "$issue_json" | jq -r '.repository.nameWithOwner')
    title=$(printf '%s' "$issue_json" | jq -r '.title')
    url=$(printf '%s' "$issue_json" | jq -r '.url')
    number=$(printf '%s' "$issue_json" | jq -r '.number')
    comment_count=$(printf '%s' "$issue_json" | jq -r '.comments.totalCount')
    labels=$(printf '%s' "$issue_json" | jq -r '[.labels.nodes[].name] | join(", ")')

    echo "  • ${repo}#${number}: ${title}"

    if [ -n "$labels" ] && [ "$labels" != "" ]; then
      echo "\033[90m    🏷️  $labels\033[0m"
    fi

    if [ "$comment_count" -gt 0 ]; then
      echo "\033[90m    💬 $comment_count comment(s)\033[0m"
    fi

    echo "    🔗 $url"
    echo ""
  done
}

main() {
  local show_prs=true
  local show_issues=true

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --prs-only)
        show_issues=false
        shift
        ;;
      --issues-only)
        show_prs=false
        shift
        ;;
      -h|--help)
        echo "Usage: github-overview.sh [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --prs-only      Show only pull requests"
        echo "  --issues-only   Show only issues"
        echo "  -h, --help      Show this help message"
        echo ""
        echo "Environment variables:"
        echo "  GITHUB_MAX_PRS     Maximum PRs to display (default: 5)"
        echo "  GITHUB_MAX_ISSUES  Maximum issues to display (default: 5)"
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        echo "Use -h or --help for usage information"
        exit 1
        ;;
    esac
  done

  [[ "$show_prs" == true ]] && show_github_prs
  [[ "$show_issues" == true ]] && show_github_issues
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || [[ "${(%):-%x}" == "${0}" ]]; then
  main "$@"
fi
