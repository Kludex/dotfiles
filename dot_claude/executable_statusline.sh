#!/bin/bash
input=$(cat)

# Colors
C='\033[36m'    # cyan
G='\033[32m'    # green
M='\033[35m'    # magenta
Y='\033[33m'    # yellow
R='\033[31m'    # red
O='\033[38;5;208m' # orange
GR='\033[90m'   # gray
W='\033[97m'    # white
X='\033[0m'     # reset
B='\033[1m'     # bold

# Parse JSON
MODEL=$(echo "$input" | jq -r '.model.display_name // ""')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
CWD=$(echo "$input" | jq -r '.workspace.current_dir // ""')

# Cost
COST_FMT=$(printf '$%.2f' "$COST")

# Context bar (10 chars)
FILLED=$((PCT / 10))
EMPTY=$((10 - FILLED))
if [ "$PCT" -ge 90 ]; then
  BAR_COLOR="$R"
elif [ "$PCT" -ge 70 ]; then
  BAR_COLOR="$O"
elif [ "$PCT" -ge 50 ]; then
  BAR_COLOR="$Y"
else
  BAR_COLOR="$G"
fi
BAR="${BAR_COLOR}"
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
BAR+="${X}"

# Directory (abbreviated)
DIR="${CWD/#$HOME/~}"

# Git info
GIT_INFO=""
if [ -n "$CWD" ] && git -C "$CWD" rev-parse --is-inside-work-tree &>/dev/null; then
  BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)
  STATUS=$(git -C "$CWD" status --porcelain 2>/dev/null)

  ADDED=0; MODIFIED=0; DELETED=0; UNTRACKED=0
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    s="${line:0:2}"
    case "$s" in
      "A "*|"M ") ((ADDED++)) ;;
      " M"|"MM")  ((MODIFIED++)) ;;
      " D"|"D ")  ((DELETED++)) ;;
      "??")       ((UNTRACKED++)) ;;
    esac
  done <<< "$STATUS"

  CHANGES=""
  [ "$ADDED" -gt 0 ]     && CHANGES+="${G}+${ADDED}${X} "
  [ "$MODIFIED" -gt 0 ]  && CHANGES+="${Y}~${MODIFIED}${X} "
  [ "$DELETED" -gt 0 ]   && CHANGES+="${R}-${DELETED}${X} "
  [ "$UNTRACKED" -gt 0 ] && CHANGES+="${GR}?${UNTRACKED}${X} "
  CHANGES="${CHANGES% }"

  if [ -n "$CHANGES" ]; then
    GIT_INFO=" ${M}${BRANCH}${X} ${CHANGES}"
  else
    GIT_INFO=" ${M}${BRANCH}${X}"
  fi
fi

# Output
printf "${C}${DIR}${X}${GIT_INFO} ${GR}│${X} ${B}${W}${MODEL}${X} ${BAR} ${GR}${PCT}%%${X} ${GR}│${X} ${G}${COST_FMT}${X}"
