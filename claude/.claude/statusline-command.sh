#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Show only the directory name
short_cwd=$(basename "$cwd")

# Git branch (skip optional locks)
branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Shorten model name: remove "Claude " prefix
short_model="${model#Claude }"

# === Line 1: model · dir (branch) · context% · $cost ===
printf "\033[35m%s\033[0m" "$short_model"

if [ -n "$branch" ]; then
  printf " \033[90m·\033[0m \033[34m%s\033[0m \033[90m(\033[38;5;146m%s\033[90m)\033[0m" "$short_cwd" "$branch"
else
  printf " \033[90m·\033[0m \033[34m%s\033[0m" "$short_cwd"
fi

if [ -n "$used" ]; then
  pct=$(echo "$used" | tr -d '%')
  if [ "$pct" -ge 90 ] 2>/dev/null; then
    color="\033[31m"
  elif [ "$pct" -ge 70 ] 2>/dev/null; then
    color="\033[33m"
  else
    color="\033[32m"
  fi
  printf " \033[90m·\033[0m \033[90mctx\033[0m ${color}%s%%\033[0m" "$used"
fi


# === Line 2: Usage (5h / 7d) from oauth/usage API ===

# Color based on usage percentage
usage_color() {
  pct=$1
  if [ "$pct" -ge 90 ] 2>/dev/null; then
    printf "\033[31m"
  elif [ "$pct" -ge 70 ] 2>/dev/null; then
    printf "\033[38;2;255;176;85m"
  elif [ "$pct" -ge 50 ] 2>/dev/null; then
    printf "\033[33m"
  else
    printf "\033[32m"
  fi
}

# Progress bar: usage_bar <pct> <width>
usage_bar() {
  pct=$1
  width=${2:-15}
  filled=$(( pct * width / 100 ))
  empty=$(( width - filled ))
  color=$(usage_color "$pct")
  bar=""
  i=0; while [ "$i" -lt "$filled" ]; do bar="${bar}█"; i=$((i+1)); done
  i=0; while [ "$i" -lt "$empty" ];  do bar="${bar}░"; i=$((i+1)); done
  printf "${color}%s\033[0m" "$bar"
}

# Format ISO reset time to local HH:MM or "Mon DD, HH:MM"
format_reset() {
  iso=$1
  style=$2
  [ -z "$iso" ] || [ "$iso" = "null" ] && return
  stripped=$(echo "$iso" | sed 's/\.[0-9]*//' | sed 's/+00:00$//' | sed 's/Z$//')
  epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
  [ -z "$epoch" ] && return
  if [ "$style" = "time" ]; then
    date -j -r "$epoch" +"%H:%M" 2>/dev/null
  else
    date -j -r "$epoch" +"%-m/%-d %H:%M" 2>/dev/null
  fi
}

# Fetch usage data with 60s cache
cache_file="/tmp/claude-statusline-usage.json"
cache_max_age=60
mkdir -p /tmp 2>/dev/null
usage_data=""

if [ -f "$cache_file" ]; then
  cache_age=$(( $(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || echo 0) ))
  if [ "$cache_age" -lt "$cache_max_age" ]; then
    usage_data=$(cat "$cache_file" 2>/dev/null)
  fi
fi

if [ -z "$usage_data" ]; then
  touch "$cache_file" 2>/dev/null
  token=""
  if command -v security >/dev/null 2>&1; then
    blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    [ -n "$blob" ] && token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
  fi
  if [ -n "$token" ] && [ "$token" != "null" ]; then
    response=$(curl -s --max-time 10 \
      -H "Authorization: Bearer $token" \
      -H "anthropic-beta: oauth-2025-04-20" \
      "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
    if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
      usage_data="$response"
      echo "$response" > "$cache_file"
    fi
  fi
fi

if [ -n "$usage_data" ] && echo "$usage_data" | jq -e '.five_hour' >/dev/null 2>&1; then
  five_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
  five_reset_iso=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
  five_reset=$(format_reset "$five_reset_iso" "time")

  seven_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
  seven_reset_iso=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
  seven_reset=$(format_reset "$seven_reset_iso" "datetime")

  printf " \033[90m·\033[0m \033[90msession\033[0m %s%s%%\033[0m" "$(usage_color "$five_pct")" "$five_pct"
  [ -n "$five_reset" ] && printf " \033[90m@%s\033[0m" "$five_reset"

  printf " \033[90m·\033[0m \033[90mweekly\033[0m %s%s%%\033[0m" "$(usage_color "$seven_pct")" "$seven_pct"
  [ -n "$seven_reset" ] && printf " \033[90m@%s\033[0m" "$seven_reset"
fi
