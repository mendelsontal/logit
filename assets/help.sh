#!/usr/bin/env bash
# ============================
# Logit Help function
# ============================
LOGIT_HELP(){
    printf "${BOLD_TEXT}${CYAN_TEXT}Usage:${RESET_TEXT}\n"
    printf "  LOGIT start                ${GREEN_TEXT}# Start logging all executed commands${RESET_TEXT}\n"
    printf "  LOGIT <LEVEL> <MESSAGE>    ${GREEN_TEXT}# Log a message with level INFO, SUCCESS, WARN, ERROR${RESET_TEXT}\n"
    printf "\n"
    printf "  ${YELLOW_TEXT}Example:${RESET_TEXT}\n"
    printf "  LOGIT INFO \"Application started\"\n"
    printf "  LOGIT ERROR \"Something went wrong\"\n"
    printf "\n"
    printf "  ${GREEN_TEST}To override the log location, set:${RESET_TEXT}\n"
    printf "  export LOGDIR=/path/to/logs\n"
    printf "  export LOGFILE=/path/to/logfile.log\n"
    printf "\n"
}
