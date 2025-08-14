#!/usr/bin/env bash
# ============================
# Logit Help function
# ============================
UPDATE_LOGIT(){
    # URL where the latest version is stored
    VERSION_URL="https://raw.githubusercontent.com/mendelsontal/logit/logit.sh"

    # Fetch the latest version from the URL
    LATEST_VERSION=$(curl -s "$VERSION_URL" | grep -oP '^LOGIT_VERSION="\K[0-9.]+')

     if [ -z "$LATEST_VERSION" ]; then
        printf "\n${BOLD_TEXT}${RED_TEXT}ERROR - Could not determine the latest version from:${RESET_TEXT}\n${VERSION_URL}\n\n"
        return 1
    fi

    # Debugging: Show fetched version
    printf "\nLatest Logit Version: $LATEST_VERSION\n"

    # Define paths properly
    LOCAL_FILE="$HOME/bin/logit/logit.sh"
    GLOBAL_FILE="/usr/local/bin/logit/logit.sh"
    SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
    PRESENT_FOLDER=PARENT_DIR="$(dirname "$SCRIPT_DIR")/logit.sh"

    # Local check
    if [ -f "$LOCAL_FILE" ]; then
        local_version=$(grep -oP '^LOGIT_VERSION="\K[0-9.]+' "$LOCAL_FILE")
        printf "Logit - Local - Version: $local_version\n"
        if [ "$local_version" != "$LATEST_VERSION" ]; then
            local_update_available="true"
        else 
            local_update_available="false"
        fi
    else
        local_installed="false"
    fi

    # Present Folder
    if [ -f "$PRESENT_FOLDER" ]; then
        echo "TODODODODO" #TODO
    fi

     # Local update available
    if [ "$local_update_available" == "true" ]; then
        printf "\n${BOLD}Local Logit update available.${RESET}\n"
        printf "Current version: $local_version\n"
        printf "Latest version: $LATEST_VERSION\n\n"

        # Choices - Local
        printf "1) Update Local (Current user only). \n"
        printf "2) Cancel. \n\n"

        # User local choice input
        read -p "$(echo -e "${BOLD_TEXT}Please enter your choice ${BLUE_TEXT}[1/2]${RESET_TEXT}: ")" local_choice

        case $local_choice in
            1)
                curl -s "$VERSION_URL" -o "$LOCAL_FILE"
                chmod +x "$LOCAL_FILE"
                local_version=$(grep -oP '^LOGIT_VERSION="\K[0-9.]+' "$LOCAL_FILE")

                if [ "$local_version" != "$LATEST_VERSION" ]; then
                    printf "\n${BOLD_TEXT}${RED_TEXT}ERROR${RESET_TEXT} - Failed to update Logit - Local to version: $LATEST_VERSION\n"
                else 
                    printf "\n${BOLD_TEXT}${GREEN_TEXT}Success${RESET_TEXT} - Logit Local has been updated to version: $LATEST_VERSION\n\n"
                    source "$LOCAL_FILE"
                    return
                fi
            ;;
            2)
                printf "Updating Canceled, exiting.\n\n"
                return 0
            ;;
            *)
                printf "\n${RED_TEXT}${BOLD_TEXT}Invalid option.${RESET_TEXT}\n"
                return 1
                ;;
        esac
    fi

    # Global update available
    if [ "$global_update_available" == "true" ]; then
        printf "\n${BOLD_TEXT}Global Logit update available.${RESET_TEXT}\n"
        printf "Current version: $global_version\n"
        printf "Latest version: $LATEST_VERSION\n\n"

        # Choices - Global
        printf "1) Update Logit Global. \n"
        printf "2) Cancel. \n\n"

        # User global choice input
        read -p "$(echo -e "${BOLD_TEXT}Please enter your choice ${BLUE_TEXT}[1/2]${RESET_TEXT}: ")" global_choice

        case $global_choice in
            1)
                sudo curl -s "$VERSION_URL" -o "$GLOBAL_FILE"
                sudo chmod +x "$GLOBAL_FILE"
                global_version=$(grep -oP '^LOGIT_VERSION="\K[0-9.]+' "$GLOBAL_FILE")

                if [ "$global_version" != "$LATEST_VERSION" ]; then
                    printf "\n${BOLD_TEXT}${RED_TEXT}ERROR${RESET_TEXT} - Failed to update Logit - Global to version: $LATEST_VERSION\n"
                else 
                    printf "\n${BOLD_TEXT}${GREEN_TEXT}Success${RESET_TEXT} - Logit Global has been updated to version: $LATEST_VERSION\n\n"
                    source "$GLOBAL_FILE"
                    return
                fi
            ;;
            2)
                printf "Updating Canceled, exiting.\n\n"
                return
            ;;
            *)
                printf "\n${RED_TEXT}${BOLD_TEXT}Invalid option.${RESET_TEXT}\n\n"
                return
            ;;
        esac
    fi

    # No updates available
    printf "${BOLD_TEXT}${GREEN_TEXT}No Logit updates available.${RESET_TEXT}\n\n"
    return
}