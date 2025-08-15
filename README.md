# Logit - A Lightweight Bash Logging Utility

<img src="https://img.shields.io/badge/Logit-Bash%20Logging%20Utility-blue" alt="Logit Logo" />

Logit is a lightweight and configurable Bash logging utility that enables structured logging with levels (INFO, DEBUG, WARN, ERROR). It supports automatic command logging, customizable timestamps, log rotation, and silent mode, making it ideal for script debugging and system monitoring.

---

### 🛠️ **Installation**

1. Download the `logit.sh` script or clone the repository:

    ```bash
    git clone https://github.com/mendelsontal/logit.git
    ```

2. Source the script in your `.bashrc` or `.bash_profile` file:

    ```bash
    # Example of sourcing logit in .bashrc
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
```

To start logging all executed commands, use:

```bash
logit start
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
```

To uninstall (not yet implemented):

```bash
logit uninstall
```

---

### ⚙️ **Configuration**

- **Log Location / Name**: By default, log entries are saved to the same folder your script ran from with the name of the script which ran them. You can override the log directory, name and file location by setting the `LOG_NAME`, `LOGFILE` and `LOGFILE` environment variables.

    ```bash
    export LOG_NAME="mylog" #.log is added by default
    export LOGFILE="/path/to/custom/"
    export ERROR_LOG_FILE="/path/to/custom/"
    ```

- **Timestamp Format**: You can customize the timestamp format used in log entries by setting the `LOGIT_DATE_FORMAT` variable:

    ```bash
    export LOGIT_DATE_FORMAT="%Y-%m-%d %H:%M:%S.%3N"
    ```

- **Silent Mode**: To suppress console output for non-error messages, set the `SHOW_MESSAGE` & `HIDE_INFO` variable:

    ```bash
    export SHOW_MESSAGE="true" # Set "true" to also show logs to user (stdout) or anything else to disable (Will still show ERROR messages)
    export HIDE_INFO="true" # Set "true" with SHOW_MESSAGE to hide INFO messages from stdout
    ```

---

### 🧑‍💻 **Autocompletion**

Logit supports Bash autocompletion for commands like `help`, `version`, `update`, and `uninstall`. Autocompletion is enabled when using an interactive shell.

---

### 📜 **License**

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

### 👨‍💻 **Author**

- **Tal Mendelson**

---

### 📦 **Badges**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
[![Version](https://img.shields.io/badge/Version-0.1.0-blue.svg)](https://github.com/mendelsontal/devops_course/tree/logit-v0.1.0/bash/logit)