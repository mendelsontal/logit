#!/usr/bin/env bash
# ============================
# Logit Help function
# ============================
UPDATE_LOGIT(){
    local update_choice="$1"
    # URL where the latest version is stored
    VERSION_URL="https://raw.githubusercontent.com/mendelsontal/logit/refs/heads/main/logit.sh"

    # Fetch the latest version from the URL
    printf "INFO - Checking for latest version..."
    LATEST_VERSION=$(curl -s "$VERSION_URL" | grep -oP '^LOGIT_VERSION="\K[0-9.]+')
    RELEASED_VER="https://github.com/mendelsontal/logit/archive/refs/tags/v$LATEST_VERSION.zip"

     if [ -z "$LATEST_VERSION" ]; then
        printf "\n${BOLD_TEXT}${RED_TEXT}ERROR - Could not determine the latest version from:${RESET_TEXT}\n${VERSION_URL}\n\n"
        return 1
    fi

    # Debugging: Show fetched version
    printf "\nLatest  Logit Version: $LATEST_VERSION\n"

    # Define paths properly
    LOCAL_FILE="$HOME/bin/logit/logit.sh"
    GLOBAL_FILE="/usr/local/bin/logit/logit.sh"
    SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
    PRESENT_SCRIPT="$(dirname "$SCRIPT_DIR")/logit.sh"

    # Present check
    if [[ -f "$PRESENT_SCRIPT" ]]; then
        PRESENT_VERSION=$(grep -oP '^LOGIT_VERSION="\K[0-9.]+' "$PRESENT_SCRIPT")
        printf "Current Logit Version: $PRESENT_VERSION\n"
        if [[ $(echo -e "$LATEST_VERSION\n$PRESENT_VERSION" | sort -V | head -n1) == "$PRESENT_VERSION" ]]; then
            if [[ "$LATEST_VERSION" != "$PRESENT_VERSION" ]]; then
                # Update Available
                printf "\nA newer version is available.\n"

                if [[ "$update_choice" != "-y" ]]; then
                    # Choices
                    printf "1) Update \n"
                    printf "2) Cancel \n\n"

                    # User choice input
                    read -p "$(echo -e "${BOLD_TEXT}Please enter your choice ${BLUE_TEXT}[1/2]${RESET_TEXT}: ")" update_choices
                    update_choice=$(echo "$update_choices" | tr '[:upper:]' '[:lower:]')                
                fi             
                
                case $update_choice in
                    1|update|yes|y|-y|-Y)
                        printf "\nDownloading update files...\n"
                        # Download latest zip release
                        curl -Ls --fail "$RELEASED_VER" -o "$(dirname "$SCRIPT_DIR")/update.zip"
                        if [[ $? -eq 0 ]]; then
                            printf "SUCCESS - Newer version downloaded successfully: $(dirname "$SCRIPT_DIR")/update.zip \n"
                        # Zip actions & cleanup
                            unzip -o "$(dirname "$SCRIPT_DIR")/update.zip" -d "$(dirname "$SCRIPT_DIR")" && \
                            mv "$(dirname "$SCRIPT_DIR")/logit-$LATEST_VERSION/logit.sh" "$(dirname "$SCRIPT_DIR")/logit.sh" && \
                            mv $(dirname "$SCRIPT_DIR")/logit-$LATEST_VERSION/assets/* "$(dirname "$SCRIPT_DIR")/assets" && \
                            rm -r "$(dirname "$SCRIPT_DIR")/logit-$LATEST_VERSION" && \
                            rm -r "$(dirname "$SCRIPT_DIR")/update.zip"
                        else
                            echo $RESPONSE
                            printf "ERROR - Failed to download"
                        fi

                        chmod +x "$PRESENT_SCRIPT"
                        PRESENT_VERSION=$(grep -oP '^LOGIT_VERSION="\K[0-9.]+' "$PRESENT_SCRIPT")

                        if [ "$PRESENT_VERSION" != "$LATEST_VERSION" ]; then
                            printf "\n${BOLD_TEXT}${RED_TEXT}ERROR${RESET_TEXT} - Failed to update Logit to version: $LATEST_VERSION\n"
                            return 1
                        else 
                            printf "\n${BOLD_TEXT}${GREEN_TEXT}Success${RESET_TEXT} - Logit has been updated to version: $LATEST_VERSION\n\n"
                            return 0
                        fi
                    ;;
                    2|no|cancel|exit|n)
                        printf "Updating Canceled, exiting.\n\n"
                        return 0
                    ;;
                    *)
                        printf "\n${RED_TEXT}${BOLD_TEXT}Invalid option.${RESET_TEXT}\n"
                        return 1
                        ;;
                esac
            else
                # No Update Available
                printf "${BOLD_TEXT}${GREEN_TEXT}You are using the latest Logit version.${RESET_TEXT}\n\n"
                return
            fi
        fi
    fi
}