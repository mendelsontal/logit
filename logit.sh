#!/usr/bin/env bash
############################################################ /ᐠ｡ꞈ｡ᐟ\############################################################
#Developed by: Tal Mendelson
#Purpose: Logging utility for scripts
#Date:08/08/2025
# Usage:
#   logit LEVEL "Your message here"
#
# Usage Examples:
#   logit INFO "This is an informational message."
#   logit WARN "This is a warning."
#   logit ERROR "Something went wrong."
#   logit SUCCESS "Task completed successfully."
#   logit DEBUG "This is a debug messaage"
#   logit help     # Show usage and environment variable info
#
# Environment Variables:
#   LOG_NAME:           Name of the log file | (default: YourScriptName)
#   LOG_FILE:           Path to the log file | (default: $PARENT_DIR/logs/${LOG_NAME}.log)
#   ERROR_LOG_FILE:     Path to the error log file | (default: $PARENT_DIR/logs/errors_${LOG_NAME}.log)
#   LOG_SIZE:           Maximum size of log file before rotating in MB | (default: 3)
#   MAX_LOG_FILES:      Number of rotated log files to keep | (default: 3)
#   SHOW_MESSAGE:       Set to "true" to also show logs to user (stdout) | (default: "true")
#   HIDE_INFO:          Set to "true" with SHOW_MESSAGE to hide INFO messages from stdout | (default: "true")
#   DEBUG_MODE:         Set to "true" to activate DEBUG mode which will log all commands without their output | (default: "false")
#   LOGIT_DATE_FORMAT:  Allows customizable timestamp format (default: %Y-%m-%d %H:%M:%S.%3N)
############################################################ /ᐠ｡ꞈ｡ᐟ\ ############################################################

# ============================
# Logit Version
# ============================
LOGIT_VERSION="0.1.2"
# ============================
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")" # Gets the script dir
PARENT_DIR="${PARENT_DIR:-$(basename "$(dirname "$0")")}"
LOG_SIZE="${LOG_SIZE:-"3"}" # Maximum allowed log file size in MB (used in LOG_SIZE)
MAX_SIZE=$(($LOG_SIZE * 1024 * 1024)) # Maximum allowed log file size in bytes, uses LOG_SIZE variable.
LOG_NAME="${LOG_NAME:-$(basename "$0" .sh)}" # Gets the script name
LOG_FILE="${LOG_FILE:-$PARENT_DIR/logs/${LOG_NAME}.log}"
ERROR_LOG_FILE="${ERROR_LOG_FILE:-$PARENT_DIR/logs/errors_${LOG_NAME}.log}"
MAX_LOG_FILES="${MAX_LOG_FILES:-3}" # keeping X archived log files.
SHOW_MESSAGE="${SHOW_MESSAGE:-"true"}" # Set "true" to also show logs to user (stdout) or anything else to disable (Will still show ERROR messages)
HIDE_INFO="${HIDE_INFO:-"true"}" # Set "true" with SHOW_MESSAGE to hide INFO messages from stdout
DEBUG_MODE="${DEBUG_MODE:-"false"}" # Set "true" to activate DEBUG mode
LOGIT_DATE_FORMAT="${LOGIT_DATE_FORMAT:-"%Y-%m-%d %H:%M:%S.%3N"}" # Allow customizable timestamp format

# ============================
# Load all external scripts from functions folder
# ============================
shopt -s nullglob
for f in $SCRIPT_DIR/assets/*.sh; do
    source "$f"
done
shopt -u nullglob

# ============================
# Debug mode setup: Log every command when DEBUG_MODE is true
# ============================
trap '[[ "$DEBUG_MODE" == "true" ]] && logit DEBUG "Executing command: $BASH_COMMAND"' DEBUG

# Check if shell is interactive
if [[ $- == *i* ]]; then
  _logit_completions() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        local options="help version update uninstall"

        # If the typed input isn't a valid option, prevent completion
        if [[ "$cur" != [A-Za-z]* ]]; then
            COMPREPLY=()  # Prevent completion for invalid input
            return 0
        fi

        COMPREPLY=( $(compgen -W "$options" -- "$cur") )
        return 0
    }

    complete -F _logit_completions logit
fi

# ============================
# Log function
# ============================
logit() {
  message_format
  # Check if at least one argument is provided
  if [ $# -lt 1 ]; then
      printf "\n${BOLD_TEXT}Usage: $0 {help | version | update}${RESET_TEXT}\n"
      return 
  fi

  # Lowercase the argument
    arg=$(echo "$1" | tr '[:upper:]' '[:lower:]')

  local level="$1" 
  # Capture additional arguments
  shift
  extra_args=("$@")

  case "$arg" in
      # Help
      help|h)
        LOGIT_HELP
        return
        ;;

      # Version
      version|v|ver)
        printf "Installed Logit version: ${BOLD_TEXT}${GREEN_TEXT}$LOGIT_VERSION${RESET_TEXT}\n"
        return
        ;;
      
      # Update
      update)
        local confirm_flag=""
        for arg in "${extra_args[@]}"; do
          if [[ "$arg" == "-y" ]]; then
            confirm_flag="-y"
            break
          fi
        done
        UPDATE_LOGIT "$confirm_flag"
        return
        ;;
  esac
  
    #shift
    local timestamp="[$(date +"$LOGIT_DATE_FORMAT" 2>/dev/null || echo 'unknown time')]"

    case "$level" in
      INFO|WARN|ERROR|SUCCESS|DEBUG)
        # Valid log level — continue
        ;;
        *)
        echo "Invalid log level: '$level'. Valid levels are: INFO, WARN, ERROR, SUCCESS, DEBUG" >&2
        return 1
        ;;
    esac

  # Capture message
  local message="$*"
  local log_dir
  log_dir="$(dirname "$LOG_FILE")"

  # Validate message
  if [[ -z "$*" ]]; then
    echo "Warning: No message provided for log level '$level'" >&2
    echo "${timestamp} [WARN] No message provided for log level '$level'" >> "$LOG_FILE" 2>/dev/null
    return 1
  fi

  # Skip DEBUG messages unless DEBUG_MODE is true (for explicit logit DEBUG calls)
  if [[ "$level" == "DEBUG" && "$DEBUG_MODE" != "true" ]]; then
    return 0
  fi

    # Ensure log directory exists and is writable, or fallback to /tmp
  if [[ ! -d "$log_dir" ]]; then
    if ! mkdir -p "$log_dir" 2>/dev/null || [[ ! -w "$log_dir" ]]; then
      echo "Warning: Falling back to /tmp for log file" >&2
      LOG_FILE="/tmp/${LOG_NAME}.log"
      log_dir="/tmp"
    fi
  fi

  # Create the log file if needed
  touch "$LOG_FILE" 2>/dev/null || {
    echo "Error: Cannot create or write to log file '$LOG_FILE'" >&2
    return 1
  }

  # Check if log is writtable
  if [[ ! -w "$LOG_FILE" ]]; then
  echo "Error: Log file '$LOG_FILE' is not writable" >&2
  echo "Log file '$LOG_FILE' is not writable" >&2
    LOG_FILE="/tmp/${LOG_NAME}.log"
    log_dir="/tmp"
  return 1
  fi

  # Rotate log file if it exceeds MAX_SIZE
  if [[ -f "$LOG_FILE" ]]; then
    local size
    size=$(wc -c < "$LOG_FILE" 2>/dev/null | tr -d '[:space:]')
    if [[ -n "$size" && "$size" =~ ^[0-9]+$ && "$size" -ge "$MAX_SIZE" ]]; then
      local timestamp
      timestamp=$(date +'%Y%m%d%H%M%S')
      mv -f -- "$LOG_FILE" "${LOG_FILE}.${timestamp}" 2>/dev/null || {
        echo "Error: Failed to rotate log file to '${LOG_FILE}.${timestamp}'" >&2
        return 1
      }
      touch "$LOG_FILE" 2>/dev/null || {
        echo "Error: Cannot create new log file '$LOG_FILE' after rotation" >&2
        return 1
      }
      # Clean up old log files if exceeding MAX_LOG_FILES
      if [[ "$MAX_LOG_FILES" -gt 0 ]]; then
        # List log files matching the pattern, sort by name (timestamp), and keep only the newest ones
        local log_count
        log_count=$(ls -1 "${LOG_FILE}".* 2>/dev/null | wc -l)
        if [[ "$log_count" -gt "$MAX_LOG_FILES" ]]; then
          ls -1 "${LOG_FILE}".* 2>/dev/null | sort | head -n $((log_count - MAX_LOG_FILES)) | while read -r old_log; do
            rm -f "$old_log" 2>/dev/null || {
              echo "Warning: Failed to delete old log file '$old_log'" >&2
            }
          done
        fi
      fi
    fi
  fi

  # Append the log entry
  output="/dev/null"
  [[ "$SHOW_MESSAGE" == "true" ]] && output="/dev/stdout"

  if [[ "$HIDE_INFO" == "true" ]]; then
    if [[ "$level" == "INFO" ]]; then
      echo "${timestamp} [$level] $message" | tee -a "$LOG_FILE" > /dev/null || {
        echo "Error: Failed to write to log file '$LOG_FILE'" >&2
        return 1
      }
    else
      echo "${timestamp} [$level] $message" | tee -a "$LOG_FILE" > "$output" || {
        echo "Error: Failed to write to log file '$LOG_FILE'" >&2
        return 1
      }
    fi
  else
    echo "${timestamp} [$level] $message" | tee -a "$LOG_FILE" > "$output" || {
      echo "Error: Failed to write to log file '$LOG_FILE'" >&2
      return 1
    }
  fi

  if [[ "$level" == "ERROR" ]]; then
    if [[ "$SHOW_MESSAGE" == "true" ]]; then
      echo "${timestamp} [$level] $message" | tee -a "$ERROR_LOG_FILE" > /dev/null || {
        echo "Error: Failed to write to log file '$ERROR_LOG_FILE'" >&2
        return 1
      }
    else
      echo "${timestamp} [$level] $message" | tee -a "$ERROR_LOG_FILE" > "$output" || {
        echo "Error: Failed to write to log file '$ERROR_LOG_FILE'" >&2
        return 1
      }
    fi
  fi
}
# Remember kids, no good deed goes unpunished.