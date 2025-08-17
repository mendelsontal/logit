# Logit - A Lightweight Bash Logging Utility

<img src="https://img.shields.io/badge/Logit-Bash%20Logging%20Utility-blue" alt="Logit Logo" />

Logit is a lightweight and configurable Bash logging utility that enables structured logging with levels (INFO, DEBUG, WARN, ERROR). It supports automatic command logging, customizable timestamps, log rotation, and silent mode, making it ideal for script debugging and system monitoring.

---

### 🛠️ **Installation**

1. Download the `logit.sh` script or clone the repository:

    ```bash
    git clone https://github.com/mendelsontal/logit.git
    ```

2. Source the logit in your script or in `.bashrc` , `.bash_profile` file:

    ```bash
    # Example of sourcing logit
    source /path/to/logit.sh
    ```

---

### 🚀 **Usage**

To log a message with a specific level, run:

```bash
logit INFO "Your info message"
logit SUCSESS "Your success message"
logit WARN "Your warning message"
logit ERROR "Your error message"
logit DEBUG "Your DEBUG message"
```

To see the version of `logit`:

```bash
logit version
```

To get help:

```bash
logit help
```

To update:

```bash
logit update
logit update -y
```

---

### ⚙️ **Configuration**

- **Log Location / Name**: By default, log entries are saved to the same folder your script ran from with the name of the script which ran them. You can override the log directory, name and file location by setting the `LOG_NAME`, `LOG_FILE`, `PARENT_DIR` and `ERROR_LOG_FILE` environment variables.

    ```bash
    export LOG_NAME="mylog" #   Sets log name | .log is added by default
    export PARENT_DIR="/home/myapp" #   Sets specific log folder location | will overwrite location for both error and normal logs
    export LOGFILE="/path/to/custom/myapp.log" #   Sets specific log location | Overwrites PARENT_DIR, LOG_NAME vars
    export ERROR_LOG_FILE="/path/to/custom/errors_myapp.log" #   Sets specific error log location | Overwrites PARENT_DIR, LOG_NAME vars
    ```

- **Timestamp Format**: You can customize the timestamp format used in log entries by setting the `LOGIT_DATE_FORMAT` variable:

    ```bash
        # ISO 8601 format with milliseconds
        export LOGIT_DATE_FORMAT="%Y-%m-%dT%H:%M:%S.%3N"

        # Human-readable format with full weekday and month names
        export LOGIT_DATE_FORMAT="%A, %B %d %Y %H:%M:%S"

        # Compact format for filenames or logs
        export LOGIT_DATE_FORMAT="%Y%m%d_%H%M%S"

        # European format (day/month/year)
        export LOGIT_DATE_FORMAT="%d-%m-%Y %H:%M:%S"

        # US format (month/day/year)
        export LOGIT_DATE_FORMAT="%m-%d-%Y %I:%M:%S %p"

        # Time only (24-hour)
        export LOGIT_DATE_FORMAT="%H:%M:%S"

        # Time only (12-hour with AM/PM)
        export LOGIT_DATE_FORMAT="%I:%M:%S %p"

        # Date only
        export LOGIT_DATE_FORMAT="%Y-%m-%d"

        # Date and time with timezone
        export LOGIT_DATE_FORMAT="%Y-%m-%d %H:%M:%S %Z"

    ```

- **Silent Mode**: To suppress console output for non-error messages, set the `SHOW_MESSAGE` & `HIDE_INFO` variables:

    ```bash
    export SHOW_MESSAGE="true" # Set "true" to also show logs to user (stdout) or anything else to disable (ERROR messages will still be shown)
    export HIDE_INFO="true" # Set "true" with SHOW_MESSAGE to hide INFO messages from stdout
    ```

---

- **Log Size & Number of logs to keep**: To set the log size and amount of logs to keep for archiving, set the `MAX_LOG_FILES` & `LOG_SIZE` variables:

    ```bash
    export MAX_LOG_FILES="69" # Number of logs to keep as archive | Default is set to 3 log files
    export LOG_SIZE="69" # Size of each log file before rotating in MB | Default is set to 3MB
    ```

---

- **Debug Mode**: Debug mode will log every command, without its output `DEBUG_MODE` variable:

    ```bash
    export DEBUG_MODE="true" # Activates Debug mode | Default is set to "false"
    ```

---

### 🧑‍💻 **Autocompletion**

Logit supports Bash autocompletion for commands like `help`, `version`, and `update`. Autocompletion is enabled when using an interactive shell.

---

### 📜 **License**

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

### 👨‍💻 **Author**

- **Tal Mendelson**

---

### 📦 **Badges**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
[![Version](https://img.shields.io/badge/Version-0.1.2-blue.svg)](https://github.com/mendelsontal/devops_course/tree/logit-v0.1.2/bash/logit)